import Foundation
import SpriteKit

class FoodMenuUIManager: BaseUIManager{
    
    
    public var dialogueLabel: BMGlyphLabel!
    
    private var sceneBuilder        : SceneBuilder!
    private var uiElementBuilder    : UIElementBuilder!
    private var labelBuilder        : LabelBuilder!
    private var layerManager        : LayerManager = .sharedInstance
    
    enum FoodUIState{
        case allClose
        case unpackMenuOpend
    }
    
    public var state: FoodUIState = .allClose
    
    private var font            : BMGlyphFont!
    private var itemMenuBarLabel: BMGlyphLabel!
    
    var homeButton          : Button!
    var buyHeartButton      : Button!
    var nextPageLeftButton  : Button!
    var nextPageRightButton : Button!
    
    var titleIcon           : SKSpriteNode!
    var pageCountBar        : SKSpriteNode!
    var itemMenuBar         : SKSpriteNode!
    var dialogueBlock       : SKSpriteNode!
    var inventoryBackground : SKSpriteNode!
    var gridBackground      : SKSpriteNode!
    
    private var penguinBust         : SKSpriteNode!
    private var windMillBase        : SKSpriteNode!
    private var propeller           : SKSpriteNode!
    private var cloud               : SKSpriteNode!
    private var bus                 : SKSpriteNode!
    
    

    override init(skScene: SKScene) {
        
        super.init(skScene: skScene)
        
        sceneBuilder        = SceneBuilder(currentSKScene: skScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()

        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        buyHeartButton      = uiElementBuilder.Build(selectedButton: .buyHeartButton)
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        
        titleIcon           = uiElementBuilder.Build(seletedUiIcon: .foodTitleIcon)
        pageCountBar        = uiElementBuilder.Build(seletedUiElement: .pageCountBar)
        dialogueBlock       = uiElementBuilder.Build(seletedUiElement: .dialogueBox)
        inventoryBackground = uiElementBuilder.Build(seletedUiElement: .inventoryBackground)
        gridBackground      = uiElementBuilder.Build(seletedUiElement: .gridBackground)

        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(buyHeartButton)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        
        currentSKScene.addChild(titleIcon)
        currentSKScene.addChild(pageCountBar)
        currentSKScene.addChild(dialogueBlock)
        currentSKScene.addChild(inventoryBackground)
        currentSKScene.addChild(gridBackground)

        font = BMGlyphFont(name: "petText")

        AddBasicImages()
        AddDialogueLabel()
        
        SetUILayers()
        
        
        
        
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("ITEM")
        titleLabel.zPosition = layerManager.layer_9
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 50
        titleLabel.position.y -= 8
        currentSKScene.addChild(titleLabel)
        
    }
    
    //Make new Design to this header
    
    func AddItemHeader(){
        itemMenuBarLabel = BMGlyphLabel(txt: "Item", fnt: font)
        itemMenuBarLabel.setHorizontalAlignment(.centered)
        itemMenuBarLabel.setScale(0.3)
        itemMenuBarLabel.zPosition = 21
        //itemMenuBarLabel.position = CGPoint(x: minX + 100, y: maxY - 40)
        currentSKScene.addChild(itemMenuBarLabel)
        
        
        itemMenuBar = SKSpriteNode(imageNamed: "itemMenuBar")
        itemMenuBar.zPosition = 20
        //itemMenuBar.position = CGPoint(x: minX + 100, y: maxY - 50)
        itemMenuBar.setScale(0.15)
        currentSKScene.addChild(itemMenuBar)
    }
    
    private func AddBasicImages(){
        penguinBust = SKSpriteNode(imageNamed: "penguinBust")
        penguinBust.position = lowerLeftPosition
        penguinBust.position.x += 60
        penguinBust.position.y += 50
        penguinBust.setScale(0.25)
        penguinBust.zPosition = layerManager.layer_9

        currentSKScene.addChild(penguinBust)
        
        windMillBase = SKSpriteNode(imageNamed: "windMillBase")
        windMillBase.position = lowerRightPosition
        windMillBase.position.x -= 60
        windMillBase.position.y += 50
        windMillBase.setScale(0.25)
        windMillBase.zPosition = layerManager.layer_7
        
        currentSKScene.addChild(windMillBase)
        
        propeller = SKSpriteNode(imageNamed: "propeller")
        propeller.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        propeller.position = windMillBase.position
        propeller.position.x -= 10
        propeller.position.y += 70
        propeller.setScale(0.25)
        propeller.zPosition = layerManager.layer_8
        
        propeller.run(SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 1)))
        
