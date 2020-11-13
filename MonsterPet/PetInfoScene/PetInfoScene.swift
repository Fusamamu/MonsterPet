import Foundation
import SpriteKit

class PetInfoScene : SKScene{
    
    private let currencyManager: CurrencyManager        = .sharedInstance
    private let petInfoPageManager: PetInfoPageManager  = .sharedInstance
    
    private var uiManager   : PetInfoUIManager!
    private var swipeManager: SwipeManager!
    
//    var page_1: PetInfoPage!
//    var page_2: PetInfoPage!
//    var page_3: PetInfoPage!
//    var pages:[PetInfoPage] = []
    
    var currentPage: PetInfoPage!
    var currentPageIndex: Int = 0

    override func didMove(to view: SKView) {
        uiManager       = PetInfoUIManager(skScene: self)
        swipeManager    = SwipeManager(skScene: self)
        swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
        
//        page_1 = PetInfoPage(pageIndex: 0, skScene: self as SKScene)
//        page_2 = PetInfoPage(pageIndex: 1, skScene: self as SKScene)
//        page_3 = PetInfoPage(pageIndex: 2, skScene: self as SKScene)
//        pages.append(contentsOf:[page_1, page_2, page_3])
        
        petInfoPageManager.pages[currentPageIndex].position.x = 0;
        currentPage = petInfoPageManager.pages[currentPageIndex]
        addChild(currentPage)

        self.backgroundColor = UIColor(red: 228/255, green: 226/255, blue: 175/255, alpha: 1)
        
        CreateBackground()
    }
    
    //var isFirstTouched: Bool = true
    
    override func willMove(from view: SKView) {
        currentPage.removeFromParent()
        petInfoPageManager.pages[currentPageIndex].removeFromParent()
      //  itemPageManager.pages[currentPage.pageIndex].removeFromParent()
        currentPage = nil
        swipeManager.RemoveSwipeGesture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
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

