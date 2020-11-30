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
    
    func ScanItems(at currentTime: CFTimeInterval){
        
        let point = placeHolderManager.pointData[Int.random(in: 0...4)]
        guard let checkingItem = itemManager.itemData[point]?.item else { return }
        
        let elapsedTime = currentTime - checkingItem.timeWhenPlaced
        
        for pet in petInStore.values{
            
            if pet!.timeWhenLeftScene == nil{
                if !(pet!.isAdded){
                    Call(pet!,to: point,for: checkingItem, elapsedTime: elapsedTime)
                    break;
                }
            }else{
                let nextCallelapsedTime = currentTime - pet!.timeWhenLeftScene
            
                if nextCallelapsedTime > pet!.waitTime + 10{
                    if !(pet!.isAdded) {
                        Call(pet!,to: point,for: checkingItem, elapsedTime: elapsedTime)
                        break;
                    }
                }
            }
        }
        
        if !(checkingItem.isBeingEaten) && elapsedTime > checkingItem.timeOnScreen {
            Remove(item: checkingItem, at: elapsedTime)
        }
        
    }
    
    func Call(_ pet: Pet, to point: CGPoint, for eatingItem: Item, elapsedTime: CFTimeInterval){
        if elapsedTime > pet.waitTime{
            
            eatingItem.eattenByPet = pet
            eatingItem.isBeingEaten = true
            pet.nowEatingItem = eatingItem
            
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
           // pointToPlacePet = point + placeHolderManager.NW_point
            
            currentScene.addChild(pet)
            pet.BeingCalled(to: pointToPlacePet)
            (currentScene as! MainScene).SortObjectsLayerAfterAdded()
            
            petInScene.append(pet)
        }
    }
    
    func ScanPets(at currentTime: CFTimeInterval){
        
        if petInScene.count != 0{
            for i in 0...petInScene.count - 1{
                
                guard let checkingPet = petInScene[i] else { continue }
        
                if checkingPet.isAdded{
                    let elapsedTime = currentTime - checkingPet.timeWhenPlaced
                    
                    // Logic to give Heart and Pakage HERE!!!
                    checkingPet.AddFloatingHeartPopUp(waitTime: elapsedTime)
                    checkingPet.DropItemPackage(at: checkingPet.nowEatingItem.position, whenTimePassed: elapsedTime)
                    
                    packageManager.packageInScene.append(checkingPet.dropPackage)
                    
                    Remove(pet: checkingPet, at_Index: i, at: elapsedTime)
                    Remove(item: checkingPet.nowEatingItem, at: elapsedTime)
                }
            }
        }
        
    }
    
    func Remove(pet: Pet, at_Index index: Int, at elapsedTime:CFTimeInterval){
        if elapsedTime > petInScene[index]!.onScreenTime{
            
            guard let refPet = petInScene[index] else { return }
            
            placeHolderManager.surroundingPointData[refPet.currentPointInPointData]![refPet.currentIndexSurroundingPointData] = true
            refPet.currentPointInPointData          = nil
            refPet.currentIndexSurroundingPointData = nil
            
            petInScene[index]?.timeWhenLeftScene = Date.timeIntervalSinceReferenceDate
            petInScene[index]?.isAdded = false
            petInScene[index]?.removeFromParent()
            petInScene[index] = nil
        }
    }
    
    func Remove(item: Item, at elapsedTime: CFTimeInterval){
        if elapsedTime > item.timeOnScreen{
            
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            
            item.run(fadeOut, completion: {
                
                
                //self.itemManager.itemData[item.position]?.isPlacable = true
                
                
                self.itemManager.itemData[item.position]?.item = nil
                item.removeFromParent()
                
                if item.eattenByPet != nil{
                 //   item.eattenByPet.isAdded = false
                }
            })
        }
    }

    
    func UpdateTouch(at location: CGPoint){
        
        for pet in petInStore.values{
            
            //guard let checkingFloatingHeart = pet!.floatingHeart else { return }
            
            if pet!.floatingHeart != nil && pet!.floatingHeart.contains(location){
                pet?.floatingHeart.removeFromParent()
               // pet?.floatHeartIsAdded = false
                currencyManager.HeartCounts += pet!.givenHeart
            }
        }
        
        
    }
    
//    func Remove(package: Package){
//        package.texture = package.openedImage
//
//        let wait        = SKAction.wait(forDuration: 3)
//        let fadeOut     = SKAction.fadeOut(withDuration: 1)
//
//        package.run(SKAction.sequence([wait, fadeOut, wait])){
//            package.removeFromParent()
//            self.itemManager.itemData[package.position]!.isPlacable = true
//        }
//    }
//

    func LoadPetData(){
        for pet in petInScene{
            if pet != nil{
                currentScene.addChild(pet!)
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
