//
//  EquipDetailSceneUIManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 3/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class EquipDetailSceneUIManager: BaseUIManager{
    
    private var layerManager        : LayerManager      = .sharedInstance
    private var equipmentManager    : EquipmentManager  = .sharedInstance
    
    private var equipmentData: [String:Any]!
    
    private var sceneBuilder        : SceneBuilder!
    private var uiElementBuilder    : UIElementBuilder!
    private var labelBuilder        : LabelBuilder!
    
    private var detailPanel     : SKSpriteNode!
    public var gotItPanel: GotItPanel!
    private var alphaBlackPanel : Panel!
    private var equipmentFloorImage: SKSpriteNode!
    private var backgroundImage : SKSpriteNode!
    private var bottomBar       : SKSpriteNode!
    
   
    private var currencyIcon    : SKSpriteNode!
    private var bar_1           : SKSpriteNode!
    private let barScale:CGFloat = 0.3
    
    public var homeButton      : Button!
    public var backButton      : Button!
    public var placeButton     : Button!
    public var buyButton       : Button!
    public var makeButton      : Button!
    
    private var selectionHighLight  : SKSpriteNode!
    private var requirementPanel    : RecipeDetailPanel!
    
    public var recipeSelectButtons : [Button] = []
    public var currentSelectedButton: Button!

    private var description         : BMGlyphLabel!
    private var recipeLabels        : [BMGlyphLabel] = []
    private var quantityLabels      : [BMGlyphLabel] = []
    
    enum UIState{
        case allClosed
        case requirementPanelOpened
        case gotItPanelOpened
        case warningPanelOpened
    }
    public var uiState : UIState = .allClosed
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        equipmentData       = GetEquipmentDicData()
        
        sceneBuilder        = SceneBuilder(currentSKScene: skScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        backButton          = uiElementBuilder.Build(selectedButton: .backButton)
        
        placeButton         = uiElementBuilder.Build(selectedButton: .placeItemButton)
        buyButton           = uiElementBuilder.Build(selectedButton: .buyItemButton)
        makeButton          = uiElementBuilder.Build(selectedButton: .makeItemButton)
        
        bottomBar           = uiElementBuilder.Build(seletedUiElement: .bottomBar)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(backButton)
        currentSKScene.addChild(bottomBar)
        currentSKScene.addChild(placeButton)
        currentSKScene.addChild(buyButton)
        currentSKScene.addChild(makeButton)
        
        InitializeBasicUIElements()
        InitializeDetailPanel()
        InitializeLabels()
        SetUpButtonDelegation()
        
        EncodeItemNameToButtons()
        
        LoadTextToLabels()
        LoadQuantityCount()
        
        SetUILayers()
        

        
        
    }
    
    func UpdateTouch(at location: CGPoint){
        
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if backButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .equipmentScene))
        }
        
        switch uiState{
            case .allClosed:
                
                if currentSelectedButton != nil && currentSelectedButton.isSeleted{
                    if !currentSelectedButton.contains(location){
                        RemoveHighLightSelection()
                        currentSelectedButton.isSeleted = false
                        currentSelectedButton = nil
                    }
                }
    
                for selectionButton in recipeSelectButtons{
                    if selectionButton.contains(location){
                        if !selectionButton.isSeleted{
                            AddHightLightSelectionButton(at: selectionButton.position)
                            selectionButton.isSeleted = true
                            currentSelectedButton = selectionButton
                        }else{
                            currentSelectedButton = nil
                            selectionButton.OnClicked(at: location)
                            selectionButton.isSeleted = false
                            uiState = .requirementPanelOpened
                        }
                    }else{
                        selectionButton.isSeleted = false
                    }
                }

            case .requirementPanelOpened:
                
                let locationInRequirementPanel = currentSKScene.convert(location, to: requirementPanel)
                
                if requirementPanel.closeButton != nil && requirementPanel.closeButton.contains(locationInRequirementPanel){
                    if requirementPanel.closeButton.buttonDelegates!.count < 2{
                        requirementPanel.closeButton.SubscribeButton(target: alphaBlackPanel)
                    }
                    requirementPanel.closeButton.OnClicked(at: locationInRequirementPanel)
                    RemoveHighLightSelection()
                    uiState = .allClosed
                }
            case .gotItPanelOpened:
                print("gotItPanelOpened")
                
            case .warningPanelOpened:
                print("warningPanelOpened")
            }
    }
    
    
    private func SetUpButtonDelegation(){
        gotItPanel = GotItPanel()
        gotItPanel.currentSKScene = currentSKScene
        buyButton.SubscribeButton(target: gotItPanel)
    }
    
    
    private func InitializeBasicUIElements(){
        currencyIcon    = uiElementBuilder.Build(seletedUiIcon: .coin)
        bar_1           = uiElementBuilder.Build(seletedUiElement: .bar)
       // currencyIcon.position.y += 33
        
        bar_1.position.y -= 10
        bar_1.addChild(currencyIcon)
        
        currentSKScene.addChild(bar_1)

        equipmentFloorImage = SKSpriteNode(imageNamed: "equipmentFloor")
        equipmentFloorImage.setScale(0.2)
        equipmentFloorImage.zPosition = layerManager.layer_0
        equipmentFloorImage.position = centerPosition
        equipmentFloorImage.position.y += 150
        currentSKScene.addChild(equipmentFloorImage)
    }
    
    private func InitializeDetailPanel(){
        
        detailPanel = SKSpriteNode(imageNamed: "detailPanel")
        detailPanel.setScale(0.13)
        detailPanel.position = centerPosition
        detailPanel.position.y -= 80
        detailPanel.zPosition = 1
        currentSKScene.addChild(detailPanel)
        
        alphaBlackPanel = Panel(panelImage: "AlphaBlack", skScene: currentSKScene)
        alphaBlackPanel.zPosition = layerManager.layer_4
        alphaBlackPanel.position = centerPosition
        alphaBlackPanel.color = .black
        alphaBlackPanel.size = alphaBlackPanel.texture!.size()
        alphaBlackPanel.setScale(1.5)
        alphaBlackPanel.alpha = 0.5
        
        selectionHighLight = SKSpriteNode(imageNamed: "equipmentFoodMenuButtonHighlight")
        selectionHighLight.setScale(0.13)
        selectionHighLight.zPosition = 2
        
        guard let currentEquipmentIndex = (currentSKScene as! EquipmentDetailScene).currentEquipment.equipmentIndex
        else { return }
        
        requirementPanel = RecipeDetailPanel(panelImage: "recipeRequirementPanel", skScene: currentSKScene)
        requirementPanel.currentEquipmentIndex = currentEquipmentIndex
        requirementPanel.setScale(0.13)
        requirementPanel.position = centerPosition
        requirementPanel.position.y += 110
        requirementPanel.zPosition = 15
        
        for i in 0...2{

            let selectionButton = Button(DefaultImage: "equipmentFoodMenuButton")

            selectionButton.setScale(0.13)
            selectionButton.position = centerPosition
            selectionButton.position.y -= 180
            selectionButton.position.y += CGFloat(i) * selectionButton.size.width/3
            selectionButton.zPosition = 3
            selectionButton.SubscribeButton(target: requirementPanel)
            selectionButton.SubscribeButton(target: alphaBlackPanel)
            
    

            currentSKScene.addChild(selectionButton)
            recipeSelectButtons.append(selectionButton)

        }
    }
    
    private func InitializeLabels(){
        
        description             = labelBuilder.Build(selectedLabel: .equipmentNameLabel)
        description.setHorizontalAlignment(BMGlyphLabel.BMGlyphHorizontalAlignment.centered)
        description.position    = centerPosition
        description.position.y += 30
        description.setScale(0.55)
        description.setGlyphText("Whatever")
        
        recipeLabels.append(description)
        currentSKScene.addChild(description)
        
        //node increase abnormally start here. dont' know why
        for i in 0...2{
            let recipeLabel         = labelBuilder.Build(selectedLabel: .equipmentNameLabel)
        
            recipeLabel.setScale(0.5)
            recipeLabel.position    = recipeSelectButtons[i].position
            recipeLabel.setGlyphText("Default Text")

            recipeLabels.append(recipeLabel)
            currentSKScene.addChild(recipeLabel)

            let quantityLabel       = labelBuilder.Build(selectedLabel: .itemCountLabel)
            quantityLabel.setScale(0.7)
            quantityLabel.zPosition = layerManager.layer_4
            quantityLabel.position = recipeLabel.position
            quantityLabel.position.x += 85
            
            let number = 1
            quantityLabel.setGlyphText("x\(String(describing: number))")
            //pageCountLabel.setGlyphText("\(String(describing: currentPageIndex))|\(String(describing: maxPageNumber))")
            quantityLabels.append(quantityLabel)
            currentSKScene.addChild(quantityLabel)
        }
    }
    
    
    private func LoadTextToLabels(){
        let path                = Bundle.main.path(forResource: "GameData", ofType: "plist")
        let dict:NSDictionary   = NSDictionary(contentsOfFile: path!)!
        
        let equipmentDict       = dict.object(forKey: "Equipments") as! [String:Any]
        let ironPan             = equipmentDict["IronPan"] as! [String:Any]


        
        let text = ironPan["Text"] as! [String:Any]
        
        let keys = ["Description", "recipe1", "recipe2", "recipe3"]

        var i = 0;
        for key in keys{

            let value = text[key] as! String

            recipeLabels[i].setGlyphText(value)


            i += 1
        }
        
        
    }
    
    private func LoadQuantityCount(){
//        let ironPan         = equipmentData["IronPan"] as! [String:Any]
//        let keys            = ["recipe1", "recipe2", "recipe3"]
//        let recipeInventory = ironPan["RecipeInventory"] as! [String:Any]
//
////        for i in 0...2{
//            quantityLabels[i].setGlyphText("x\(String(describing: recipeInventory[keys[i]]!))")
//        }
        
        for i in 0...2{
            
            let recipeCount = equipmentManager.RecipeCountInventory[RecipeName.allCases[i]]
            
            quantityLabels[i].setGlyphText("x" + String(recipeCount!))
        }
    }
    
    
    public func UpdateQuantityCount(){
        for i in 0...2{
            
            let recipeCount = equipmentManager.RecipeCountInventory[RecipeName.allCases[i]]
            
            quantityLabels[i].setGlyphText("x" + String(recipeCount!))
        }
    }
    
    private func EncodeItemNameToButtons(){
        let ironPan = equipmentData["IronPan"] as! [String:Any]
        let keys    = ["recipe1", "recipe2", "recipe3"]
        let text    = ironPan["Text"] as! [String:Any]
        
        for i in 0...2{
            let recipeName = text[keys[i]] as! String
            recipeSelectButtons[i].itemName = recipeName
        }
    }
    
    private func GetEquipmentDicData() -> [String:Any]{
        let path                = Bundle.main.path(forResource: "GameData", ofType: "plist")
        let dict:NSDictionary   = NSDictionary(contentsOfFile: path!)!
        let equipmentDict       = dict.object(forKey: "Equipments") as! [String:Any]
        return equipmentDict
    }
    
    
    private func AddHightLightSelectionButton(at location: CGPoint){
          
        if !currentSKScene.contains(selectionHighLight){
            currentSKScene.addChild(selectionHighLight)
        }
        
        selectionHighLight.position = location
        
        let scaleUp     = SKAction.scale(to: 0.1325, duration: 0.5)
        let scaleDown   = SKAction.scale(to: 0.122, duration: 0.5)
        let loop        = SKAction.sequence([scaleUp,scaleDown])
        
        selectionHighLight.run(SKAction.repeatForever(loop))

    }
    
    private func RemoveHighLightSelection(){
        selectionHighLight.removeAllActions()
        selectionHighLight.removeFromParent()
    }
    
    private func SetUILayers(){

        currencyIcon.zPosition      = layerManager.layer_9
        bar_1.zPosition             = layerManager.layer_8
        
        homeButton.zPosition        = layerManager.layer_9
        backButton.zPosition        = layerManager.layer_9
        placeButton.zPosition       = layerManager.layer_9
        buyButton.zPosition         = layerManager.layer_9
        makeButton.zPosition        = layerManager.layer_9
        
        bottomBar.zPosition         = layerManager.layer_8
        
        detailPanel.zPosition           = layerManager.layer_1
        equipmentFloorImage.zPosition   = layerManager.layer_1
        selectionHighLight.zPosition    = layerManager.layer_2
        
        for button in recipeSelectButtons{
            button.zPosition = layerManager.layer_3
        }
        
        description.zPosition   = layerManager.layer_4
        for label in recipeLabels{
            label.zPosition     = layerManager.layer_4
        }
        for label in quantityLabels{
            label.zPosition     = layerManager.layer_4
        }
        
        alphaBlackPanel.zPosition       = layerManager.layer_5
        requirementPanel.zPosition      = layerManager.layer_6
    }
}
