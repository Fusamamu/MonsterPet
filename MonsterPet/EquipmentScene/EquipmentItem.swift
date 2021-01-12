import Foundation
import SpriteKit

enum EquipmentName: String, CaseIterable{
    
    case ironPan        = "Iron Pan"
    case hotBaseRock    = "Stone Slab"
    case bento          = "Bento"
    case whiteBowl      = "White Bowl"
    
    case blueBowl       = "Blue Bowl"
    case nabe           = "Nabe Pot"
    case yellowMug      = "Yellow Mug"
    case tamagoyakiPan  = "Tamagoyaki Pan"
    

    
    static var count: Int { return EquipmentName.blueBowl.hashValue + 1}
}

enum RecipeName: String, CaseIterable{
    case friedMushroom      = "friedMushroom"
    case friedPotato        = "friedPotato"
    case timsum             = "timsum"
    
    case recipe2    = "recipe_2"
    case recipe3    = "recipe_3"
    
    static var count: Int { return RecipeName.recipe3.hashValue + 1}
}



class Equipment: SKSpriteNode, Observable, ItemProtocol{
    
    var itemName        : ItemName!
    var itemImage       : SKTexture!
   
    
    var equipmentIndex  : Int!
    var equipmentName   : EquipmentName!
    var equipmentImage  : SKTexture!
    
    var isUnlock: Bool      = true   { didSet { NotifyAllObservers() } }
    var count: Int = 10              { didSet { NotifyAllObservers() } }
    var price: Int = 10
    
    var timeWhenPlaced: CFTimeInterval!
    var timeOnScreen: CFTimeInterval! = 100
    
    var observers: [Observer] = []
    
    init(index: Int){
        equipmentIndex   = index
        equipmentImage   = SKTexture(imageNamed: EquipmentName.allCases[index].rawValue)
        equipmentName    = EquipmentName.allCases[index]
        super.init(texture: equipmentImage, color: .clear, size: equipmentImage.size())
    }
    
    init(WithRecipeName: String){
        let texture = SKTexture(imageNamed: WithRecipeName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func AddObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func RemoveObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func NotifyAllObservers() {
        for observer in observers{
            observer.Update()
        }
    }
    
    func BuyItem() {
        
    }
    
    func Unlock() {
        
    }
}
