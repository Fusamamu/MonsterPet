import Foundation
import SpriteKit

class EquipmentSlot: SKSpriteNode, Observer{
    
    private var labelBuilder: LabelBuilder!
    private var equipmentNameLabel:BMGlyphLabel!
    
    var id: Int = 0;

    public var slotDelegates: [ButtonDelegate]?
   
    public var isLock      : Bool  = true
    public var isSelected  : Bool  = false
    public var isTouchable : Bool  = true
    
    public  var slotIndex                : Int!
    public  var equipmentInSlot          : Equipment!
    public var currectSKScene: SKScene!
  //  public  var currentEquipmentInSlot   : EquipmentSlot!
    
    public var unpackMenuPanel     : UnpackPanel!
    
    private(set) var slotImage   : SKTexture!
    private(set) var lockImage   : SKTexture!
    
    private var slotScale: CGFloat = 0.17


    init(index: Int, skScene: SKScene){
        slotDelegates   = []
        slotIndex       = index
        currectSKScene  = skScene
        labelBuilder    = LabelBuilder()
        
        slotImage = SKTexture(imageNamed: "EquipmentPanel")
        lockImage = SKTexture(imageNamed: "LockedEquipmentPanel")
        super.init(texture: lockImage, color: .clear, size: slotImage.size())
        self.setScale(slotScale)
        self.zPosition = 40
        
        SetEquipmentInSlot(by: index)
//        addChild(equipmentInSlot)
//        addChild(equipmentNameLabel)
        
        SetUnpackMenuPanel()
        
        equipmentInSlot.AddObserver(observer: self)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetEquipmentInSlot(by index: Int){
        equipmentInSlot = Equipment(index: index)
        equipmentInSlot.setScale(0.6)
        equipmentInSlot.zPosition = 5
        equipmentInSlot.position.y += 40
        
        equipmentNameLabel = labelBuilder.Build(selectedLabel: .equipmentNameLabel)
        equipmentNameLabel.setGlyphText(equipmentInSlot.equipmentName!.rawValue)
       
        equipmentNameLabel.position.y -= 180
    }
    
    func SetUnpackMenuPanel(){
        unpackMenuPanel = UnpackPanel(index: slotIndex, skScene: currectSKScene)
        SubscribeButton(target: unpackMenuPanel)
        SubscribeButton(target: unpackMenuPanel.alphaBlackPanel)
    }
    
    func Update() {
        if equipmentInSlot.isUnlock {
            self.texture = slotImage
            //            self.size = slotImage.size()
            //            self.setScale(0.01)
            self.isLock = false

//        if currentItemInSlot == nil{
//            currentItemInSlot = itemInSlot
//            addChild(itemInSlot)
//            addChild(countLabel)
//        }
            addChild(equipmentInSlot)
            addChild(equipmentNameLabel)
            

        }else{
            self.texture  = lockImage
            self.isLock = true
            //currentItemInSlot = nil
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
