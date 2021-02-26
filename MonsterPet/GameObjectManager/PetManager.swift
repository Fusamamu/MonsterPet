import SpriteKit
import Foundation

class PetManager: Observable{
    
    static let sharedInstance = PetManager()
    
    let currencyManager     : CurrencyManager       = .sharedInstance
    let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    let itemManager         : ItemManager           = .sharedInstance
    let packageManager      : PackageManager        = .sharedInstance
    
    var observers: [Observer] = []
    
    public var currentScene: SKScene!
    public var petInStore: [PetName: Pet?] = [:]
    
    public var petInScene: [Pet?] = []
    public var heartInScene: [SKSpriteNode?] = []
    
    static var chicken: Pet!
    static var rabbit: Pet!
    static var birdy: Pet!
    static var take:Pet!
    
    private init(){
        
        PetManager.chicken = Pet(petName: .chicken)
        PetManager.chicken.SetTime(waitTime: 5, giveHeartTime: 2, onScreenTime: 150)
        PetManager.chicken.SetFavoriteItem(itemName: .cornFlake)
        PetManager.chicken.SetGivenHeart(count: 100)
        
        PetManager.take = Pet(petName: .take)
        PetManager.take.SetTime(waitTime: 5, giveHeartTime: 2, onScreenTime: 150)
        PetManager.take.SetFavoriteItem(itemName: .apple)
        PetManager.take.SetGivenHeart(count: 123)
        
        PetManager.birdy = Pet(petName: .birdy)
        PetManager.birdy.SetTime(waitTime: 5, giveHeartTime: 2, onScreenTime: 150)
        PetManager.birdy.SetFavoriteItem(itemName: .carrot)
        PetManager.birdy.SetGivenHeart(count: 2)
        
        PetManager.rabbit = Pet(petName: .rabbit)
        PetManager.rabbit.SetTime(waitTime: 5, giveHeartTime: 5, onScreenTime: 150)
        PetManager.rabbit.SetFavoriteItem(itemName: .pumpkin)
        PetManager.rabbit.SetGivenHeart(count: 3)
        
        self.InitializePetInStore()
        
    }
    
    func InitializePetInStore(){
         petInStore[PetName.chicken]        = PetManager.chicken
         petInStore[PetName.take]           = PetManager.take
         petInStore[PetName.birdy]          = PetManager.birdy
         petInStore[PetName.rabbit]         = PetManager.rabbit
    }
    
    func SetCurrentScene(gameScene: SKScene){
        currentScene = gameScene
    }
    
    func Call(_ pet: Pet, to point: CGPoint, for eatingItem: Item, elapsedTime: CFTimeInterval){
        
            guard elapsedTime > pet.waitTime else { return }
            guard !pet.isAdded else { return }
            
            eatingItem.eattenByPet = pet
            eatingItem.isBeingEaten = true
            pet.nowEatingItem = eatingItem
            
            SortPetDirection_N_AddToScene(pet: pet, at: point)
    }
    
    func Call(_ pet: Pet, to point: CGPoint, for eatingEquipment: Equipment, elapsedTime: CFTimeInterval){
        
            guard elapsedTime > pet.waitTime else { return }
            guard !pet.isAdded else { return }
            
            eatingEquipment.eattenByPet = pet
            eatingEquipment.isBeingEaten = true
            pet.nowEatingEquipment = eatingEquipment
            
            SortPetDirection_N_AddToScene(pet: pet, at: point)
    }
    
