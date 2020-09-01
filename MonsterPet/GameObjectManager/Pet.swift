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
    case chicken        = "Chicken"
    case fox            = "fox"
    case chibaDog       = "chibaDog"
    case littleChicken  = "littleChicken"
    case cat            = "Cat"
    case panda          = "Panda"
    
    static var count: Int { return PetName.panda.hashValue + 1}
}

class Pet: SKSpriteNode, Observer{
    
    var id: Int = 0
    
    var petName         : PetName!
    var petTexture      : SKTexture!
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
    
    var favoriteItem    : [ItemName] = []
    var nowEatingItem   : Item!
    
    public var UnfavoriteItem: [ItemName] = []
    public var Mood         : Int!
    public var VisitedTime  : Int!
    
    var timeWhenPlaced      : CFTimeInterval!
    var timeWhenLeftScene   : CFTimeInterval!
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
        petTexture = SKTexture(imageNamed: petName.rawValue)
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "NW"))
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "NE"))
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "SE"))
        petTextures.append(SKTexture(imageNamed: petName.rawValue + "SW"))
        
        super.init(texture: petTexture, color: .clear, size: petTexture.size())
        SetDropPackage()
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
            floatingHeart.setScale(0.13)
            floatingHeart.zPosition = 3
            floatingHeart.position = self.position
            floatingHeart.position.x += 20
            floatingHeart.position.y += 20
            
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
    
    func SetDropPackage(){
        dropPackage = Package()
    }
    
    func DropItemPackage(at position: CGPoint, whenTimePassed: CFTimeInterval){
        
        if !packageIsDropped && whenTimePassed > onScreenTime - 30 {
            //Need logic for dropping package
            dropPackage.setScale(0.25)
            dropPackage.zPosition = 3
            dropPackage.position = position
            scene?.addChild(dropPackage)
            
            packageIsDropped = true
        }
        
    }
    
    func BeingCalled(to position: CGPoint){
        
        self.timeWhenPlaced = Date.timeIntervalSinceReferenceDate
        self.isAdded = true

        self.setScale(0.14)
        self.zPosition = 1
        self.position = position
        self.position.x += 40
        self.position.y += 40
        
        let targetPosition = self.position
        let moveUp = SKAction.moveTo(y: self.position.y + 100, duration: 0.1)
        let moveDown = SKAction.move(to: targetPosition, duration: 0.1)
        self.run(SKAction.sequence([moveUp, moveDown]))
        
    }
    
    func WaitForNextCall(waitTime: CFTimeInterval){
        
        let wait = SKAction.wait(forDuration: 10)
        self.run(wait, completion: {})
        
    }
    
    func Update() {
        
    }
    
}
