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
        
        coinCountLabel = BMGlyphLabel(txt: String(currenyManager.CoinCounts), fnt: BMGlyphFont(name: "petText"))
        coinCountLabel.setHorizontalAlignment(.right)
        coinCountLabel.position = uiManager.upperLeftPosition
        coinCountLabel.position.x += 145
        coinCountLabel.position.y -= 38
        coinCountLabel.zPosition = 200
        coinCountLabel.setScale(0.5)
        currenyManager.AddObserver(observer: self)
        addChild(coinCountLabel)
        
        LoadRecipeImages()
        CreateBackground()
        

       
                               
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        
        
        switch uiManager.uiState{
            case .allClosed:
                if uiManager.currentSelectedButton != nil && uiManager.currentSelectedButton.isSeleted{
                    
                    if uiManager.placeButton.contains(location!){
                        let equipmentWithCompleteRecipe = Equipment(WithRecipeName: uiManager.currentSelectedButton.itemName)
                        LoadGameScene(with: equipmentWithCompleteRecipe)
                    }
                    
                    if uiManager.buyButton.contains(location!){
                        print("buyButton was Clicked")
                        if currenyManager.CoinCounts >= 10{
                            currenyManager.CoinCounts -= 10
                        }
                        
                        let recipeName = uiManager.currentSelectedButton.itemName

                    //    equipmentManager.IncreaseRecipeQuantity(for: recipeName, by: 1)
                        
                        
                        for buttonDelegate in uiManager.buyButton.buttonDelegates!{
                            if buttonDelegate is GotItPanel{
                                (buttonDelegate as! GotItPanel).gotIt_Item.texture = SKTexture(imageNamed: recipeName)
                            }
                        }

                        uiManager.buyButton.OnClicked(at: location!)
                        uiManager.uiState = .gotItPanelOpened
                    }
                    
                    if uiManager.makeButton.contains(location!){
                        print("MakeButton was Clicked")
                    }
                }
                
      
                print("all closed")
            case .requirementPanelOpened:
                print("requirementPanelOpend")
            
            case .gotItPanelOpened:
                uiManager.gotItPanel.Invoked()
                uiManager.uiState = .allClosed
                
                uiManager.UpdateQuantityCount()
                print("gotItPanelOpend")
                
        }
        
        uiManager.UpdateTouch(at: location!)
        
    }
    
    //Called When CoinCounts Change value
    func Update() {
        coinCountLabel.setGlyphText("\(String(describing: currenyManager.CoinCounts))")
    }
    
    private func LoadRecipeImages(){

        let path = Bundle.main.path(forResource: "GameData", ofType: "plist")
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        let equipmentDict   = dict.object(forKey: "Equipments") as! [String:Any]
        let nabe    = equipmentDict["Nabe"] as! [String:Any]
        let text = nabe["Text"] as! [String:Any]
        let keys = ["recipe1", "recipe2", "recipe3"]
        
        for i in 0...uiManager.recipeSelectButtons.count - 1{
            if(EquipmentName.allCases[currentEquipment.equipmentIndex].rawValue == "nabe"){
                let recipeName = text[keys[i]] as! String
                
                let recipeImage = SKSpriteNode(imageNamed: recipeName)
                recipeImage.setScale(0.4)
                recipeImage.zPosition = layerManager.layer_2
                recipeImage.position = CGPoint(x: -530, y: -20)
                uiManager.recipeSelectButtons[i].addChild(recipeImage)
                uiManager.recipeSelectButtons[i].itemName = recipeName
                
            }else{
                let recipeImage = SKSpriteNode(imageNamed: EquipmentName.allCases[currentEquipment.equipmentIndex].rawValue)
                recipeImage.setScale(0.4)
                recipeImage.zPosition = layerManager.layer_2
                recipeImage.position = CGPoint(x: -530, y: -20)
                uiManager.recipeSelectButtons[i].addChild(recipeImage)
            }
            
            
        }
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