        currentSKScene.addChild(propeller)
        
        cloud = SKSpriteNode(imageNamed: "foodCloud")
        cloud.setScale(0.25)
        cloud.zPosition = layerManager.layer_3
        cloud.position = centerPosition
        cloud.position.y -= 100
        
        let moveLeft = SKAction.moveBy(x: -cloud.texture!.size().width, y: 0, duration: 20)
        let reset    = SKAction.moveTo(x: currentSKScene.frame.width, duration: 0)
        cloud.run(SKAction.repeatForever(SKAction.sequence([moveLeft, reset])))
        
        currentSKScene.addChild(cloud)
        
        
    }
    
    private func AddDialogueLabel(){
        dialogueLabel = BMGlyphLabel(txt: "Put Text in here", fnt: BMGlyphFont(name: "peng"))
        dialogueLabel.setHorizontalAlignment(.centered)
        dialogueLabel.position = centerPosition
        dialogueLabel.position.y -= 190
        dialogueLabel.zPosition = 200
        dialogueLabel.setScale(1.4)
        
        currentSKScene.addChild(dialogueLabel)
        
       // UpdateDialogueLabel(by: 0)
    }
    
    
    public func UpdateDialogueLabel(by index: Int){
        
        let path = Bundle.main.path(forResource: "ItemData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)!
        let itemName = ItemName.allCases[index].rawValue
        let requestedItem = dict.object(forKey: itemName) as! [String:Any]
        
        let dialogueText = requestedItem["DialogueText"] as! String
        
        dialogueLabel.setGlyphText(dialogueText)
        

           
        
    }
    
    // Find a way to create scrollable background builder/ ACtion manager??
    
    func CreateBackground(){
        
        
        let backgroundTexture = SKTexture(imageNamed: "ScrollBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -30
            background.setScale(0.5)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width/2 * CGFloat(i)) , y: 0)
            currentSKScene.addChild(background)
            
            let moveLeft    = SKAction.moveBy(x: -backgroundTexture.size().width/2, y: 0, duration: 10)
            let moveReset   = SKAction.moveBy(x: backgroundTexture.size().width/2, y: 0, duration: 0)
            let moveLoop    = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
        
    }
    
    func UpdateTouch(at location: CGPoint){
        
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if buyHeartButton.contains(location){
            let nextScene = sceneBuilder.Create(selectedScene: .heartShopScene) as! HeartShopScene
            nextScene.previousSceneName = "FoodMenuScene"
            currentSKScene.view?.presentScene(nextScene)
        }
    }
    
    private func SetUILayers(){
        
        titleIcon.zPosition             = layerManager.layer_8
            
        homeButton.zPosition            = layerManager.layer_9
        buyHeartButton.zPosition        = layerManager.layer_9
        nextPageLeftButton.zPosition    = layerManager.layer_9
        nextPageRightButton.zPosition   = layerManager.layer_9
        pageCountBar.zPosition          = layerManager.layer_8
        
        dialogueBlock.zPosition         = layerManager.layer_3
        inventoryBackground.zPosition   = layerManager.layer_4
        gridBackground.zPosition        = layerManager.layer_5
        
        penguinBust.zPosition           = layerManager.layer_4
        dialogueLabel.zPosition         = layerManager.layer_4
    }
    
    
}
