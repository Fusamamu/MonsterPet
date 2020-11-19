import Foundation
import SpriteKit

enum LockedImageName: String, CaseIterable{
    case green      = "GreenPackage"
    case yellow     = "YellowPackage"
    case orange     = "OrangePackage"
    case purple     = "PurplePackage"
}

class Slot: SKSpriteNode, Observer{
    
    private var textureManager: TextureManager = .sharedInstance
    
    private var labelBuilder: LabelBuilder!
    
    public  var slotDelegates: [ButtonDelegate]?
    public  var id          : Int  = 0
    public  var isLock      : Bool = true
    public  var isTouchable : Bool = true
    public  var isSelected  : Bool = false
    public  var ClickedCount: Int{
        get { return clickedCount }
        set { if newValue > 2 { clickedCount = 0 } else { clickedCount = newValue } }
    }
    private var clickedCount: Int = 0
    
    public  var slotIndex    : Int!
    public  var itemInSlot   : Item!
    
    public var ItemCount:Int{
        get { return itemCount }
        set { if newValue < 0 { itemCount = 0 }else{ itemCount = newValue} }
    }
    private(set) var itemCount : Int = 0;
    
    
    public  var currentItemInSlot   : Item!
    public  var unpackMenuPanel     : UnpackPanel!
    
    private let itemManager: ItemManager = .sharedInstance
    
    private(set) var slotImage   : SKTexture!
    private(set) var lockImage   : SKTexture!
  
    public var countLabel  : BMGlyphLabel!
    


    init(index: Int) {
        
        slotDelegates = []
        slotIndex = index;
        //slotImage   = SKTexture(imageNamed: "itemSlot")
        slotImage = textureManager.slotImage
        lockImage = textureManager.lockImage
        //lockImage   = SKTexture(imageNamed: LockedImageName.green.rawValue)
        
        super.init(texture: lockImage, color: .clear, size: lockImage.size())
        
        SetItemInSlot(by: slotIndex)
        SetLockImage(by: slotIndex)
        
        ItemCount   = itemManager.itemCountInventory[ItemName.allCases[index]]!
       
        labelBuilder = LabelBuilder()
        countLabel = labelBuilder.Build(selectedLabel: .itemCountLabel)
        countLabel.setGlyphText("x\(String(describing: ItemCount))")
        
//        itemInSlot.AddObserver(observer: self)
//        itemInSlot.isUnlock = itemManager.slotUpdateUnpackState[slotIndex]!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetItemInSlot(by index: Int){
        itemInSlot = Item(index: index)
        itemInSlot.setScale(0.5)
        itemInSlot.zPosition = 5
        
        itemInSlot.AddObserver(observer: self)
        itemInSlot.isUnlock = itemManager.slotUpdateUnpackState[slotIndex]!
    }
    
    func SetLockImage(by index: Int){
//        lockImage       = SKTexture(imageNamed: GetLockImageName(by: index))
        lockImage = GetLockImage(by: index)
        self.texture    = lockImage
    }
    
    func GetLockImageName(by index: Int) -> String {
        var lockImageName = ""
        
        if index < 6{
            lockImageName = LockedImageName.green.rawValue
        }else if index >= 6 && index < 12 {
            lockImageName = LockedImageName.yellow.rawValue
        }else if index >= 12 && index < 18 {
            lockImageName = LockedImageName.orange.rawValue
        }else if index >= 18{
            lockImageName = LockedImageName.purple.rawValue
        }
        
        return lockImageName
    }
    
    func GetLockImage(by index: Int) -> SKTexture{
        var lockImage: SKTexture!
        
        if index < 6{
            lockImage = textureManager.lockImages[0]
        }else if index >= 6 && index < 12 {
            lockImage = textureManager.lockImages[1]
        }else if index >= 12 && index < 18 {
            lockImage = textureManager.lockImages[2]
        }else if index >= 18{
            lockImage = textureManager.lockImages[3]
        }
    
        return lockImage
    }
    
    //Observer Function -> Called By Item when Item is unlocked.
    func Update() {
        
        if itemInSlot.isUnlock {
            self.texture = slotImage
//            self.size = slotImage.size()
//            self.setScale(0.01)
            self.isLock = false
           
            if currentItemInSlot == nil{
                currentItemInSlot = itemInSlot
                addChild(itemInSlot)
                addChild(countLabel)
            }
            
        }else{
            self.texture  = lockImage
            self.isLock = true
            currentItemInSlot = nil
        }
    }
    
    func SubscribeButton(target: ButtonDelegate){
        slotDelegates?.append(target)
    }
    
    func UnsubscribeButton(){
        slotDelegates?.removeAll()
    }
    
    func OnClicked(at location: CGPoint){
        if self.contains(location){
            for delegate in slotDelegates!{
                delegate.Invoked()
            }
        }
    }
}
