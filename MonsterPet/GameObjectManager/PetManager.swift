import SpriteKit
import Foundation

class PetManager: Observer{
   
    var id: Int = 0
    
    static let sharedInstance = PetManager()
    let itemManager         : ItemManager           = .sharedInstance
    let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    let currencyManager     : CurrencyManager       = .sharedInstance
    
    var currentScene: SKScene!
    var petInStore: [PetName: Pet?] = [:]
    var petInScene: [Pet?] = []
    var packageInScene: [Package?] = []
   
    
    static var chicken: Pet!
    static var fox: Pet!
    static var chibaDog: Pet!
    static var littleChicken: Pet!
    
    private init(){
        
        PetManager.chicken = Pet(petName: .chicken)
        PetManager.chicken.SetTime(waitTime: 5, giveHeartTime: 2, onScreenTime: 150)
        PetManager.chicken.SetFavoriteItem(itemName: .cornFlake)
        PetManager.chicken.SetGivenHeart(count: 100)
        
        PetManager.fox = Pet(petName: .fox)
        PetManager.fox.SetTime(waitTime: 5, giveHeartTime: 2, onScreenTime: 150)
        PetManager.fox.SetFavoriteItem(itemName: .apple)
        PetManager.fox.SetGivenHeart(count: 123)
        
        PetManager.chibaDog = Pet(petName: .chibaDog)
        PetManager.chibaDog.SetTime(waitTime: 5, giveHeartTime: 2, onScreenTime: 150)
        PetManager.chibaDog.SetFavoriteItem(itemName: .carrot)
        PetManager.chibaDog.SetGivenHeart(count: 2)
        
        PetManager.littleChicken = Pet(petName: .littleChicken)
        PetManager.littleChicken.SetTime(waitTime: 5, giveHeartTime: 5, onScreenTime: 150)
        PetManager.littleChicken.SetFavoriteItem(itemName: .pumpkin)
        PetManager.littleChicken.SetGivenHeart(count: 3)
        
        InitializePetInStore()
        
        //print(placeHolderManager.surroundingPointData[placeHolderManager.pointData[0]]![0])
       // print(placeHolderManager.surroundingPointData[placeHolderManager.pointData[0]])
   
    }
    
    func InitializePetInStore(){
         petInStore[PetName.chicken]        = PetManager.chicken
         petInStore[PetName.fox]            = PetManager.fox
         petInStore[PetName.chibaDog]       = PetManager.chibaDog
         petInStore[PetName.littleChicken]  = PetManager.littleChicken
    }
    
    
    func SetCurrentScene(gameScene: SKScene){
        currentScene = gameScene
    }
    
    
    func ScanItems(at currentTime: CFTimeInterval){
        
        for point in placeHolderManager.pointData{
            
            guard let checkingItem = itemManager.itemData[point]?.item else { continue }
            
            let elapsedTime = currentTime - checkingItem.timeWhenPlaced
            
            for pet in petInStore.values{
                
                if pet!.timeWhenLeftScene == nil{
                    if !(pet!.isAdded)  && pet!.favoriteItem[0] == checkingItem.itemName{
                        Call(pet!,to: point,for: checkingItem, elapsedTime: elapsedTime)
                    }
                }else{
                    let nextCallelapsedTime = currentTime - pet!.timeWhenLeftScene
                
                    if nextCallelapsedTime > pet!.waitTime + 10{
                        if !(pet!.isAdded)  && pet!.favoriteItem[0] == checkingItem.itemName{
                        Call(pet!,to: point,for: checkingItem, elapsedTime: elapsedTime)
                        }
                    }
                }
            }
            
            if !(checkingItem.isBeingEaten) && elapsedTime > checkingItem.timeOnScreen {
                Remove(item: checkingItem, at: elapsedTime)
            }
        }
    }
    
    func Call(_ pet: Pet, to point: CGPoint, for eatingItem: Item, elapsedTime: CFTimeInterval){
        if elapsedTime > pet.waitTime{
            eatingItem.eattenByPet = pet
            eatingItem.isBeingEaten = true
            pet.nowEatingItem = eatingItem
            
            var pointToPlacePet: CGPoint!
            
            print(placeHolderManager.surroundingPointData[point]![0])
            
            
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
                    packageInScene.append(checkingPet.dropPackage)
                    
                    Remove(pet: checkingPet, at_Index: i, at: elapsedTime)
                    Remove(item: checkingPet.nowEatingItem, at: elapsedTime)
                }
            }
        }
        
    }
    
    func Remove(pet: Pet, at_Index index: Int, at elapsedTime:CFTimeInterval){
        if elapsedTime > petInScene[index]!.onScreenTime{
            //petInStore[petInScene[index]!.petName] = nil
            
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
                self.itemManager.itemData[item.position]?.isPlacable = true
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
        
        for package in packageInScene{
            if package!.contains(location){
                Remove(package: package!)
                
            }
        }
        
    }
    
    func Remove(package: Package){
        package.texture = package.openedImage
        let wait    = SKAction.wait(forDuration: 3)
        let fadeOut = SKAction.fadeOut(withDuration: 1)
        package.run(SKAction.sequence([wait, fadeOut]),completion: {
            package.removeFromParent()
        })
    }
    

    func LoadPetData(){
        for pet in petInScene{
            if pet != nil{
                currentScene.addChild(pet!)
            }
        }
    }
    
    func StorePetData(){
        
    }
    
    func Update() {
    
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
