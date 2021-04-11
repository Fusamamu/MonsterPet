import Foundation
import SpriteKit

class PetInfoPage: Page {
    
    var slots: [PetInfoSlot] = []
    
    private var petCount: Int = PetName.count
    
    init(pageIndex: Int, skScene: SKScene) {
        super.init(index: pageIndex, skScene: skScene)
        GenerateSlots(from: pageIndex)
    }
    
    init(pageIndex: Int, itemIndex: Int){
        super.init(index: pageIndex)
        self.GenerateSlots(from: itemIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GenerateSlots(from index: Int){
        
        for i in 0...2{
            let petInfoSlot = PetInfoSlot(index: index + i)
            petInfoSlot.setScale(0.16)
            petInfoSlot.zPosition = 200
            //should use "mid x" from base class "page"
            petInfoSlot.position.x = 200 + 60
            petInfoSlot.position.y += 500
            petInfoSlot.position.y -= CGFloat(i) * petInfoSlot.size.width/1.05
            
            slots.append(petInfoSlot)
            self.addChild(petInfoSlot)
        }
    }
}

