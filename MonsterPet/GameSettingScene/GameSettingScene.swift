import Foundation
import SpriteKit

class GameSettingScene : SKScene{
    
    private let currencyManager : CurrencyManager = .sharedInstance
    
    private var uiManager       : GameSettingUIManager!
    private var swipeManager    : SwipeManager!
    
    var currentPageIndex: Int = 0
    var currentPage     : EquipmentSelectionPage!
    
    override func didMove(to view: SKView) {
        uiManager = GameSettingUIManager(skScene: self)
        self.backgroundColor = UIColor(red: 178/255, green: 176/255, blue: 122/255, alpha: 1)
        CreateBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
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
}
