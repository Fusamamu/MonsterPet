import Foundation
import SpriteKit

class PetInfoScene : SKScene{
    
    private let currencyManager: CurrencyManager = .sharedInstance
    
    private var uiManager   : PetInfoUIManager!
    private var swipeManager: SwipeManager!
    

    var page_1: PetInfoPage!
    var pages:[PetInfoPage] = []
    
    var currentPage: PetInfoPage!
    var currentPageIndex: Int = 0
    
   
    
    override func didMove(to view: SKView) {
        uiManager = PetInfoUIManager(skScene: self)
        
        page_1 = PetInfoPage(pageIndex: 0, skScene: self as SKScene)
        pages.append(contentsOf:[page_1])
        currentPage = pages[currentPageIndex]
        addChild(currentPage)

         self.backgroundColor = UIColor(red: 228/255, green: 226/255, blue: 175/255, alpha: 1)
        
       CreateBackground()
    }
    
    var isFirstTouched: Bool = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
        
        currentPage.petCharacter.onClicked(at: location!)
        
        if isFirstTouched{
             uiManager.DisplayPetInfoPanel()
            isFirstTouched = false
        }else{
            uiManager.UnDisplayPetInfoPanel()
            isFirstTouched = true
        }


//        uiManager.DisplayPetInfoPanel()
    }
    
    func CreateBackground(){
        
        
        let backgroundTexture = SKTexture(imageNamed: "penguinBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.3
            background.zPosition = -30
            background.setScale(scale)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width*scale * CGFloat(i)) , y: 0)
            self.addChild(background)
            
            let moveLeft    = SKAction.moveBy(x: -backgroundTexture.size().width*scale, y: 0, duration: 20)
            let moveReset   = SKAction.moveBy(x: backgroundTexture.size().width*scale, y: 0, duration: 0)
            let moveLoop    = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
        
    }
}

