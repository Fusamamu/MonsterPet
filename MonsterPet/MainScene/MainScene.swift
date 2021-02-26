import Foundation
import SpriteKit
import UIKit
import GoogleMobileAds
import AVKit

class MainScene: SKScene, GADRewardedAdDelegate {
    
    let timeManager         : TimerManager          = .sharedInstance
    let currencyManager     : CurrencyManager       = .sharedInstance
    
    let CORE_MG             : CoreObjectManager     = .sharedInstance
    
    let itemManager         : ItemManager           = .sharedInstance
    let equipmentManager    : EquipmentManager      = .sharedInstance
    let petManager          : PetManager            = .sharedInstance
    let packageManager      : PackageManager        = .sharedInstance
    let placeHolderManager  : PlaceHolderManager    = .sharedInstance
    
    var UI_Manager      : MainSceneUIManager!
    var labelManager    : LabelManager!
    
    var sceneEnvironment: SceneEnvironment!
    
//    var SortedObjects: [SKSpriteNode] = []
    var rewardedAd: GADRewardedAd!
    
    var player: AVAudioPlayer!
    override func didMove(to view: SKView) {
        
        //LoadUnpack State//
        InventoryDataManager.sharedInstance.LoadUnpackState()
        
        LoadGameEnvironment()

        UI_Manager      = MainSceneUIManager     (skScene: self)
        labelManager    = LabelManager  (skScene: self)

        itemManager.SetCurrentScene(to: self)
        itemManager.LoadObjectData(pointData: placeHolderManager.pointData)

        equipmentManager.SetCurrentScene(to: self)
        equipmentManager.LoadObjectData(pointData: placeHolderManager.pointData)

        petManager.SetCurrentScene(gameScene: self)
        packageManager.SetCurrentScene(gameScene: self)
        
        //PetSaveDataManager.sharedInstance.LoadPetInScene()

        petManager.LoadPetData()
        petManager.LoadHeartInScene()
        packageManager.LoadPackageInScene()
        

        currencyManager.AddObserver(observer: labelManager)

        sceneEnvironment = SceneEnvironment(skScene: self)

        let textAnimation = TextAnimation(skScene: self)
        currencyManager.AddObserver(observer: textAnimation)
        
        //let dictToSend: [String: String] = ["fileToPlay" : "bensound-ukulele" ]
        //  NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo: dictToSend)

        
//        let text = BMGlyphLabel(txt: "TEST", fnt: BMGlyphFont(name: "TitleText"))
//        text.position = CGPoint(x: frame.midX, y: frame.midY)
//        text.zPosition  = 200
//        addChild(text)

//        for tree in sceneEnvironment.allTrees{
//            RefreshManager.shared.loadDataIfNeeded(){
//                success in tree.ResetCoin(isNeeded: success)
//            }

        
//        let function: (Bool)->Void = {
//            success in if success{
//                for i in 0...8{
//                    CoinCollectedCount.sharedInstance.collectedCount_s[i] = 0
//                }
//            }
//        }
        
     //   RefreshManager.shared.loadDataIfNeeded(completion: function)
        RefreshManager.shared.loadDataIfNeeded(){
            success in if success{
                for i in 0...8{
                    CoinCollectedCount.sharedInstance.collectedCount_s[i] = 0
                }
            }
        }
        
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        
        rewardedAd.load(GADRequest()){
            error in if let error = error{
                print("success ad loaded")
            }else{
                print("failed")
            }
        }
        
    }
    
    override func willMove(from view: SKView) {
        itemManager.tempItemHolder = nil
        equipmentManager.tempEquipmentHolder = nil
        scene?.removeAllChildren()
        
        //Test code
        currencyManager.observers.removeAll()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Display AD!!//
//        guard let controller = self.view?.window?.rootViewController as? GameViewController else {return}
//        if rewardedAd?.isReady == true {
//            rewardedAd?.present(fromRootViewController: controller, delegate: self)
//
//        }

        let touch       = touches.first
        let location    = touch?.location(in: self)
        
        UI_Manager.UpdateTouch(at: location!)
        
        CORE_MG.UpdateTouch(at: location!)
        //petManager.UpdateTouch(at: location!)
        //packageManager.UpdateTouch(at: location!)

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
                        equipment.position = arrow!.position
                        equipment.zPosition = 3
                        equipment.setScale(0.1)
                        equipment.timeWhenPlaced = Date.timeIntervalSinceReferenceDate
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
            CORE_MG.ScanObjects(at: Date.timeIntervalSinceReferenceDate)
            
//            petManager.ScanPets(at: Date.timeIntervalSinceReferenceDate)
//            petManager.ScanItems(at: Date.timeIntervalSinceReferenceDate)
        }
    }
    
    public func SortObjectsLayerAfterAdded(){
        var SortedObjs: [SKSpriteNode] = []
        
        for obj in scene!.children{
            if obj is Tree || obj is Pet || obj is Equipment || obj is Item || obj is Package{
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
    
    // Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    // Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }
    // Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad dismissed.")
    }
    // Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
}


