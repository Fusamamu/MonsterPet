import Foundation
import SpriteKit

class HeartShopUIManager: BaseUIManager{
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    private var labelBuilder        : LabelBuilder!
    private var layerManager        : LayerManager = .sharedInstance
    
    public var homeButton: Button!
    public var backButton: Button!
    var nextPageLeftButton  : Button!
    var nextPageRightButton : Button!
    
    var titleIcon           : SKSpriteNode!
    var pageCountBar        : SKSpriteNode!
    
    public var previousSceneName: String!

    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        backButton          = uiElementBuilder.Build(selectedButton: .backButton)
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        
        
        titleIcon           = uiElementBuilder.Build(seletedUiIcon: .coinTitleIcon)
        pageCountBar        = uiElementBuilder.Build(seletedUiElement: .pageCountBar)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(backButton)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        
        currentSKScene.addChild(titleIcon)
        currentSKScene.addChild(pageCountBar)
        
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("HEART STORE")
        titleLabel.setScale(0.8)
        titleLabel.zPosition = layerManager.layer_9
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 50
        titleLabel.position.y -= 13
        currentSKScene.addChild(titleLabel)
        
        SetUILayers()
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if backButton.contains(location){
            if previousSceneName != nil && previousSceneName == "FoodMenuScene"{
                currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .foodMenuScene))
            }
            
            if previousSceneName != nil && previousSceneName == "EquipmentMenuScene"{
                currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .equipmentScene))
            }
            
            if previousSceneName != nil && previousSceneName == "ScenarioShopScene"{
                currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .scenarioShopScene))
            }
        }
    }
    
    private func SetUILayers(){
        
        titleIcon.zPosition             = layerManager.layer_8
            
        homeButton.zPosition            = layerManager.layer_9
       
    }
}

