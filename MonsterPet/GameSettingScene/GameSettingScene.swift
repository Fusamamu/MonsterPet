import Foundation
import SpriteKit

class GameSettingScene : SKScene{
    
    private let currencyManager : CurrencyManager = .sharedInstance
    private let soundManager    : SoundManager    = .sharedInstanced
    
    private var uiManager       : GameSettingUIManager!
    private var swipeManager    : SwipeManager!
    
    var currentPageIndex: Int = 0
    var currentPage     : EquipmentSelectionPage!
    
    public var BMG_Percentage_VOL   : CGFloat = 50
    public var SE_Percentage_VOL    : CGFloat = 50
    
    private let slider_lower_limit  : CGFloat = -90
    private let slider_upper_limit  : CGFloat = 470
    private var lower_limit         : CGFloat { get { return slider_lower_limit + 90 } }
    private var upper_limit         : CGFloat { get { return slider_upper_limit + 90 } }
    
    override func didMove(to view: SKView) {
        uiManager = GameSettingUIManager(skScene: self)
        self.backgroundColor = UIColor(red: 178/255, green: 176/255, blue: 122/255, alpha: 1)
        CreateBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
        
        let locationInGameSettingPanel = touch?.location(in: uiManager.gameSettingPanel)
        
        if uiManager.BGM_slideButton.contains(locationInGameSettingPanel!) {
            print("BGM_slide Button contanian location and selected")
            uiManager.BGM_slideButton.isSeleted = true
        }
        if uiManager.SE_slideButton.contains(locationInGameSettingPanel!) {
            uiManager.SE_slideButton.isSeleted  = true
        }
        
       

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: uiManager.gameSettingPanel)
        let previousLocation = touch?.previousLocation(in: uiManager.gameSettingPanel)

        let translation = CGPoint(x: location!.x - previousLocation!.x, y: location!.y)

        
        if uiManager.BGM_slideButton.isSeleted {
            panForTranslation(button: uiManager.BGM_slideButton, translation: translation)
        }
        if uiManager.SE_slideButton.isSeleted {
            panForTranslation(button: uiManager.SE_slideButton, translation: translation)
        }
        
        
        BMG_Percentage_VOL  = GetVolumePercentage(from: uiManager.BGM_slideButton.position)
        SE_Percentage_VOL   = GetVolumePercentage(from: uiManager.SE_slideButton.position)
        
        soundManager.Set_BGM_VOL(by: (Float)(BMG_Percentage_VOL))
        soundManager.Set_SE_VOL(by: (Float)(SE_Percentage_VOL))
        
        print("BMG Percent VOL")
        print(SE_Percentage_VOL)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        uiManager.BGM_slideButton.isSeleted     = false
        uiManager.SE_slideButton.isSeleted      = false
    }
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "GameSettingSceneBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.33
            background.zPosition = -30 - CGFloat(i)
            background.setScale(scale)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * scale * CGFloat(i))  , y: 0)
            self.addChild(background)

            let moveLeft    = SKAction.moveBy(x: -backgroundTexture.size().width*scale, y: 0, duration: 14)
            let moveReset   = SKAction.moveBy(x: backgroundTexture.size().width*scale, y: 0, duration: 0)
            let moveLoop    = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            background.run(moveForever)
            
        }
    }
    
    //    func GenerateSlotConstraint(){
    //        for slot in slots{
    //            let limitRange = SKRange(lowerLimit: slot.position.y, upperLimit: slot.position.y + GetUpperLimitHeight())
    //            let limitConstranint = SKConstraint.positionY(limitRange)
    //            slot.constraints = [limitConstranint]
    //        }
    //    }
    
    func panForTranslation(button: Button, translation: CGPoint){
        let newPosition = CGPoint(x: button.position.x + translation.x, y: button.position.y)
        button.position = newPosition
        
        let sliderRange = SKRange(lowerLimit: slider_lower_limit, upperLimit: slider_upper_limit)
        button.constraints = [SKConstraint.positionX(sliderRange)]
    }
    
    
    func GetVolumePercentage(from buttonPosition: CGPoint) -> CGFloat {
        let nominator  :CGFloat  = (buttonPosition.x + 90)
        let denominator:CGFloat  = upper_limit
        var percentage: CGFloat     = nominator/denominator
        
        if percentage < 0{
            percentage = 0
        }
        if percentage > 1{
            percentage = 1
        }
        
        return percentage;
    }
        

        
    //    func panForTranslation(translation: CGPoint){
    //        for slot in slots{
    //            let newPosition = CGPoint(x: slot.position.x, y: slot.position.y + translation.y)
    //            slot.position = newPosition
    //        }
    //
    //        let sliderRange = SKRange(lowerLimit: sliderBar.position.y - sliderBar.size.height/2, upperLimit: sliderBar.position.y + sliderBar.size.height/2)
    //        sliderButton.constraints = [SKConstraint.positionY(sliderRange)]
    //
    //        sliderButton.position.y = sliderBar.size.height * (1 - GetVerticalPositionInPerCenet()) + sliderBar.position.y - sliderBar.size.height/2
    //
    //
    //
    //    }
    //
        
        
    //    func GetUpperLimitHeight() -> CGFloat{
    //        let height = abs(slots[0].size.height/1.5 - slots.last!.position.y)
    //        return height
    //    }
    //
    //    func GetVerticalPositionInPerCenet() -> CGFloat{
    //        var percent = (slots[0].position.y - slots[0].positionWhenInitialized.y)/denominator
    //        percent = clamp(value: percent, lower: 0, upper: 1)
    //        return percent
    //    }
    //
    //    func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    //        return min(max(value, lower), upper)
    //    }
    //
    //    func GetVerticalPositionInPercent() -> CGFloat{
    //        var percent: CGFloat = 0
    //        let nominator = slots[0].position.y - slots[0].positionWhenInitialized.y
    //        let denominator = GetUpperLimitHeight()
    //        percent = nominator/denominator
    //        return percent
    //    }
}