    func SortPetDirection_N_AddToScene(pet: Pet, at point: CGPoint){
        
        var pointToPlacePet: CGPoint!
        
        for index in 0...3{
            if placeHolderManager.surroundingPointData[point]![index]{
                
                if index == 0 {
                    pointToPlacePet = point + placeHolderManager.NW_point
                    pet.direction = .NW_dir
                    pet.currentPointInPointData = point
                    pet.currentIndexSurroundingPointData = 0
                    placeHolderManager.surroundingPointData[point]![index] = false
                    break
                }
                if index == 1 {
                    pointToPlacePet = point + placeHolderManager.NE_point
                    pet.direction = .NE_dir
                    pet.currentPointInPointData = point
                    pet.currentIndexSurroundingPointData = 1
                    placeHolderManager.surroundingPointData[point]![index] = false
                    break
                }
                if index == 2 {
                    pointToPlacePet = point + placeHolderManager.SE_point
                    pet.direction = .SE_dir
                    pet.currentPointInPointData = point
                    pet.currentIndexSurroundingPointData = 2
                    placeHolderManager.surroundingPointData[point]![index] = false
                    break
                }
                if index == 3 {
                    pointToPlacePet = point + placeHolderManager.SW_point
                    pet.direction = .SW_dir
                    pet.currentPointInPointData = point
                    pet.currentIndexSurroundingPointData = 3
                    placeHolderManager.surroundingPointData[point]![index] = false
                    break
                }
            }
        }
        
        currentScene.addChild(pet)
        pet.BeingCalled(to: pointToPlacePet)
        (currentScene as! MainScene).SortObjectsLayerAfterAdded()
        
        petInScene.append(pet)
    }

    func Remove(pet: Pet, at_Index index: Int, at elapsedTime:CFTimeInterval){
        if elapsedTime > petInScene[index]!.onScreenTime{
            
            guard let refPet = petInScene[index] else { return }
            
            placeHolderManager.surroundingPointData[refPet.currentPointInPointData]![refPet.currentIndexSurroundingPointData] = true
            refPet.currentPointInPointData          = nil
            refPet.currentIndexSurroundingPointData = nil
            
            RemoveHeart(from: refPet)
            petInScene[index]?.floatHeartIsAdded = false
            
            petInScene[index]?.timeWhenLeftScene = Date.timeIntervalSinceReferenceDate
            petInScene[index]?.isAdded = false
            petInScene[index]?.removeFromParent()
            petInScene[index] = nil
           // petInScene.remove(at: index)
            
            
        }
    }
    
    func RemoveHeart(from pet: Pet){
        if pet.floatHeartIsAdded && pet.floatingHeart != nil {
            heartInScene = heartInScene.filter({ $0 != pet.floatingHeart})
            pet.floatingHeart.removeFromParent()
            pet.floatingHeart = nil
            //pet.floatHeartIsAdded  = false
        }
    }
    
    func Remove(item: Item, at elapsedTime: CFTimeInterval){
        
        guard elapsedTime > item.timeOnScreen else { return }
        
        item.run(SKAction.fadeOut(withDuration: 1)){
            self.itemManager.itemData[item.position]?.item = nil
            item.removeFromParent()
        }
    }

    
    func UpdateTouch(at location: CGPoint){
        for pet in petInStore.values{
            if pet!.floatingHeart != nil && pet!.floatingHeart.contains(location){
                
//                heartInScene = heartInScene.filter({ $0 != pet?.floatingHeart })
//                pet?.floatingHeart.removeFromParent()
//                pet?.floatingHeart      = nil
//                pet?.floatHeartIsAdded  = false
//
               // heartInScene = heartInScene.filter({ $0 != pet!.floatingHeart })
                
                RemoveHeart(from: pet!)
                
                
                currencyManager.HeartCounts += pet!.givenHeart
                
                //currentScene.run(SoundManager.sharedInstanced.Play(by: .heart))
                
                SoundManager.sharedInstanced.Play_SE(by: SoundName.heart.rawValue)
            }
        }
    }
    
    func LoadPetData(){
        for pet in petInScene{
            if pet != nil{
                currentScene.addChild(pet!)
            }
        }
    }
    
    func LoadHeartInScene(){
        for heart in heartInScene{
            if heart != nil{
                currentScene.addChild(heart!)
            }
        }
    }
    
    
    func StorePetData(){
        
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



//                if elapsedTime > pet!.giveHeartTime && !pet!.floatHeartIsAdded{
//                    ////////
//                    pet?.floatingHeart.position = pet!.position
//                    pet?.floatingHeart.position.y += 85
//                    ///////
//                    pet?.scene?.addChild(pet!.floatingHeart)
//                    pet?.AnimateFloatingHeart()
//                    pet?.floatHeartIsAdded = true
//                }
