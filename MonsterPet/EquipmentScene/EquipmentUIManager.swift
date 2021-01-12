import Foundation
import GameplayKit
import SpriteKit

class EquipmentUIManager: BaseUIManager{
    
    private let layerManager: LayerManager = .sharedInstance
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    private var labelBuilder        : LabelBuilder!
    
    enum EquipmentUIState{
        case allClose
        case unpackMenuOpend
    }
    
    public var state: EquipmentUIState = .allClose
    
    public var dialogueLabel: BMGlyphLabel!
    
    public var homeButton       : Button!
    public var buyHeartButton   : Button!
    public var nextPageLeftButton  : Button!
    public var nextPageRightButton : Button!
    
    private var titleIcon        : SKSpriteNode!
    private var pageCountBar     : SKSpriteNode!
    private var background       : SKSpriteNode!
    
    public var dialogueBlock    : SKSpriteNode!
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        buyHeartButton      = uiElementBuilder.Build(selectedButton: .buyHeartButton)
        
        background          = uiElementBuilder.Build(seletedUiElement: .inventoryBackground)
        
            
            let IntroductoryDialogue: String = "\t Welcome to our kitchen! \n  Unlock equipments and \n make your favorite recipes."
        
            dialogueLabel = BMGlyphLabel(txt: IntroductoryDialogue, fnt: BMGlyphFont(name: "hd"))
            dialogueLabel.setHorizontalAlignment(.centered)
            dialogueLabel.position.y += 90
            dialogueLabel.zPosition = 200
        dialogueLabel.setScale(3.7)
        
        dialogueBlock       = uiElementBuilder.Build(seletedUiElement: .dialogueBox)
        
        nextPageLeftButton  = uiElementBuilder.Build(selectedButton: .nextPageLeftButton)
        nextPageRightButton = uiElementBuilder.Build(selectedButton: .nextPageRightButton)
        pageCountBar        = uiElementBuilder.Build(seletedUiElement: .pageCountBar)
        
        titleIcon           = uiElementBuilder.Build(seletedUiIcon: .equipmentTitleIcon)
        
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(buyHeartButton)
        currentSKScene.addChild(background)
        currentSKScene.addChild(nextPageLeftButton)
        currentSKScene.addChild(nextPageRightButton)
        currentSKScene.addChild(pageCountBar)
        currentSKScene.addChild(titleIcon)
        
        AddTakeAnimation()
        AddDialogueLabel(by: nil)
        SetUILayers()
        
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("TOOL")
        titleLabel.zPosition = layerManager.layer_9
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 50
        titleLabel.position.y -= 8
        currentSKScene.addChild(titleLabel)
        
        let kitchenBackground = SKSpriteNode(imageNamed: "equipmentBackground")
        kitchenBackground.position = centerPosition
        kitchenBackground.position.y -= 210
        kitchenBackground.setScale(0.22)
        kitchenBackground.zPosition = 1
        currentSKScene.addChild(kitchenBackground)
        
        
        
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if buyHeartButton.contains(location){
            let nextScene = sceneBuilder.Create(selectedScene: .heartShopScene) as! HeartShopScene
            nextScene.previousSceneName = "EquipmentMenuScene"
            currentSKScene.view?.presentScene(nextScene)
        }
    }
    
    public func AddDialogueLabel(by equipmentName: String?){
        
        RemoveDialogueBlock()
        
        if equipmentName != nil{
            let selectedEquipment = GetEquipmentDic(by: equipmentName!)
            let text_fromPlist = selectedEquipment["Text"] as! [String:Any]
            let key = "IntroductoryDialogue"
        
            dialogueLabel.setGlyphText(text_fromPlist[key] as! String)
        }
        
        
        dialogueBlock.addChild(dialogueLabel)
        currentSKScene.addChild(dialogueBlock)
        
        let popUp       = SKEase.scale(easeFunction: .curveTypeElastic, easeType: .easeTypeInOut, time: 0.5, from: 0.05, to: 0.15)
        let wait        = SKAction.wait(forDuration: 5)
        let popDown     = SKEase.scale(easeFunction: .curveTypeElastic, easeType: .easeTypeInOut, time: 0.5, from: 0.15, to: 0.05)
        
        dialogueBlock.run(SKAction.sequence([popUp, wait, popDown]), completion: {
                            self.dialogueBlock.removeAllActions()
                            self.dialogueBlock.removeAllChildren()
                            self.dialogueBlock.removeFromParent()
        })
        
        
        
       // UpdateDialogueLabel(by: 0)
    }
    
    public func RemoveDialogueBlock(){
        if currentSKScene.contains(dialogueBlock) {
            dialogueBlock.removeAllActions()
            dialogueBlock.removeAllChildren()
            dialogueBlock.removeFromParent()
        }
    }
    
  
    
    private func SetUILayers(){
        titleIcon.zPosition         = layerManager.layer_8
        homeButton.zPosition        = layerManager.layer_9
        buyHeartButton.zPosition    = layerManager.layer_9
        
        nextPageLeftButton.zPosition    = layerManager.layer_9
        nextPageRightButton.zPosition   = layerManager.layer_9
        
        pageCountBar.zPosition          = layerManager.layer_8
        background.zPosition            = layerManager.layer_2
        dialogueBlock.zPosition         = layerManager.layer_3

    }
    
    private func AddTakeAnimation(){
        let animation = Animation()
        let take_frames = animation.GetBuiltFrames(from: "take")
        let take_anime  = animation.GetAnimatedObject(from: take_frames)
        take_anime.position.x += 65
        take_anime.position.y += 50
        take_anime.setScale(0.25)
        take_anime.zPosition = 8
        currentSKScene.addChild(take_anime)
    }
    
    private func AddMovingCloud(){
        let cloud = SKSpriteNode(imageNamed: "foodCloud")
        cloud.setScale(0.25)
        cloud.zPosition = layerManager.layer_1
        cloud.position = centerPosition
        cloud.position.y -= 100
        
        let moveLeft = SKAction.moveBy(x: -cloud.texture!.size().width, y: 0, duration: 20)
        let reset    = SKAction.moveTo(x: currentSKScene.frame.width, duration: 0)
        cloud.run(SKAction.repeatForever(SKAction.sequence([moveLeft, reset])))
        
        currentSKScene.addChild(cloud)
    }
    
    private func GetEquipmentDic(by name: String)->[String:Any]{
        
        let path = Bundle.main.path(forResource: "GameData", ofType: "plist")
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        let equipmentDict   = dict.object(forKey: "Equipments") as! [String:Any]
        
        return equipmentDict[name] as! [String:Any]
    }
    
    
}
