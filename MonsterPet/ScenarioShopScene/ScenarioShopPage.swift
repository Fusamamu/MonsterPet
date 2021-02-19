import Foundation
import SpriteKit

class ScenarioShopPage: BaseUIManager{
    
    private var uiBuilder: UIElementBuilder!
    
    public var slots: [ScenarioSlot]!
    public var slotCount: Int = 3
    
    public var sliderButton: Button!
    public var sliderBar   : SKSpriteNode!
    
    private var slotPadding: CGFloat = 1.7
    
    private var denominator: CGFloat!
    
    override init(skScene: SKScene){
        
        super.init(skScene: skScene)
        slots = []
        GenerateScenarioSelectionSlots(from: 0)
        //GenerateSlotConstraint()
        
        uiBuilder = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        //sliderButton = uiBuilder.Build(selectedButton: .sliderButton)
        //sliderBar = uiBuilder.Build(seletedUiElement: .verticalPageSliderBar)
        
       // currentSKScene.addChild(sliderButton)
        //currentSKScene.addChild(sliderBar)
        
       // denominator = GetUpperLimitHeight()
    }
    
    func GenerateScenarioSelectionSlots(from index: Int){
        
        for i in 0...slotCount - 1{
            
            let slot = ScenarioSlot(index: i)
            slot.setScale(0.18)
            slot.zPosition = 5
            slot.position.x = mid_X
            slot.position.y = max_Y - CGFloat(i) * slot.size.width/slotPadding - 170
            slot.positionWhenInitialized = slot.position
            slots.append(slot)
            currentSKScene.addChild(slot)
            
            
        }
    }
    
    func GenerateSlotConstraint(){
        for slot in slots{
            let limitRange = SKRange(lowerLimit: slot.position.y, upperLimit: slot.position.y + GetUpperLimitHeight())
            let limitConstranint = SKConstraint.positionY(limitRange)
            slot.constraints = [limitConstranint]
        }
    }
    
    

    
    func panForTranslation(translation: CGPoint){
        for slot in slots{
            let newPosition = CGPoint(x: slot.position.x, y: slot.position.y + translation.y)
            slot.position = newPosition
        }
        
        let sliderRange = SKRange(lowerLimit: sliderBar.position.y - sliderBar.size.height/2, upperLimit: sliderBar.position.y + sliderBar.size.height/2)
        sliderButton.constraints = [SKConstraint.positionY(sliderRange)]
       
        sliderButton.position.y = sliderBar.size.height * (1 - GetVerticalPositionInPerCenet()) + sliderBar.position.y - sliderBar.size.height/2
        
        
        
    }
    
    
    
    func GetUpperLimitHeight() -> CGFloat{
        let height = abs(slots[0].size.height/1.5 - slots.last!.position.y)
        return height
    }
    
    func GetVerticalPositionInPerCenet() -> CGFloat{
        var percent = (slots[0].position.y - slots[0].positionWhenInitialized.y)/denominator
        percent = clamp(value: percent, lower: 0, upper: 1)
        return percent
    }
    
    func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
        return min(max(value, lower), upper)
    }
//
//    func GetVerticalPositionInPercent() -> CGFloat{
//        var percent: CGFloat = 0
//        let nominator = slots[0].position.y - slots[0].positionWhenInitialized.y
//        let denominator = GetUpperLimitHeight()
//        percent = nominator/denominator
//        return percent
//    }
    
}
