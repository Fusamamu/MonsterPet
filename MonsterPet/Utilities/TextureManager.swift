import Foundation
import SpriteKit

class TextureManager{
    
    static let sharedInstance = TextureManager()
    
    var slotImage: SKTexture!
    var lockImage: SKTexture!
    
    var itemImages: [SKTexture] = []
    var lockImages: [SKTexture] = []
    
    private init(){
        slotImage   = SKTexture(imageNamed: "itemSlot")
        slotImage.preload{}
        lockImage   = SKTexture(imageNamed: LockedImageName.green.rawValue)
        lockImage.preload{}
        
        LoadItemImages()
        LoadLockImages()
        
        print("All Images are Loaded")
       
    }
    
    private func LoadItemImages(){
        for i in 0...ItemName.allCases.count - 1  {
            let itemImage = SKTexture(imageNamed: ItemName.allCases[i].rawValue)
            itemImage.preload{}
            itemImages.append(itemImage)
        }
    }
    
    private func LoadLockImages(){
        for i in 0...LockedImageName.allCases.count - 1 {
            let lockImage = SKTexture(imageNamed: LockedImageName.allCases[i].rawValue)
            lockImage.preload{}
            lockImages.append(lockImage)
        }
    }
    

}
