import Foundation
import SpriteKit

class DetailSceneUIManager: BaseUIManager{
    
    private let layerManager: LayerManager = .sharedInstance
    
    private var sceneBuilder        : SceneBuilder!
    private var uiElementBuilder    : UIElementBuilder!
    private var labelBuilder        : LabelBuilder!
    
    public var currentItemIndex: Int!
    
    private var detailPanel     : SKSpriteNode!
    private var backgroundImage : SKSpriteNode!
    private var bottomBar       : SKSpriteNode!

    private var ingredientRequirementSlots: [SKSpriteNode] = []

  //  private let barScale:CGFloat = 0.3
    
   
    
    public var homeButton       : Button!
    public var backButton       : Button!
    public var placeButton      : Button!
    public var buyButton        : Button!
    public var makeButton       : Button!
    
    public var quantityLabel    : BMGlyphLabel!
    

    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: skScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        backButton          = uiElementBuilder.Build(selectedButton: .backButton)
        placeButton         = uiElementBuilder.Build(selectedButton: .placeItemButton)
        buyButton           = uiElementBuilder.Build(selectedButton: .buyItemButton)
        makeButton          = uiElementBuilder.Build(selectedButton: .makeItemButton)
        bottomBar           = uiElementBuilder.Build(seletedUiElement: .bottomBar)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(backButton)
        currentSKScene.addChild(bottomBar)
        currentSKScene.addChild(placeButton)
        currentSKScene.addChild(buyButton)
        currentSKScene.addChild(makeButton)
        
        SetDetailPanel()
        //InitializeLabels()
        
