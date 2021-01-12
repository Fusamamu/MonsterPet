//
//  EquipmentDetailScene.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 3/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class EquipmentDetailScene: SKScene, Observer{
    
    var id: Int = 0
    
    private var currenyManager      : CurrencyManager       = .sharedInstance
    private let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    private let itemManager         : ItemManager           = .sharedInstance
    private let equipmentManager    : EquipmentManager      = .sharedInstance
    private let layerManager        : LayerManager          = .sharedInstance
    
    private var uiManager           : EquipDetailSceneUIManager!
    
    private var sceneBuilder: SceneBuilder!
    
    public var currentEquipment     : Equipment!
    public var currentEquipmentIndex: Int!
   
    
    private var coinCountLabel : BMGlyphLabel!
    private var backgroundImage: SKSpriteNode!
    
    private var notEnoughCoinWarning        : WarnPanel!
    private var notEnoughIngredientWarning  : WarnPanel!
    private var notEnoughInventoryWarning    : WarnPanel!
    
    


    

    
    override func didMove(to view: SKView) {
        sceneBuilder    = SceneBuilder(currentSKScene: self)
        
        self.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 190/255, alpha: 1)
    
        if currentEquipment == nil{
            currentEquipment = Equipment(index: currentEquipmentIndex)
            currentEquipment.setScale(0.17)
            currentEquipment.zPosition = layerManager.layer_2
            currentEquipment.position = CGPoint(x: frame.midX, y: frame.midY)
            currentEquipment.position.y += 180
            addChild(currentEquipment)
        }
        
        uiManager = EquipDetailSceneUIManager(skScene: self)
        uiManager.currentEquipment = currentEquipment
        uiManager.EncodeItemNameToButtons()
        uiManager.LoadTextToLabels()
        
        coinCountLabel = BMGlyphLabel(txt: String(currenyManager.CoinCounts), fnt: BMGlyphFont(name: "TitleText"))
        coinCountLabel.setHorizontalAlignment(.right)
        coinCountLabel.position = uiManager.upperLeftPosition
        coinCountLabel.position.x += 145
        coinCountLabel.position.y -= 38
        coinCountLabel.zPosition = 200
        coinCountLabel.setScale(1)
        currenyManager.AddObserver(observer: self)
        addChild(coinCountLabel)
        
        LoadRecipeImages()
        CreateBackground()
        
        
        notEnoughCoinWarning = WarnPanel(panelImage: "notEnoughCoin", skScene: self)
        notEnoughCoinWarning.setScale(0.15)
        notEnoughCoinWarning.zPosition = 300
        
        notEnoughIngredientWarning = WarnPanel(panelImage: "missingIngredientPanel", skScene: self)
        notEnoughIngredientWarning.setScale(0.15)
        notEnoughIngredientWarning.zPosition = 300
        
        notEnoughInventoryWarning = WarnPanel(panelImage: "outOfStockPanel", skScene: self)
        notEnoughInventoryWarning.setScale(0.15)
        notEnoughInventoryWarning.zPosition = 300

       
                               
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        
        
        switch uiManager.uiState{
            case .allClosed:
                if uiManager.currentSelectedButton != nil && uiManager.currentSelectedButton.isSeleted{
                    
                    //When press "PlaceButton"//
                    if uiManager.placeButton.contains(location!){
                        
                        let recipeName = uiManager.currentSelectedButton.itemName
                        let recipeCount = equipmentManager.RecipeCountInventory[RecipeName.init(rawValue: recipeName)!]!
                        
                        if recipeCount > 0 {
                            
                            //This logic should be called when place on Arrow image//
                            equipmentManager.RecipeCountInventory[RecipeName.init(rawValue: recipeName)!]! -= 1
                            //-------------------------------------------------//
                            
                            let equipmentWithCompleteRecipe = Equipment(WithRecipeName: uiManager.currentSelectedButton.itemName)
                            LoadGameScene(with: equipmentWithCompleteRecipe)
                        }else{
                            if !notEnoughInventoryWarning.isOpened{
                                notEnoughInventoryWarning.Invoked()
                            }
                            uiManager.uiState = .warningPanelOpened
                        }
                        
                        
                     
                    }
                    //------------------------//
                    
                    
                    
                    
                    //When press"BuyButton"//
                    if uiManager.buyButton.contains(location!){
                        
                        let equipmentDict           = GetEquipmentDic(by: currentEquipment.equipmentName.rawValue)
                        let ingredientRequireDict   = equipmentDict["IngredientRequirements"] as! [String:Any]
                        
                        let recipe_keys     = ["recipe_1", "recipe_2", "recipe_3"]
                        let recipeDict      = ingredientRequireDict[recipe_keys[uiManager.currentSelectedButton.index]] as! [String:Any]
                        let coinRequired    = recipeDict["coin"] as! Int
                        
                        let isEnougCoin =  currenyManager.CoinCounts >= coinRequired ? true : false
                        
                        if isEnougCoin {
                            print("buyButton was Clicked")
                
                            currenyManager.CoinCounts -= coinRequired
                            
                            let recipeName = uiManager.currentSelectedButton.itemName
                            equipmentManager.IncreaseRecipeQuantity(for: recipeName, by: 1)
                            
                            for buttonDelegate in uiManager.buyButton.buttonDelegates!{
                                if buttonDelegate is GotItPanel{
                                    let texture = SKTexture(imageNamed: recipeName)
                                    (buttonDelegate as! GotItPanel).gotIt_Item.texture = texture
                                    (buttonDelegate as! GotItPanel).gotIt_Item.size = CGSize(width: texture.size().width/4, height: texture.size().height/4)
                                }
                            }

                            uiManager.buyButton.OnClicked(at: location!)
                            uiManager.uiState = .gotItPanelOpened
                        }else{
                            
                            
                            //Show warning Panel Not enough Coin
                            
                            if !notEnoughCoinWarning.isOpened {
                                notEnoughCoinWarning.Invoked()
                            }
                            uiManager.uiState = .warningPanelOpened
                            
                        }
                        
                        
                    }
                    //----------------------//
                    
                    
                    
                    
                    
                    //When press "MakeButton"//
                    if uiManager.makeButton.contains(location!){
                        print("MakeButton was Clicked")
                        
                        if !notEnoughIngredientWarning.isOpened{
                            notEnoughIngredientWarning.Invoked()
                        }
                        uiManager.uiState = .warningPanelOpened
                        
                    }
                    //-----------------------//
                }
                
      
                print("all closed")
            case .requirementPanelOpened:
                print("requirementPanelOpend")
            
            case .gotItPanelOpened:
                uiManager.gotItPanel.Invoked()
                uiManager.uiState = .allClosed
                
                uiManager.UpdateQuantityCount()
                print("gotItPanelOpend")
                
                
            case .warningPanelOpened:
                if notEnoughCoinWarning.isOpened {
                    notEnoughCoinWarning.Invoked()
                }
                
                if notEnoughIngredientWarning.isOpened {
                    notEnoughIngredientWarning.Invoked()
                }
                
                if notEnoughInventoryWarning.isOpened {
                    notEnoughInventoryWarning.Invoked()
                }
                
                uiManager.uiState = .allClosed
                
                print("warningPanelOpened")
                
        }
        
        uiManager.UpdateTouch(at: location!)
        
    }
    
    //Called When CoinCounts Change value
    func Update() {
        coinCountLabel.setGlyphText("\(String(describing: currenyManager.CoinCounts))")
    }
    
    private func LoadRecipeImages(){

//        let nabe = GetEquipmentDic(by: "Nabe")
//        let text = nabe["Text"] as! [String:Any]
////        let keys = ["recipe1", "recipe2", "recipe3"]
//
//        for i in 0...uiManager.recipeSelectButtons.count - 1{
//            if(EquipmentName.allCases[currentEquipment.equipmentIndex].rawValue == "nabe"){
//                let recipeName = text[keys[i]] as! String
//
//                let recipeImage = SKSpriteNode(imageNamed: recipeName)
//                recipeImage.setScale(0.4)
//                recipeImage.zPosition = layerManager.layer_2
//                recipeImage.position = CGPoint(x: -530, y: -20)
//                uiManager.recipeSelectButtons[i].addChild(recipeImage)
//                uiManager.recipeSelectButtons[i].itemName = recipeName
//
//            }else{
//                let recipeImage = SKSpriteNode(imageNamed: EquipmentName.allCases[currentEquipment.equipmentIndex].rawValue)
//                recipeImage.setScale(0.4)
//                recipeImage.zPosition = layerManager.layer_2
//                recipeImage.position = CGPoint(x: -530, y: -20)
//                uiManager.recipeSelectButtons[i].addChild(recipeImage)
//            }
            
            let selectedEquipment = GetEquipmentDic(by: currentEquipment.equipmentName.rawValue)
            let text_fromPlist = selectedEquipment["Text"] as! [String:Any]
            let keys = ["recipe1", "recipe2", "recipe3"]
        
        for i in 0...uiManager.recipeSelectButtons.count - 1{
            let recipeName = text_fromPlist[keys[i]] as! String
            
            let recipeImage = SKSpriteNode(imageNamed: recipeName)
            recipeImage.setScale(0.4)
            recipeImage.zPosition = layerManager.layer_2
            recipeImage.position = CGPoint(x: -530, y: -20)
            uiManager.recipeSelectButtons[i].addChild(recipeImage)
            uiManager.recipeSelectButtons[i].itemName = recipeName
        }
            
            
            
        
    }
    
    private func GetEquipmentDic(by name: String)->[String:Any]{
        
        let path = Bundle.main.path(forResource: "GameData", ofType: "plist")
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        let equipmentDict   = dict.object(forKey: "Equipments") as! [String:Any]
        
        return equipmentDict[name] as! [String:Any]
    }
    

    
    func LoadGameScene(with selectedEquip: Equipment){
        let mainScene = SceneBuilder(currentSKScene: self).Create(selectedScene: .mainScene)
        PlaceHolderManager.sharedInstance.AddArrowImages(to: mainScene)
        EquipmentManager.sharedInstance.tempEquipmentHolder = selectedEquip
        view?.presentScene(mainScene)
    }
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "panBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.15
            background.zPosition = -30
            background.setScale(scale)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width*scale * CGFloat(i)) , y: 0)
            self.addChild(background)
            
            let moveLeft    = SKAction.moveBy(x: -backgroundTexture.size().width*scale, y: 0, duration: 8)
            let moveReset   = SKAction.moveBy(x: backgroundTexture.size().width*scale, y: 0, duration: 0)
            let moveLoop    = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
}


