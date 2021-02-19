import Foundation
import SpriteKit

class ScenarioShopScene : SKScene {
    
    private let currencyManager: CurrencyManager = .sharedInstance
    
 //   private let uiBuilder: UIElementBuilder!
    
    
    private var uiManager   : ScenarioShopUIManager!
   // private var swipeManager: SwipeManager!
    
    
    private var scenarioPage: ScenarioShopPage!

    
    override func didMove(to view: SKView) {
        uiManager = ScenarioShopUIManager(skScene: self)
        scenarioPage = ScenarioShopPage(skScene: self)
        self.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 190/255, alpha: 1)
        
        CreateBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let previousLocation = touch?.previousLocation(in: self)
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

    
}
