import Foundation
import SpriteKit

class PetInfoScene : SKScene{
    
    private let currencyManager: CurrencyManager        = .sharedInstance
    private let petInfoPageManager: PetInfoPageManager  = .sharedInstance
    
    private var uiManager   : PetInfoUIManager!
    private var swipeManager: SwipeManager!
    
    var currentPage: PetInfoPage!
    var currentPageIndex: Int = 0
    let maxPageNumber: Int = 3
    
    private var pageCountLabel = LabelBuilder().Build(selectedLabel: .pageCountLabel)

    override func didMove(to view: SKView) {
        uiManager       = PetInfoUIManager(skScene: self)
        swipeManager    = SwipeManager(skScene: self)
        swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
        
        petInfoPageManager.pages[currentPageIndex].position.x = 0;
        currentPage = petInfoPageManager.pages[currentPageIndex]
        addChild(currentPage)

        CreateBackground()
        AddPageCountLabel()
        self.backgroundColor = UIColor(red: 228/255, green: 226/255, blue: 175/255, alpha: 1)
    }
        
    override func willMove(from view: SKView) {
        currentPage.removeFromParent()
        petInfoPageManager.pages[currentPageIndex].removeFromParent()
        currentPage = nil
        swipeManager.RemoveSwipeGesture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
    }
    
    private func AddPageCountLabel(){
        pageCountLabel.zPosition    = 200
        pageCountLabel.position.x   = uiManager.mid_X
        pageCountLabel.position.y += 40
        pageCountLabel.setGlyphText("1|\(String(describing: maxPageNumber))")
        addChild(pageCountLabel)
    }
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "catBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.4
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
    
    @objc func swipedRight(sender:UISwipeGestureRecognizer){
        print("swipeRight")
        if currentPageIndex != 0 {
            currentPage.MoveOutRight()
            currentPage = nil
            currentPageIndex -= 1
            currentPage = petInfoPageManager.pages[currentPageIndex]
            currentPage.position.x = -600
            addChild(currentPage)
            currentPage.MoveInRight()
            
//            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|\(String(describing: maxPageNumber))")
        }
        else {
            print("end of page")
        }
    }
    
    ///<-----////
    
    @objc func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swipeLeft")
        if currentPageIndex < 2{
            
            currentPage.MoveOutLeft()
            currentPage = nil
            
            currentPageIndex += 1
            currentPage = petInfoPageManager.pages[currentPageIndex]
            currentPage.position.x = 600
            addChild(currentPage)
            currentPage.MoveInLeft()
            
//            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|\(String(describing: maxPageNumber))")
        }
        else {
            print("end of page")
        }
    }
}

