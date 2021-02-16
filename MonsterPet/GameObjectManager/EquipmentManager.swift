import Foundation
import SpriteKit

class EquipmentManager: Observable{
    
    static let sharedInstance = EquipmentManager()
    
    var observers: [Observer] = []
    var currentScene: SKScene?
    
    public var tempEquipmentHolder: Equipment!
    
    public var equipmentData: [CGPoint: (equipment: Equipment?, isPlacable: Bool)] = [:]
    
    
    //public var RecipeCountInventory: [EquipmentName: [String:Int]] = [:]
    public var RecipeCountInventory: [RecipeName: Int] = [:]
    
    public var slotUpdateUnpackState: [Int: Bool] = [:]
    
    
    private init() {
        
        equipmentData  = Dictionary(minimumCapacity: 5)
        
        InitializeRecipeCountInventory()
        InitializeSlotUpdateUnpackState()
        
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
    
    func InitilizeObjectData(pointData: [CGPoint]){
        for point in pointData{
            equipmentData[point] = (nil, true)
        }
    }
    
    func InitializeSlotUpdateUnpackState(){
        let allItemTypeCount = 8
        for index in 0...allItemTypeCount - 1{
            slotUpdateUnpackState[index] = false
        }
    }
    
    func SetCurrentScene(to currentScene: SKScene){
        self.currentScene = currentScene
    }
    
    
    func StoreEquipmentData(equipment: Equipment, at location: CGPoint){
        equipmentData[location]?.equipment = equipment
        equipmentData[location]?.isPlacable = false
    }
    
    func RemoveEuipmentData(equipment: Equipment, at location: CGPoint){
        equipmentData[location]?.equipment?.removeFromParent()
        equipmentData[location]?.equipment = nil
        equipmentData[location]?.isPlacable = true
        
    }
    
    func LoadObjectData(pointData: [CGPoint]){
        for point in pointData{
            if equipmentData[point]?.equipment != nil{
                currentScene?.addChild(equipmentData[point]!.equipment!)
            }
        }
    }
    
    func InitializeRecipeCountInventory(){
        let allRecipeTypeCount = RecipeName.allCases.count
           for index in 0...allRecipeTypeCount - 1{

                RecipeCountInventory[RecipeName.allCases[index]] = 0
           }
       }
    
    func IncreaseRecipeQuantity(for name: String, by number: Int){
        
        var computedQuantity: Int = RecipeCountInventory[RecipeName(rawValue: name)!]!
        computedQuantity += number

        
        if computedQuantity > 9{
            computedQuantity = 9
        }
        if computedQuantity < 0{
            computedQuantity = 0
        }
        
        RecipeCountInventory[RecipeName(rawValue: name)!] = computedQuantity
    }
}

