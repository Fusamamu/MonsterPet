import Foundation
import SpriteKit
import UIKit


class MainScene: SKScene {
    
    let timeManager         : TimerManager           = .sharedInstance
    let itemManager         : ItemManager           = .sharedInstance
    let equipmentManager    : EquipmentManager      = .sharedInstance
    let petManager          : PetManager            = .sharedInstance
    let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    let currencyManager     : CurrencyManager       = .sharedInstance
    
    var UI_Manager      : MainSceneUIManager!
    var labelManager    : LabelManager!
    
    var sceneEnvironment: SceneEnvironment!
    
//    var SortedObjects: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        
        LoadGameEnvironment()

        UI_Manager      = MainSceneUIManager     (skScene: self)
        labelManager   = LabelManager  (skScene: self)

        itemManager.SetCurrentScene(to: self)
        itemManager.LoadObjectData(pointData: placeHolderManager.pointData)

        equipmentManager.SetCurrentScene(to: self)
        equipmentManager.LoadObjectData(pointData: placeHolderManager.pointData)

        petManager.SetCurrentScene(gameScene: self)
        petManager.LoadPetData()

        currencyManager.AddObserver(observer: labelManager)



        sceneEnvironment = SceneEnvironment(skScene: self)

        let textAnimation = TextAnimation(skScene: self)
        currencyManager.AddObserver(observer: textAnimation)
        
//        let bgMusic = SKAudioNode(fileNamed: "bensound-ukulele.mp3")
//        bgMusic.run(SKAction.changeVolume(to: 0.2, duration: 0))
//        addChild(bgMusic)
        
   

        
//        let text = BMGlyphLabel(txt: "TEST", fnt: BMGlyphFont(name: "TitleText"))
//        text.position = CGPoint(x: frame.midX, y: frame.midY)
//        text.zPosition  = 200
//        addChild(text)
//        
//        let modelName = UIDevice.modelName
//        if modelName == "Simulator iPhone 8"{
//            text.setGlyphText("This is iPhone 8")
//        }
//        
//        if modelName == "Simulator iPhone 11 Pro Max"{
//            text.setGlyphText("This is iPhone 11 Pro Max")
//        }
//        
//        if modelName == "Simulator iPhone 12 Pro Max"{
//            text.setGlyphText("This is iPhone 12 Pro Max")
//        }
        
        
//        for tree in sceneEnvironment.allTrees{
//            RefreshManager.shared.loadDataIfNeeded(){
//                success in tree.ResetCoin(isNeeded: success)
//            }
//
        
    }
    
    override func willMove(from view: SKView) {
        itemManager.tempItemHolder = nil
        equipmentManager.tempEquipmentHolder = nil
        scene?.removeAllChildren()
        
        ///Test code
        currencyManager.observers.removeAll()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //        let click = SKAudioNode(fileNamed: "Pen Click Sfx.wav")
        //        addChild(click)

        let touch       = touches.first
        let location    = touch?.location(in: self)
        
        UI_Manager.UpdateTouch(at: location!)
        
        petManager.UpdateTouch(at: location!)

        if UI_Manager.uiState != .menuPanelOpened{
            sceneEnvironment.UpdateTouched(on: location!)
        }
        
        
        PlaceItem(in: location!)
        
        if UI_Manager.uiState == .menuPanelOpened{
            placeHolderManager.RemoveAllArrow()
        }
        
    }
    
    func PlaceItem(in location: CGPoint){

        if placeHolderManager.arrowIsAdded{
            for arrow in placeHolderManager.arrowImages{
                if arrow != nil && arrow!.contains(location){
                    
                    placeHolderManager.RemoveAllArrow()
                    
                    if itemManager.tempItemHolder != nil{
                        let item = itemManager.tempItemHolder!
                        
                        item.position = arrow!.position
                        item.zPosition = 3
                        item.setScale(0.1)
                        item.timeWhenPlaced = Date.timeIntervalSinceReferenceDate
                        addChild(item)
                        itemManager.StoreObjectData(item: item, at: arrow!.position)
                        
                        let updatedItemCount = itemManager.itemCountInventory[item.itemName]! - 1
                        itemManager.itemCountInventory[item.itemName] = updatedItemCount
                        
                        animateSmoke(at: item.position)
                        
                    }
                    
                    if equipmentManager.tempEquipmentHolder != nil{
                        
                        let equipment = EquipmentManager.sharedInstance.tempEquipmentHolder!
                        equipment.setScale(0.1)
                        equipment.zPosition = 3
                        equipment.position = arrow!.position
                        addChild(equipment)
                        
                        equipmentManager.StoreEquipmentData(equipment: equipment, at: arrow!.position)
                    }
                    
                    SortObjectsLayerAfterAdded()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        timeManager.UpdateTimer(countTarget: 100)
        
       
        
        if timeManager.timePassed(Target: 100){
            petManager.ScanItems(at: Date.timeIntervalSinceReferenceDate)
            petManager.ScanPets(at: Date.timeIntervalSinceReferenceDate)
        }
    }
    
    
    public func SortObjectsLayerAfterAdded(){
        var SortedObjs: [SKSpriteNode] = []
        
        for obj in scene!.children{
            if obj is Tree || obj is Pet || obj is Equipment{
                SortedObjs.append(obj as! SKSpriteNode)
            }
        }
        
        SortedObjs = SortedObjs.sorted(by: { $0.position.y > $1.position.y })
    
        for i in 0...SortedObjs.count - 1{
            SortedObjs[i].zPosition = CGFloat(i) + 1
        }
    }

    
    func LoadGameEnvironment(){
        
      
        //LoadCloud()
//        let mainBackground = SKSpriteNode(imageNamed: "MainBackground")
//        mainBackground.position = CGPoint(x: frame.midX, y: frame.midY)
//        mainBackground.zPosition = 0
//        mainBackground.setScale(0.47)
//        addChild(mainBackground)
        
        


        
    }
    
    
    private func LoadCloud(){
        
        let cloud = SKSpriteNode(imageNamed: "cloud")
        cloud.zPosition = 3
        cloud.alpha = 0.35
        cloud.position = CGPoint(x: cloud.texture!.size().width, y: 0)
        addChild(cloud)
        
        
        
        let moveLeft = SKAction.moveTo(x: -cloud.texture!.size().width, duration: 10)
        let moveUp = SKAction.moveTo(y: cloud.texture!.size().height, duration: 0.1)
        let moveToBack = SKAction.moveTo(x: cloud.texture!.size().width, duration: 0.1)
        let moveDown = SKAction.moveTo(y: 0, duration: 0.1)
        
        let moveLoop = SKAction.sequence([moveLeft, moveUp, moveToBack, moveDown])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        cloud.run(moveForever)
        
    }
    
    
    func animateSmoke(at position: CGPoint){
        
        let smokeAtlas = SKTextureAtlas(named: "Smoke")
        var smokeFrames: [SKTexture] = []
        
        let numberImages = smokeAtlas.textureNames.count
        
        for i in 1...numberImages{
            let smokeTextureName = "smoke\(i)"
            smokeFrames.append(smokeAtlas.textureNamed(smokeTextureName))
        }
        
        let smoke = SKSpriteNode(texture: smokeFrames[0])
        smoke.setScale(0.15)
        smoke.zPosition = 2
        smoke.position = position
        smoke.position.y -= 20
        addChild(smoke)
        
        let smokeAnimate = SKAction.animate(with: smokeFrames, timePerFrame: 0.1, resize: false, restore: true)
    
        
        smoke.run(SKAction.repeat(smokeAnimate, count: 1), completion: { smoke.removeFromParent() })
        
        
    }
    
    private func animateGotItAffect(at position: CGPoint){
        let frames = Animation().GetBuiltFrames(from: "gotItAffect")
        
        let affect = SKSpriteNode(texture: frames[0])
        affect.setScale(0.2)
        affect.zPosition = 200
        affect.position = position
        addChild(affect)
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.5, resize: false, restore: true)
        
        affect.run(SKAction.repeat(animation, count: 100), completion: { affect.removeFromParent()})
    }
    
    
    private func PopUpCoin(at position: CGPoint){
        let node = Animation().GetAnimatedObject(by: .coin)
        
        node.zPosition = 200
        node.setScale(0.08)
        node.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        addChild(node)
        
        let popUpHeight: CGFloat = 150
        
        let up = SKEase.move(easeFunction: .curveTypeExpo, easeType: .easeTypeOut, time: 0.5, from: position, to: CGPoint(x: position.x, y: position.y + popUpHeight))
        let down = SKEase.move(easeFunction: .curveTypeExpo, easeType: .easeTypeIn, time: 0.5, from: CGPoint(x: position.x, y: position.y + popUpHeight), to: position)

        let wait    = SKAction.wait(forDuration: 0.7)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)

        let upNDown = SKAction.sequence([up, down])
        let waitNFadeOut = SKAction.sequence([wait, fadeOut])
        
        let popUpAnimation = SKAction.group([upNDown, waitNFadeOut])
        node.run(popUpAnimation, completion: {node.removeFromParent()})
    }
    
    
}


