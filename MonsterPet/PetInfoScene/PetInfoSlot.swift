import Foundation
import SpriteKit

class PetInfoSlot: SKSpriteNode, Observer{
    
    
    var id: Int = 0;
    
    public var slotDelegates: [ButtonDelegate]?
    
    public var isLock      : Bool  = true
    public var isTouchable : Bool  = true
    
    public var slotIndex : Int!


    
    private(set) var slotImage   : SKTexture!
    private(set) var lockImage   : SKTexture!
    
    private var slotScale: CGFloat = 0.18
    
    
    
    init(index: Int){
        slotIndex = index
        slotImage = SKTexture(imageNamed: "PetInfoPanel")
        lockImage = SKTexture(imageNamed: "default")
        super.init(texture: slotImage, color: .clear, size: slotImage.size())
        self.setScale(slotScale)
        self.zPosition = 40
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Update() {
        
    }
    
    
}
