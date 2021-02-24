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
    
    case salmon                 = "Salmon"
    case sandwich               = "Sandwich"
    case tofu                   = "Tofu"
    ////////////////////////////////////
    case mushroom               = "Mushroom"
    case milk                   = "Milk"
    case cheeseCake             = "cheeseCake"
    
    case rollBread              = "Roll Bread"
    case shortCake              = "Short Cake"
    case butter                 = "Butter"
    
    case seasoning              = "Seasoning"
    case oliveOil               = "Olive Oil"
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
    
    var notEnoughCoin       : Bool  = false
    var missingIngredient   : Bool  = false
    var outOfStock          : Bool  = false
    
    var itemData: [String:Any]

    init(index: Int){
        //itemImage   = SKTexture(imageNamed: ItemName.allCases[index].rawValue)
        itemImage   = textureManager.itemImages[index]
        itemName    = ItemName.allCases[index]
        itemIndex   = index
        
        //Load Selected ItemData//
        let path = Bundle.main.path(forResource: "ItemData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        itemData = dict?.object(forKey: itemName.rawValue) as! [String:Any]
        
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

        let coinRequired = Int(itemData["CoinRequirement"] as! String)
        
        if currencyManager.CoinCounts >= coinRequired!{
            currencyManager.CoinCounts -= coinRequired!
            self.count += 1
            
            itemManager.itemCountInventory[self.itemName] = self.count
            notEnoughCoin = false
            
        }else{
            notEnoughCoin = true
            NotifyAllObservers()
        }
    }
    
    func MakeItem(){
        missingIngredient = true
        NotifyAllObservers()
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
