import Foundation
import SpriteKit

class SceneBuilder{
    
    private var currentSKScene: SKScene!
    private var viewSize: CGSize!
    
    
    enum SceneNames{
        case mainScene
        case foodMenuScene
        case equipmentScene
        case petInfoScene
        case giftScene
        case scenarioShopScene
        case gameSettingScene
        case heartShopScene
    }
    
    init(currentSKScene: SKScene){
        self.currentSKScene = currentSKScene
        viewSize = currentSKScene.view?.bounds.size
    }
    
    
    public func Create(selectedScene: SceneNames) -> SKScene{
        switch selectedScene {
            
            case .mainScene:
                let mainScene = MainScene(size: viewSize)
                mainScene.scaleMode = .aspectFill
                return mainScene
            case .foodMenuScene:
                let foodMenuScene = FoodMenuScene(size: viewSize)
                foodMenuScene.scaleMode = .aspectFill
                return foodMenuScene
            case .equipmentScene:
                let equipmentScene = EquipmentMenuScene(size: viewSize)
                equipmentScene.scaleMode = .aspectFill
                return equipmentScene
            case .petInfoScene:
                let petInfoScene = PetInfoScene(size: viewSize)
                petInfoScene.scaleMode = .aspectFill
                return petInfoScene
            case .giftScene:
                let giftScene = GiftScene(size: viewSize)
                giftScene.scaleMode = .aspectFill
                return giftScene
            case .scenarioShopScene:
                let scenarioShopScene = ScenarioShopScene(size: viewSize)
                scenarioShopScene.scaleMode = .aspectFill
                return scenarioShopScene
            case .gameSettingScene:
                let gameSettingScene = GameSettingScene(size: viewSize)
                gameSettingScene.scaleMode = .aspectFill
                return gameSettingScene
            case .heartShopScene:
                let heartShopScene = HeartShopScene(size: viewSize)
                heartShopScene.scaleMode = .aspectFill
                return heartShopScene
        }
    }
}



