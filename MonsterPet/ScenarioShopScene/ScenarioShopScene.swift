import Foundation
import SpriteKit

class ScenarioShopScene : SKScene {
    
    public var sceneName: String = "ScenarioShopScene"
    
    private let currencyManager: CurrencyManager = .sharedInstance
    
 //   private let uiBuilder: UIElementBuilder!
    
    
    private var uiManager   : ScenarioShopUIManager!
   // private var swipeManager: SwipeManager!
    
    
    private var scenarioPage: ScenarioShopPage!
    
    
    private var pageCountLabel = LabelBuilder().Build(selectedLabel: .pageCountLabel)
    
    private var currentSelectedSlot     : ScenarioSlot!
    private var slotSelectionHighlight  : SKSpriteNode!

    
    override func didMove(to view: SKView) {
        
        currentSelectedSlot = nil
        
        uiManager = ScenarioShopUIManager(skScene: self)
        scenarioPage = ScenarioShopPage(skScene: self)
        
        
        //Load Slot Unlock State from SaveData//
            //..................
        //------------------------------------//
            
        
        
        pageCountLabel.position.x = uiManager.mid_X
        pageCountLabel.position.y += 30
        pageCountLabel.setGlyphText("1|\(String(describing: 1))")
        addChild(pageCountLabel)
        
        
        slotSelectionHighlight = SKSpriteNode(imageNamed: "scenarioSelectionHighlight")
        
        CreateBackground()
        self.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 190/255, alpha: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        
        uiManager.UpdateTouch(at: location!)
        
        switch uiManager.state {
            case .allClose:
                
                if currentSelectedSlot != nil {
                    if !currentSelectedSlot.contains(location!) {
                        RemoveHighlight_PopUpInfo()
                        currentSelectedSlot.isSelected = false
                        currentSelectedSlot = nil
                    }else{
                        if currentSelectedSlot.isSelected {
                            currentSelectedSlot.isSelected = false
                            // load and chanage SCENARIO SCENE
                            //temp code//
                            RemoveHighlight_PopUpInfo()
                        }
                    }
                }
                
                for slot in scenarioPage.slots {
                    if slot.isLock && slot.contains(location!){
                        run(SoundManager.sharedInstanced.Play(by: .interfaceClick))
                        
                        currentSelectedSlot = slot
                        
                        //uiManager.state = .unlockMenuOpened
                    }
                    
                    if !slot.isLock && slot.contains(location!){
                        currentSelectedSlot = slot
                        currentSelectedSlot.isSelected = true
                        AddHighlight_PopUpInfo(at: currentSelectedSlot.position)
                    }
                }
                
                
                print("kaldsfj")
            case .unlockMenuOpened:
                
                
                
                
                
                
                print("sdlajf")
        }
        
        
       
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let location = touch?.location(in: self)
//        let previousLocation = touch?.previousLocation(in: self)
//        
//        let translation = CGPoint(x: location!.x - previousLocation!.x, y: location!.y - previousLocation!.y)
//        
//        scenarioPage.panForTranslation(translation: translation)
    }
    
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "ScenarioSceneBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.35
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
    
    func RemoveHighlight_PopUpInfo(){
        slotSelectionHighlight.removeFromParent()
        //slotPopUpInfo.removeFromParent()
    }
    
    func AddHighlight_PopUpInfo(at point: CGPoint){
        
        let scaleUp = SKAction.scale(to: 0.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.19, duration: 0.5)
        let loop = SKAction.sequence([scaleUp,scaleDown])
        
        slotSelectionHighlight.zPosition = 4
        slotSelectionHighlight.position = point
        slotSelectionHighlight.position.y += 2
        slotSelectionHighlight.setScale(0.17)
        slotSelectionHighlight.run(SKAction.repeatForever(loop))
        addChild(slotSelectionHighlight)
        
    }

    
}
