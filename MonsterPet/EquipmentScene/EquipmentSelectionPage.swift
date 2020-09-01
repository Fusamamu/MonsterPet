import Foundation
import SpriteKit

class EquipmentSelectionPage: Page{
    
    var slots: [EquipmentSlot] = []
    
    let row     : Int = 2
    let column  : Int = 2
    
    let slotScale   : CGFloat = 0.17
    let slotPadding : CGFloat = 4.5
    let padding     : CGFloat = 105
    
    
    init(pageIndex: Int, equipmentIndex: Int, skScene: SKScene){
        super.init(index: pageIndex, skScene: skScene)
        GenerateSlots(from: equipmentIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    func GenerateSlots(from index: Int){
        
        var indexCount: Int = index
        
        for y in 0...column - 1{
            for x in 0...row - 1{
                
                let slot = EquipmentSlot(index: indexCount, skScene: currentSKScene)
                slot.setScale(slotScale)
                slot.zPosition = 40
                let x = CGFloat(x) * slot.lockImage.size().width/slotPadding + padding
                let y = 500 - CGFloat(y) * slot.lockImage.size().height/5.2
                
                slot.position = CGPoint(x: x, y: y)
                self.addChild(slot)
                
                indexCount += 1
                
                slots.append(slot)
                
            }
        }
    }
}

