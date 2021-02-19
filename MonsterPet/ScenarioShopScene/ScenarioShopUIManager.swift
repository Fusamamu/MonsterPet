import Foundation
import SpriteKit

class ScenarioShopUIManager: BaseUIManager{
    
    private let layerManager: LayerManager = .sharedInstance
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    private var labelBuilder        : LabelBuilder!
    
    public var homeButton: Button!
    public var buyHeartButton   : Button!
    var nextPageLeftButton  : Button!
    var nextPageRightButton : Button!
    
    
    private var titleIcon        : SKSpriteNode!
    var pageCountBar        : SKSpriteNode!
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton      = uiElementBuilder.Build(selectedButton: .menuButton)
        buyHeartButton  = uiElementBuilder.Build(selectedButton: .buyHeartButton)
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        
        titleIcon       = uiElementBuilder.Build(seletedUiIcon: .scenarioTitleIcon)
        pageCountBar        = uiElementBuilder.Build(seletedUiElement: .pageCountBar)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(buyHeartButton)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        
        currentSKScene.addChild(titleIcon)
        currentSKScene.addChild(pageCountBar)
        
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("SCENARIO")
        titleLabel.zPosition = layerManager.layer_9
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 80
        titleLabel.position.y -= 8
        
        currentSKScene.addChild(titleLabel)
        
        SetUILayers()
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
    }
    
    private func SetUILayers(){
        
        homeButton.zPosition        = layerManager.layer_9
        buyHeartButton.zPosition    = layerManager.layer_9
        
        titleIcon.zPosition         = layerManager.layer_8
        

    }
}

