import Foundation
import SpriteKit

class HeartShopScene : SKScene{
    
    public var sceneName            : String = "HeartShopScene"
    public var previousSceneName    : String!
    
    private let currencyManager: CurrencyManager = .sharedInstance
    
    private var uiManager   : HeartShopUIManager!
    private var swipeManager: SwipeManager!

    
    private var heartShopPage: HeartShopPage!
    private var currentPage: HeartShopPage!
    private var currentPageIndex: Int = 0
    
    private var heartShopBackground: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        uiManager = HeartShopUIManager(skScene: self)
        
        if previousSceneName != nil{
            uiManager.previousSceneName = previousSceneName
        }
        
        heartShopPage = HeartShopPage(skScene: self)
        
        self.backgroundColor = UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1)
        
        AddBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
    }
    
    private func AddBackground(){
        heartShopBackground = SKSpriteNode(imageNamed: "heartShopBackground")
        heartShopBackground.zPosition = 0
        heartShopBackground.setScale(0.3)
        heartShopBackground.anchorPoint = CGPoint.zero
        addChild(heartShopBackground)
    }
}
