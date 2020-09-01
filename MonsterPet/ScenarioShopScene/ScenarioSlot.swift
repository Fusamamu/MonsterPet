import Foundation
import SpriteKit

enum SceneSelectionPanels: String, CaseIterable {
    case publicPark = "publicPark"
    case comingSoon = "comingSoonScenePanel"
    case a          = "a"
    case b          = "b"
    case c          = "c"
    static var count: Int { return SceneSelectionPanels.comingSoon.hashValue + 1}
}


class ScenarioSlot: SKSpriteNode {
    

    
    public var isUnLock: Bool!
    public var coinRequired: CGFloat!
    
    private(set) var slotImage   : SKTexture!
    private(set) var lockImage   : SKTexture!
    private(set) var comingSoonImage: SKTexture!
    
    public var positionWhenInitialized: CGPoint!
    
    init(index: Int){
        slotImage = SKTexture(imageNamed: SceneSelectionPanels.allCases[index].rawValue)
        lockImage = SKTexture(imageNamed: "lockImage")
        comingSoonImage = SKTexture(imageNamed: "comingSoonScenePanel")
        super.init(texture: comingSoonImage , color: .clear, size: comingSoonImage.size())
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
