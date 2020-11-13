import Foundation
import SpriteKit
import simd

class PetInfoUIManager: BaseUIManager{
    

    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    private var labelBuilder        : LabelBuilder!
    
    public var homeButton: Button!
    public var giftButton: Button!
    
    var nextPageLeftButton  : Button!
    var nextPageRightButton : Button!
    
    var bottomBar: SKSpriteNode!
    var petInfoPanel : SKSpriteNode!
    var petInfoPanelSupport : SKSpriteNode!
   
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton      = uiElementBuilder.Build(selectedButton: .menuButton)
        giftButton  = uiElementBuilder.Build(selectedButton: .giftButton)
        
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(giftButton)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        
        bottomBar = SKSpriteNode(imageNamed: "BottomBar")
        bottomBar.zPosition = 15
        bottomBar.setScale(0.15)
        bottomBar.position.x = mid_X
        bottomBar.position.y += 29
        currentSKScene.addChild(bottomBar)
        
        
        let titleIcon = uiElementBuilder.Build(seletedUiIcon: .petInfoTitleIcon)
        currentSKScene.addChild(titleIcon)
        //need to link with iconBuilder!!!! see example in other UIscene
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("PETINFO")
        titleLabel.zPosition = 20
        titleLabel.setScale(0.8)
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 40
        titleLabel.position.y -= 30
        currentSKScene.addChild(titleLabel)
        
        
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
        
        if giftButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .giftScene))
        }
    }
    
    func DisplayPetInfoPanel(){
        petInfoPanel.run(SKEase.move(easeFunction: .curveTypeElastic, easeType: .easeTypeOut, time: 1, from: petInfoPanel.position, to: CGPoint(x: mid_X, y: mid_Y )))
    }
    
    func UnDisplayPetInfoPanel(){
        petInfoPanel.run(SKEase.move(easeFunction: .curveTypeElastic, easeType: .easeTypeInOut, time: 1, from: petInfoPanel.position, to: CGPoint(x: mid_X, y: min_Y - 150 )))
    }
    
}

