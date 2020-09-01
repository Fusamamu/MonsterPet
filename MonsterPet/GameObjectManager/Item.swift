import Foundation
import SpriteKit

enum ItemName: String, CaseIterable{
    
    case cornFlake = "CornFlake"
    case apple     = "Apple"
    case carrot    = "Carrot"
    
    case cheese    = "Cheese"
    case egg       = "Egg"
    case pumpkin   = "Pumpkin"
    
    case fish     = "Fish"
    case pancake  = "Pancake"
    case cabbage  = "Cabbage"
    ////////////////////////////////////
    case potato                 = "Potato"
    case purplePotato           = "PurplePotato"
    case yakiPurplePotato       = "YakiPurplePotato"
    
    case lemon                  = "Lemon"
    case daikon                 = "Daikon"
    case usagiApple             = "UsagiApple"
    
    case p = "p"
    case q = "q"
    case r = "r"
    ////////////////////////////////////
    case s = "s"
    case t = "t"
    case u = "u"
    
    case v = "v"
    case w = "w"
    case y = "y"
    
    case z  = "z"
    case aa = "aa"
    case bb = "bb"
    ////////////////////////////////////
    
    static var count: Int { return ItemName.bb.hashValue + 1}
}

class Item: SKSpriteNode, Observable, ItemProtocol{
    

    var itemManager     : ItemManager       = .sharedInstance
    var currencyManager : CurrencyManager   = .sharedInstance
    var textureManager  : TextureManager    = .sharedInstance
    
    var itemName: ItemName!
    var itemImage: SKTexture!
    var itemIndex: Int!
    
    var equipmentName: EquipmentName!
    var equipmentImage: SKTexture!
    
    var eattenByPet: Pet!
    
    var isBeingEaten: Bool  = false
    var isUnlock: Bool      = true   { didSet { NotifyAllObservers() } }
    var count: Int = 10              { didSet { NotifyAllObservers() } }
    var price: Int = 10
    
    var timeWhenPlaced: CFTimeInterval!
    var timeOnScreen: CFTimeInterval! = 100
    
    var observers: [Observer] = []

    init(index: Int){
        //itemImage   = SKTexture(imageNamed: ItemName.allCases[index].rawValue)
        itemImage   = textureManager.itemImages[index]
        itemName    = ItemName.allCases[index]
        itemIndex   = index
        super.init(texture: itemImage, color: .clear, size: itemImage.size())
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
    
    //Condition to buy
    //Condition to sell
    //COndition to make
    //COndition to place
    //Condition to unlock
    
    func BuyItem(){
        if currencyManager.HeartCounts >= 10{
            currencyManager.HeartCounts -= price
            self.count += 1
            
            itemManager.itemCountInventory[self.itemName] = self.count
            
        }
    }
    
    func Unlock(){
        if let slot = self.parent as? Slot {
            slot.isLock = false
        }
    }
    
    func Update() {
        
    }
}


protocol ItemProtocol {
    
    var itemName        : ItemName!       { get set }
    var itemImage       : SKTexture!      { get set }
    
    var equipmentName   : EquipmentName!  { get set}
    var equipmentImage  : SKTexture!      { get set }
    

    var isUnlock: Bool          { get set }
    var count: Int              { get set }
    var price: Int              { get set }
    
    func BuyItem()
    func Unlock()
    
}
