import Foundation
import SpriteKit

class BuyHeartSlot: SKSpriteNode{

    public var coinRequired: CGFloat!
    private(set) var slotImage   : SKTexture!
    private var slotIndex: Int!
    private var slotName: BuyHeartSlotName!

    public var positionWhenInitialized: CGPoint!
    
    private var gainedHeartAmount   : Int! = 50
    private var price               : Int! = 29
    
    
    private var labelBuilder        : LabelBuilder!
    private var gainedHeartLabel    : BMGlyphLabel!
    private var priceTagLabel       : BMGlyphLabel!

    init(index: Int){
        slotIndex   = index
        slotName    = BuyHeartSlotName.allCases[index]
        slotImage   = SKTexture(imageNamed: BuyHeartSlotName.allCases[index].rawValue)
        super.init(texture: slotImage , color: .clear, size: slotImage.size())
        
        SetGainedAmountAndPricTag()
        AddLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func AddLabels(){
        labelBuilder        = LabelBuilder()
        gainedHeartLabel    = labelBuilder.Build(selectedLabel: .priceTag)
        priceTagLabel       = labelBuilder.Build(selectedLabel: .priceTag)
        
        gainedHeartLabel.setGlyphText("\(String(describing: gainedHeartAmount!))")
        
        gainedHeartLabel.position.x += 270
        gainedHeartLabel.position.y += 120
        
        priceTagLabel.setGlyphText("\(String(describing: price!))THB")
        priceTagLabel.position.x += 270
        priceTagLabel.position.y -= 170
        
        self.addChild(gainedHeartLabel)
        self.addChild(priceTagLabel)
    }
    
    private func SetGainedAmountAndPricTag(){
        switch slotName {
        case .casualHeart:
            gainedHeartAmount = 10
            price = 19
        case .lovelyHeart:
            gainedHeartAmount = 15
            price = 29
        case .sweetHeart:
            gainedHeartAmount = 25
            price = 39
        default :
            print("Failed to set amount!")
        }
    }
}

enum BuyHeartSlotName: String, CaseIterable{
    
    case casualHeart = "buyCasualHeart"
    case lovelyHeart = "buyLovelyHeart"
    case sweetHeart  = "buySweetHeart"

    
    static var count: Int { return BuyHeartSlotName.sweetHeart.hashValue + 1}
}

