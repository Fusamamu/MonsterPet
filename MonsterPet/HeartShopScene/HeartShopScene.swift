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
    
    private var pageCountLabel = LabelBuilder().Build(selectedLabel: .pageCountLabel)
    
    private var heartShopBackground: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        uiManager = HeartShopUIManager(skScene: self)
        
        if previousSceneName != nil{
            uiManager.previousSceneName = previousSceneName
        }
        
        heartShopPage = HeartShopPage(skScene: self)
        
        pageCountLabel.position.x = uiManager.mid_X
        pageCountLabel.position.y += 30
        pageCountLabel.setGlyphText("1|\(String(describing: 1))")
        addChild(pageCountLabel)
        
        self.backgroundColor = UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1)
        CreateBackground()
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
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "heartSceneBackground")
        
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
}
