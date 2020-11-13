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
        
    }
    
    override func willMove(from view: SKView) {
        itemManager.tempItemHolder = nil
        equipmentManager.tempEquipmentHolder = nil
        scene?.removeAllChildren()
        
        ///Test code
        currencyManager.observers.removeAll()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        let touch       = touches.first
        let location    = touch?.location(in: self)
        
        UI_Manager.UpdateTouch(at: location!)
        
        PlaceItem(in: location!)

        petManager.UpdateTouch(at: location!)
        //Temp testing Code//
       // currencyManager.HeartCounts += 10
        /////////////////////
        
        if UI_Manager.uiState != .menuPanelOpened{
            sceneEnvironment.UpdateTouched(on: location!)
        }
        
//        let click = SKAudioNode(fileNamed: "Pen Click Sfx.wav")
//        addChild(click)
        
        
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
        smoke.position.y -= 35
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


public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}


