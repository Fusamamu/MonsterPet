import Foundation
import SpriteKit
import GameplayKit

class DetailScene: SKScene, Observer{
    
    var id: Int = 0
    
    private let currencyManager     : CurrencyManager       = .sharedInstance
    private let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    private let itemManager         : ItemManager           = .sharedInstance
   
    private var uiManager           : DetailSceneUIManager!
    private var sceneBuilder        : SceneBuilder!
    
    var currentItem         : Item!
    var currentItemIndex    : Int!
    //var itemCountLabel      : SKLabelNode = SKLabelNode(text: "Still nil")
    
    var notEnoughCoinPanel      : WarnPanel!
    var missingIngredientPanel  : WarnPanel!
    var outOfStock              : WarnPanel!
    
    private var coinCountLabel : BMGlyphLabel!
    
    override func didMove(to view: SKView) {
        
        sceneBuilder    = SceneBuilder(currentSKScene: self)
        uiManager       = DetailSceneUIManager(skScene: self)
        uiManager.InitializeBasicUIElements(itemIndex: currentItemIndex)
        uiManager.InitializeLabels(by : currentItemIndex)
        
        self.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 190/255, alpha: 1)
        
        notEnoughCoinPanel      = WarnPanel(panelImage: "notEnoughCoin", skScene: self)
        notEnoughCoinPanel.setScale(0.15)
        notEnoughCoinPanel.zPosition = 300
        
        missingIngredientPanel  = WarnPanel(panelImage: "missingIngredientPanel", skScene: self)
        missingIngredientPanel.setScale(0.15)
        missingIngredientPanel.zPosition = 300
        
        outOfStock              = WarnPanel(panelImage: "outOfStockPanel", skScene: self)
        outOfStock.setScale(0.15)
        outOfStock.zPosition = 300
        
        uiManager.buyButton.SubscribeButton(target: notEnoughCoinPanel)
        uiManager.makeButton.SubscribeButton(target: missingIngredientPanel)
        uiManager.placeButton.SubscribeButton(target: outOfStock)
        
        if currentItem == nil{
            currentItem = Item(index: currentItemIndex)
            currentItem.setScale(0.2)
            currentItem.position = uiManager.centerPosition
            currentItem.position.y += 195
            currentItem.zPosition = 6
            addChild(currentItem)
            currentItem.AddObserver(observer: self)
            currentItem.count = itemManager.itemCountInventory[currentItem.itemName]!
        }
 
        itemManager.SetCurrentScene(to: self)
        
        coinCountLabel = BMGlyphLabel(txt: String(currencyManager.CoinCounts), fnt: BMGlyphFont(name: "TitleText"))
        coinCountLabel.setHorizontalAlignment(.right)
        coinCountLabel.position = uiManager.upperLeftPosition
        coinCountLabel.position.x += 145
        coinCountLabel.position.y -= 38
        coinCountLabel.zPosition = 200
        coinCountLabel.setScale(1)
        currencyManager.AddObserver(observer: self)
        addChild(coinCountLabel)
        
        CreateBackground()
        
        let textAnimation = TextAnimation(skScene: self)
        currencyManager.AddObserver(observer: textAnimation)
        
    }
    
    override func willMove(from view: SKView) {
        //Don't know why I have to remove observer????
        //currentItem.count -= 1 ***********
        currentItem.RemoveObserver(observer: self)
        currentItem.removeFromParent()
        currentItem = nil
        
        currencyManager.RemoveObserver(observer: self)
        
        currencyManager.observers.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
        
        if notEnoughCoinPanel.isOpened{
            notEnoughCoinPanel.Invoked()
        }
        
        if missingIngredientPanel.isOpened{
            missingIngredientPanel.Invoked()
        }
        
        if outOfStock.isOpened{
            outOfStock.Invoked()
        }
        
        if uiManager.buyButton.contains(location!){
            currentItem.BuyItem()
        }
        
        if uiManager.makeButton.contains(location!){
            currentItem.MakeItem()
        }
        
        if uiManager.placeButton.contains(location!){
            if currentItem.count > 0{
                currentItem.outOfStock = false
                LoadGameScene()
            }else{
                currentItem.outOfStock = true
                currentItem.NotifyAllObservers()
            }
        }
    }
    
    func Update() {
        //Do not know why need to check against nil?
        if coinCountLabel != nil {
            coinCountLabel.setGlyphText(String(currencyManager.CoinCounts))
        }
        uiManager.quantityLabel.setGlyphText("x" + String(currentItem.count))
        ItemManager.sharedInstance.TempCount = currentItem.count
        
        if currentItem.notEnoughCoin {
            currentItem.notEnoughCoin = false
            notEnoughCoinPanel.Invoked()
        }
        if currentItem.missingIngredient{
            currentItem.missingIngredient = false
            missingIngredientPanel.Invoked()
        }
        
        if currentItem.outOfStock{
            currentItem.outOfStock = false
            outOfStock.Invoked()
        }
    
    }
    
    func LoadGameScene(){
        
        let mainScene = sceneBuilder.Create(selectedScene: .mainScene)
        
        placeHolderManager.AddArrowImages(to: mainScene)
        
        itemManager.TempCount  = currentItem.count
        itemManager.tempItemHolder = currentItem
  
        view?.presentScene(mainScene)
    }
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "foodScrollBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.15
            background.zPosition = -30 - CGFloat(i)
            background.setScale(scale)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width * scale * CGFloat(i))  , y: 0)
            self.addChild(background)

            let moveLeft    = SKAction.moveBy(x: -backgroundTexture.size().width*scale, y: 0, duration: 8)
            let moveReset   = SKAction.moveBy(x: backgroundTexture.size().width*scale, y: 0, duration: 0)
            let moveLoop    = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)

            background.run(moveForever)
            
        }
    }
}
