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
        
        let translation = CGPoint(x: location!.x - previousLocation!.x, y: location!.y - previousLocation!.y)
        
        scenarioPage.panForTranslation(translation: translation)
    }
    

    
}
