import Foundation
import GameplayKit
import SpriteKit

class EquipmentUIManager: BaseUIManager{
    
    private let layerManager: LayerManager = .sharedInstance
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    private var labelBuilder        : LabelBuilder!
    
    enum EquipmentUIState{
        case allClose
        case unpackMenuOpend
    }
    
    public var state: EquipmentUIState = .allClose
    
    
    public var homeButton       : Button!
    public var buyHeartButton   : Button!
    public var nextPageLeftButton  : Button!
    public var nextPageRightButton : Button!
    
    private var titleIcon        : SKSpriteNode!
    private var pageCountBar     : SKSpriteNode!
    private var background       : SKSpriteNode!
    private var dialogueBlock    : SKSpriteNode!
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton      = uiElementBuilder.Build(selectedButton: .menuButton)
        buyHeartButton  = uiElementBuilder.Build(selectedButton: .buyHeartButton)
        
        background      = uiElementBuilder.Build(seletedUiElement: .inventoryBackground)
        dialogueBlock   = uiElementBuilder.Build(seletedUiElement: .dialogueBox)
        
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        pageCountBar        = uiElementBuilder.Build(seletedUiElement: .pageCountBar)
        
        titleIcon       = uiElementBuilder.Build(seletedUiIcon: .equipmentTitleIcon)
        
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(buyHeartButton)
        currentSKScene.addChild(background)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        currentSKScene.addChild(pageCountBar)
        currentSKScene.addChild(dialogueBlock)
        currentSKScene.addChild(titleIcon)
        
        SetUILayers()
        
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("TOOL")
        titleLabel.zPosition = layerManager.layer_9
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 50
        titleLabel.position.y -= 8
        currentSKScene.addChild(titleLabel)
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if buyHeartButton.contains(location){
            let nextScene = sceneBuilder.Create(selectedScene: .heartShopScene) as! HeartShopScene
            nextScene.previousSceneName = "EquipmentMenuScene"
            currentSKScene.view?.presentScene(nextScene)
        }
    }
    
    private func SetUILayers(){
        titleIcon.zPosition         = layerManager.layer_8
        homeButton.zPosition        = layerManager.layer_9
        buyHeartButton.zPosition    = layerManager.layer_9
        
        nextPageLeftButton.zPosition    = layerManager.layer_9
        nextPageRightButton.zPosition   = layerManager.layer_9
        
        pageCountBar.zPosition          = layerManager.layer_8
        background.zPosition            = layerManager.layer_2
        dialogueBlock.zPosition         = layerManager.layer_3
        


    }
}
