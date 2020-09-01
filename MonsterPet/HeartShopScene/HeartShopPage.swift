import Foundation
import SpriteKit

class HeartShopPage: BaseUIManager{
 
    
    public var slots: [BuyHeartSlot]!
    public var slotCount: Int = 3
    
    private var slotPadding: CGFloat = 1.7
    
    override init(skScene: SKScene){
        super.init(skScene: skScene)
        slots = []
        GenerateBuyHeartSlots(from: 0)
    }
    
    func GenerateBuyHeartSlots(from index: Int){
        
        for i in 0...slotCount - 1{
            let slot = BuyHeartSlot(index: i)
            slot.setScale(0.18)
            slot.zPosition = 5
            slot.position.x = mid_X - 10
            slot.position.y = max_Y - CGFloat(i) * slot.size.width/slotPadding - 170
            slot.positionWhenInitialized = slot.position
            
            slots.append(slot)
            currentSKScene.addChild(slot)
            
        }
    }
}
