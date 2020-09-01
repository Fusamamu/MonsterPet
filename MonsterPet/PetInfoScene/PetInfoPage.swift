import Foundation
import SpriteKit

class PetInfoPage: Page {
    
//    var slots: [PetInfoSlot] = []
    
    private var petCount: Int = PetName.count
    
//    let slotScale   : CGFloat = 0.2
//    let slotPadding : CGFloat = 4.5
//    let padding     : CGFloat = 105
    
    public var petFamilyInfoPanel: SKSpriteNode!
    public var petCharacter: PetCharacterDisplay!
    public var defalultPetInfoPanel: SKSpriteNode!
    public var augmentedPetInfoPanel: SKSpriteNode!
    
    
    
    init(pageIndex: Int, skScene: SKScene) {
        super.init(index: pageIndex, skScene: skScene)
        
        petCharacter = PetCharacterDisplay(defaultCharacterImage: "OchiisanPenguinInfo", petInfoPage: self)
        petCharacter.setScale(0.15)
        petCharacter.zPosition = 15
        petCharacter.position.x = min_X + 100
        petCharacter.position.y = mid_Y
        
        currentSKScene.addChild(petCharacter)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func GenerateSlots(from index: Int){
//
//        for i in 0...3{
//            let petInfoSlot = PetInfoSlot(index: i)
//
//            petInfoSlot.setScale(0.2)
//            petInfoSlot.zPosition = 200
//            petInfoSlot.position.x = mid_X
//            petInfoSlot.position.y += 500
//            petInfoSlot.position.y -= CGFloat(i) * petInfoSlot.size.width/1.8
//
//            slots.append(petInfoSlot)
//
//            self.addChild(petInfoSlot)
//        }
//
//    }
    
}

