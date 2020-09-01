import Foundation
import SpriteKit

class HeartShopUIManager: BaseUIManager{
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    
    public var homeButton: Button!
    public var backButton: Button!
    
    public var previousSceneName: String!

    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        
        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        backButton          = uiElementBuilder.Build(selectedButton: .backButton)
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(backButton)
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
        }
    }
}

