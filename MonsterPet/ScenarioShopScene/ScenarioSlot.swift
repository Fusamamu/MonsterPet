import Foundation
import SpriteKit

enum SceneSelectionPanels: String, CaseIterable {
    case publicPark = "parkScenarioImage"
    case comingSoon = "comingSoonScenePanel"
    case a          = "a"
    case b          = "b"
    case c          = "c"
    static var count: Int { return SceneSelectionPanels.comingSoon.hashValue + 1}
}

class ScenarioSlot: SKSpriteNode {
    
    public  var slotIndex    : Int!

    public var isComingSoon : Bool = true 
    public var isLock       : Bool = true { didSet { SetUnlockScenarioImage(by: 0)} }
    public var isSelected   : Bool = false
    
    public  var ClickedCount: Int{
        get { return clickedCount }
        set { if newValue > 2 { clickedCount = 0 } else { clickedCount = newValue } }
    }
    private var clickedCount: Int = 0
    
    public var coinRequired: CGFloat!
    
    private(set) var comingSoonImage    : SKTexture!
    private(set) var scenarioUnlockImage: SKSpriteNode!
    
    public var positionWhenInitialized: CGPoint!
    
    init(index: Int){

        comingSoonImage     = SKTexture(imageNamed: "comingSoonScenePanel")
        scenarioUnlockImage = SKSpriteNode(imageNamed: "parkScenarioImage")
        super.init(texture: comingSoonImage , color: .clear, size: comingSoonImage.size())
        
        //SetUnlockScenarioImage(by: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func SetUnlockScenarioImage(by index: Int){
        if !isLock {
            scenarioUnlockImage.setScale(1)
            scenarioUnlockImage.position.y += 24
            scenarioUnlockImage.zPosition = 100
            self.addChild(scenarioUnlockImage)
        }else{
            return
        }
    }
}
