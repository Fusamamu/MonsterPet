import Foundation
import SpriteKit

class ItemManager: Observable{
    
    static let sharedInstance = ItemManager()
    
    lazy var petManager: PetManager = { return PetManager.sharedInstance }()
   
    var observers: [Observer] = []
    
    var currentScene: SKScene?
    
    public var tempItemHolder: Item!
    
    public var TempCount: Int{
        get { return tempCount }
        set {
            if tempCount < 0{
                tempCount = 0;
            }
        }
    }
    private var tempCount: Int = 0
    

    public var itemData    :[CGPoint: (item: Item?, isPlacable: Bool)] = [:]
    public var itemCountInventory: [ItemName: Int] = [:]
    public var slotUpdateUnpackState: [Int: Bool] = [:]
    
    private init() {
        itemData  = Dictionary(minimumCapacity: 5)
        InitializeItemCountInventory()
        InitializeSlotUpdateUnpackState()
    }
    
    func InitilizeObjectData(pointData: [CGPoint]){
        for point in pointData{
            itemData[point] = (nil, true)
        }
    }
    
    func SetCurrentScene(to currentScene: SKScene){
        self.currentScene = currentScene
    }
    
    
    
    
    
    
    func StoreObjectData(item: Item, at location: CGPoint){
        itemData[location]?.item = item
        itemData[location]?.isPlacable = false
        
    }

    func RemoveObjectData(item: Item, at location: CGPoint){
        itemData[location]?.item?.removeFromParent()
        itemData[location]?.item = nil
        itemData[location]?.isPlacable = true
    }
    
    func LoadObjectData(pointData: [CGPoint]){
        for point in pointData{
            if itemData[point]?.item != nil{
                 currentScene?.addChild(itemData[point]!.item!)
            }
        }
    }
    
    func InitializeItemCountInventory(){
        let allItemTypeCount = 27
        for index in 0...allItemTypeCount - 1{
            itemCountInventory[ItemName.allCases[index]] = 0
        }
    }
    
    func InitializeSlotUpdateUnpackState(){
        let allItemTypeCount = 27
        for index in 0...allItemTypeCount - 1{
            slotUpdateUnpackState[index] = false
        }
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
}