        SetLayers()

    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if backButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .foodMenuScene))
        }
    }
    
    private func SetDetailPanel(){
          
        detailPanel = SKSpriteNode(imageNamed: "detailPanel")
        detailPanel.setScale(0.13)
        detailPanel.position = centerPosition
        detailPanel.position.y -= 80
        detailPanel.zPosition = 1
        currentSKScene.addChild(detailPanel)



        let foodQuantityBar = SKSpriteNode(imageNamed: "equipmentFoodMenuButton")
        
        foodQuantityBar.setScale(0.13)
        foodQuantityBar.position = centerPosition
        foodQuantityBar.position.y -= 50
        foodQuantityBar.zPosition = layerManager.layer_3
        currentSKScene.addChild(foodQuantityBar)
        
        let itemIngredientRequirementBar = SKSpriteNode(imageNamed: "itemIngredientRequirement")
        
        itemIngredientRequirementBar.setScale(0.13)
        itemIngredientRequirementBar.position = centerPosition
        itemIngredientRequirementBar.position.y -= 150
        itemIngredientRequirementBar.zPosition = layerManager.layer_3
        currentSKScene.addChild(itemIngredientRequirementBar)
        
        
        
        for i in 0...2{
            let ingredientRequirementSlot = SKSpriteNode(imageNamed: "ingredientRequirementSlot")
            ingredientRequirementSlot.setScale(0.13)
            ingredientRequirementSlot.position = centerPosition
            ingredientRequirementSlot.position.y -= 135
            ingredientRequirementSlot.position.x -= 62
            ingredientRequirementSlot.position.x += CGFloat(i) * 62
            ingredientRequirementSlot.zPosition = layerManager.layer_4
            currentSKScene.addChild(ingredientRequirementSlot)
            ingredientRequirementSlots.append(ingredientRequirementSlot)
        }
        
    }
    
    public func InitializeBasicUIElements(itemIndex: Int){
        
        let currencyIcon    = uiElementBuilder.Build(seletedUiIcon: .coin)
        let bar_1           = uiElementBuilder.Build(seletedUiElement: .bar)
        currencyIcon.position.y += 33
        bar_1.position.y -= 10

        currentSKScene.addChild(currencyIcon)
        currentSKScene.addChild(bar_1)

        let itemFloorImage = SKSpriteNode(imageNamed: "equipmentFloor")
        itemFloorImage.setScale(0.2)
        itemFloorImage.zPosition = layerManager.layer_0
        itemFloorImage.position = centerPosition
        itemFloorImage.position.y += 150
        currentSKScene.addChild(itemFloorImage)
        
        currentItemIndex = itemIndex
        
        let itemIcon = SKSpriteNode(imageNamed: ItemName.allCases[currentItemIndex].rawValue )
        itemIcon.position = centerPosition
        itemIcon.position.x -= 70
        itemIcon.position.y -= 44
        itemIcon.setScale(0.06)
        itemIcon.zPosition = layerManager.layer_9
        currentSKScene.addChild(itemIcon)

        let coinIcon = SKSpriteNode(imageNamed: "currencyIcon")
        coinIcon.position = centerPosition
        coinIcon.position.x -= 69
        coinIcon.position.y -= 177
        coinIcon.setScale(0.08)
        coinIcon.zPosition = layerManager.layer_9
        currentSKScene.addChild(coinIcon)
        
    }
    
    public func InitializeLabels(by itemIndex: Int){
        
        let description             = labelBuilder.Build(selectedLabel: .equipmentNameLabel)
        description.setHorizontalAlignment(BMGlyphLabel.BMGlyphHorizontalAlignment.centered)
        description.position    = centerPosition
        description.position.y += 30
        description.zPosition = layerManager.layer_9
        description.setScale(0.55)
        description.setGlyphText("Whatever")
        currentSKScene.addChild(description)
        
        
        let itemNameLabel         = labelBuilder.Build(selectedLabel: .equipmentNameLabel)
        itemNameLabel.setScale(0.5)
        itemNameLabel.position    = centerPosition
        itemNameLabel.position.y -= 50
        itemNameLabel.setGlyphText("Default Text")
        currentSKScene.addChild(itemNameLabel)
        
        quantityLabel       = labelBuilder.Build(selectedLabel: .itemCountLabel)
        quantityLabel.setScale(0.7)
        quantityLabel.zPosition = layerManager.layer_9
        quantityLabel.position = itemNameLabel.position
        quantityLabel.position.x += 85
        quantityLabel.setGlyphText("x0")
        currentSKScene.addChild(quantityLabel)
        
        let coinRequirementLabel = labelBuilder.Build(selectedLabel: .itemCountLabel)
        coinRequirementLabel.setScale(0.7)
        coinRequirementLabel.zPosition = layerManager.layer_9
        coinRequirementLabel.position = centerPosition
        coinRequirementLabel.position.y -= 180
        coinRequirementLabel.position.x += 80
        coinRequirementLabel.setGlyphText("30")
        currentSKScene.addChild(coinRequirementLabel)
        
        let path = Bundle.main.path(forResource: "ItemData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let itemName = ItemName.allCases[itemIndex].rawValue
        let requestedItem = dict?.object(forKey: itemName) as! [String:Any]
        
        itemNameLabel.setGlyphText(itemName)
        description.setGlyphText(requestedItem["Description"] as! String)
        coinRequirementLabel.setGlyphText(requestedItem["CoinRequirement"] as! String)
        
       // RequiredIngredient_1
        for i in 0...2{
            let requiredIngredient = requestedItem["RequiredIngredient_" + String(i+1)] as! String
            if requiredIngredient == "None"{
                ingredientRequirementSlots[i].texture = SKTexture(imageNamed: "ingredientNonRequirementSlot")
            }
        }
    }
    
    private func LoadTextToLabels(){
        
    }
    
    
    
    private func SetLayers(){
        homeButton.zPosition    = layerManager.layer_4
        backButton.zPosition    = layerManager.layer_4
        placeButton.zPosition   = layerManager.layer_4
        buyButton.zPosition     = layerManager.layer_4
        makeButton.zPosition    = layerManager.layer_4
    
        bottomBar.zPosition     = layerManager.layer_2
        
        detailPanel.zPosition   = layerManager.layer_1
        
    }
      
}
