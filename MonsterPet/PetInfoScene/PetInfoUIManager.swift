import Foundation
import SpriteKit
import simd

class PetInfoUIManager: BaseUIManager{
    

    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    
    public var homeButton: Button!
    public var buyHeartButton: Button!
    
    var nextPageLeftButton  : Button!
    var nextPageRightButton : Button!
    
    var bottomBar: SKSpriteNode!
    var petInfoPanel : SKSpriteNode!
    var petInfoPanelSupport : SKSpriteNode!
   
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        
        homeButton      = uiElementBuilder.Build(selectedButton: .menuButton)
        buyHeartButton  = uiElementBuilder.Build(selectedButton: .buyHeartButton)
        
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(buyHeartButton)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        
        bottomBar = SKSpriteNode(imageNamed: "BottomBar")
        bottomBar.zPosition = 15
        bottomBar.setScale(0.15)
        bottomBar.position.x = mid_X
        bottomBar.position.y += 29
        currentSKScene.addChild(bottomBar)
        
        petInfoPanel = SKSpriteNode(imageNamed: "PetInfoPanel-1")
        petInfoPanel.zPosition = 200 //set back to 15 please
        petInfoPanel.setScale(0.15)
        petInfoPanel.position = CGPoint(x: mid_X, y: min_Y)
       // petInfoPanel.position.y -= 100
        currentSKScene.addChild(petInfoPanel)
        
        petInfoPanelSupport = SKSpriteNode(imageNamed: "PetInfoPanelSupport")
        petInfoPanelSupport.zPosition = 5
        petInfoPanelSupport.setScale(0.2)
        petInfoPanelSupport.position.x = mid_X
        petInfoPanelSupport.position.y = min_Y + 50
        currentSKScene.addChild(petInfoPanelSupport)
        
    }
    

    
    func CreateBackground(){
        let background = SKSpriteNode(imageNamed: "inventoryBackground")
        background.setScale(0.25)
        background.position = centerPosition
        background.position.y += 110
        background.zPosition = -10
        currentSKScene.addChild(background)
    }
    
    func UpdateTouch(at location: CGPoint){
        
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
    }
    
    func DisplayPetInfoPanel(){
        petInfoPanel.run(SKEase.move(easeFunction: .curveTypeElastic, easeType: .easeTypeOut, time: 1, from: petInfoPanel.position, to: CGPoint(x: mid_X, y: mid_Y )))
    }
    
    func UnDisplayPetInfoPanel(){
        
        petInfoPanel.run(SKEase.move(easeFunction: .curveTypeElastic, easeType: .easeTypeInOut, time: 1, from: petInfoPanel.position, to: CGPoint(x: mid_X, y: min_Y - 150 )))
    }
    
}

