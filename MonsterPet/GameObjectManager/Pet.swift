import Foundation
import SpriteKit

//How often they will come
//How many Hearts they will give
//How are their moods

//Growth-Upgrade
//Change Animation
//Give Heart Animation
//UI-> Tell moods & needs

enum PetName: String, CaseIterable{
    case chicken        = "chicken"
    case rabbit         = "rabbit"
    case birdy          = "birdy"
//    case littleChicken  = "littleChicken"
//    case cat            = "Cat"
//    case panda          = "Panda"
    case take           = "take"
    
    static var count: Int { return PetName.take.hashValue + 1}
}

class Pet: SKSpriteNode, Observer, Observable{
    
    let itemManager         : ItemManager           = .sharedInstance
    let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    
    var id: Int = 0
    var observers: [Observer] = []
    
    var petName         : PetName!
    var petTexture      : SKTexture!
    var petLockedTexture: SKTexture!
    var petTextures     : [SKTexture] = []
    
    public enum Direction {
        case NW_dir
        case NE_dir
        case SE_dir
        case SW_dir
    }
    
    public var direction: Direction! {
        didSet{
            switch direction {
            case .NW_dir:
                self.texture = petTextures[0]
            case .NE_dir:
                self.texture = petTextures[1]
            case .SE_dir:
                self.texture = petTextures[2]
            case .SW_dir:
                self.texture = petTextures[3]
            case .none:
                print("None")
            }
        }
    }
    
    public var currentPointInPointData          : CGPoint!
    public var currentIndexSurroundingPointData : Int!
    
    var givenHeart      : Int!
    var dropPackage     : Package!
    var dropItem        : ItemName!
    
    public var favoriteItem    : [ItemName] = []
    public var nowEatingItem   : Item!
    
    public var VisitedTime  : Int!
    public var isFirstTime  : Bool!
    public var hasVisited   : Bool = false { didSet { NotifyAllObservers() } }
    
    public var gift : Item!
    public var hasGivenSpecialItem : Bool!
    
    var timeWhenPlaced      : CFTimeInterval = 0
    var timeWhenLeftScene   : CFTimeInterval = 0
    
    var waitTime            : CFTimeInterval = 5
    var giveHeartTime       : CFTimeInterval = 5
    var dropPackageTime     : CFTimeInterval = 5
    var onScreenTime        : CFTimeInterval = 5
    
    var isAdded             : Bool = false
    var floatHeartIsAdded   : Bool = false
    var packageIsDropped    : Bool = false
    
    var floatingHeart   : SKSpriteNode!
    
    init(petName: PetName){
        self.petName = petName
        petTexture = SKTexture(imageNamed: petName.rawValue + "NW")
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "NW"))
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "NE"))
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "SE"))
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "SW"))
        
        super.init(texture: petTexture, color: .clear, size: petTexture.size())
        SetDropPackage()
        
        VisitedTime         = 0
        isFirstTime         = true
        hasGivenSpecialItem = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func OnClicked(at location: CGPoint){
        if self.contains(location){
           // GivingHeartAnimation()
        }
    }

//    func GivingHeartAnimation(){
//
//        let heart = SKSpriteNode(imageNamed: "Heart")
//        heart.position = CGPoint(x: -100, y: 30)
//        heart.zPosition = 5
//        heart.setScale(0.5)
//        self.addChild(heart)
//
//        let moveUp = SKAction.moveTo(y: 100, duration: 0.3)
//        moveUp.timingMode = .easeIn
//        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
//        let groupAction = SKAction.group([moveUp, fadeOut])
//        heart.run(groupAction, completion: {heart.removeFromParent()})
//
//    }
    
    func AddFloatingHeartPopUp(waitTime: CFTimeInterval){
        if !floatHeartIsAdded && waitTime > giveHeartTime {
            
            floatingHeart = SKSpriteNode(imageNamed: "floatingHeart")
            floatingHeart.setScale(0.08)
            floatingHeart.zPosition = self.zPosition + 1
            floatingHeart.position  = self.position
            floatingHeart.position.y += 60
            
            scene?.addChild(floatingHeart)
            AnimateFloatingHeart()
            
            floatHeartIsAdded = true
        }
    }
    
    func AnimateFloatingHeart(){
        let duration = 0.2
        let moveUp     = SKAction.moveBy(x: 0, y: 10, duration: duration)
        let moveDown   = SKAction.moveBy(x: 0, y: -10, duration: duration)
        let loop       = SKAction.repeatForever(SKAction.sequence([moveUp, moveDown]))
        floatingHeart.run(loop)
    }
    
    
    func SetTime(waitTime: CFTimeInterval, giveHeartTime: CFTimeInterval, onScreenTime: CFTimeInterval){
        self.waitTime       = waitTime
        self.giveHeartTime  = giveHeartTime
        self.onScreenTime   = onScreenTime
    }
    
    func SetGivenHeart(count: Int){
        givenHeart = count
    }
    
    func SetFavoriteItem(itemName: ItemName){
        favoriteItem.append(itemName)
    }
    
    func SetGiftItem(itemName: ItemName){
        
    }
    
    func SetDropPackage(){
        dropPackage = Package()
    }
    
    func DropItemPackage(at position: CGPoint, whenTimePassed: CFTimeInterval){
        //Checking Surrounding pets. Make sure the last to be the one that drop the package.
        let petSurrounding: [Bool] = placeHolderManager.surroundingPointData[position]!.filter{ bool in return !bool }
        
        guard petSurrounding.count == 1                     else { return }
       // guard itemManager.itemData[position]!.isPlacable    else { return }
         
        if !packageIsDropped && whenTimePassed > onScreenTime - 30 {
                //Need logic for dropping package
                //Ex drop 1 / 30 visited count
                //random item in package
                dropPackage.setScale(0.1)
                dropPackage.zPosition = 3
                dropPackage.position = position
                scene?.addChild(dropPackage)
            
                itemManager.itemData[position]!.isPlacable = false
                
                (scene as! MainScene).SortObjectsLayerAfterAdded()
                
                packageIsDropped = true
        }
    }
    
    func BeingCalled(to position: CGPoint){
        
        self.timeWhenPlaced = Date.timeIntervalSinceReferenceDate
        self.isAdded = true
        self.VisitedTime += 1;
        
        if !hasVisited {
            hasVisited = true
        }

        self.setScale(0.1)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.25)
        self.position = position

        let targetPosition  = self.position
        let moveUp          = SKAction.moveTo(y: self.position.y + 100, duration: 0.1)
        let moveDown        = SKAction.move(to: targetPosition, duration: 0.1)
        self.run(SKAction.sequence([moveUp, moveDown]))
    }
    
    func WaitForNextCall(waitTime: CFTimeInterval){
        let wait = SKAction.wait(forDuration: 10)
        self.run(wait, completion: {})
    }
    
    
    func Update() {
        
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
