import Foundation
import SpriteKit

enum EquipmentName: String, CaseIterable{
    
    case ironPan        = "IronPan"
    case hotBaseRock    = "BaseRock"
    case bento          = "Bento"
    case whiteBowl      = "WhiteBowl"
    
    case blueBowl       = "BlueBowl"
    case nabe           = "Nabe"
    case b              = "b"
    case c              = "c"
    

    
    static var count: Int { return EquipmentName.blueBowl.hashValue + 1}
}

enum RecipeName: String, CaseIterable{
    case recipe1    = "recipe1"
    case recipe2    = "recipe2"
    case recipe3    = "recipe3"
    
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
