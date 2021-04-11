import Foundation
import SpriteKit

class PetInfoSlot: SKSpriteNode, Observer{
    
    var id: Int = 0;
    
    public var slotDelegates: [ButtonDelegate]?
    
    public var isLock      : Bool  = true
    public var isTouchable : Bool  = true
    
    public var slotIndex : Int!
    public var loadedPet : Pet!

    private(set) var slotImage   : SKTexture!
    private(set) var lockImage   : SKTexture!
    
    private var slotScale: CGFloat = 0.18
    
    private var petImage        : SKSpriteNode!
    
    private var petName         : BMGlyphLabel!
    private var petVisitedCount : BMGlyphLabel!
    private var petGift         : BMGlyphLabel!
    
    private var petFavoriteFoodLabels : [BMGlyphLabel] = []
    
    init(index: Int){
        slotIndex = index
        slotImage = SKTexture(imageNamed: "petInfoSlot")
        lockImage = SKTexture(imageNamed: "default")
        super.init(texture: slotImage, color: .clear, size: slotImage.size())
        self.setScale(slotScale)
        self.zPosition = 40
        
        loadedPet = PetManager.sharedInstance.petInStore[PetName.allCases[index]]!
        loadedPet.AddObserver(observer: self)
        
        SetPetDisplayImage(by: index)
        InitializeDataInfo(by: index)
        //SetPetDataInfo(by: index)
        
        var petBaseName: String?
        
        if index == 0{
            petBaseName = "petBaseRed"
        }
        if index == 1{
            petBaseName = "petBaseYellow"
        }
        if index == 2{
            petBaseName = "petBaseGreen"
        }
        
        let petBase = SKSpriteNode(imageNamed: "petBaseYellow")
        petBase.zPosition = 19
        petBase.setScale(0.43)
        petBase.position = petImage.position
        petBase.position.y -= 250
        self.addChild(petBase)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetPetDisplayImage(by index: Int){
        
        petImage = SKSpriteNode(imageNamed: loadedPet!.petName.rawValue + "InfoDisplayLocked")
        petImage.zPosition = 20
        petImage.setScale(0.9)
        petImage.position.x -= 1000
        self.addChild(petImage)
    }
    
    func InitializeDataInfo(by index: Int){
        
        let _name           = "...?"
        let _visitedCount   = "?"
        let _gift           = "?"
        
        //petName = BMGlyphLabel(txt: loadedPet.petName.rawValue, fnt: BMGlyphFont(name: "TitleText"))
        petName = BMGlyphLabel(txt: _name, fnt: BMGlyphFont(name: "TitleText"))
        petName.zPosition = 21
        petName.setScale(3)
        petName.position.x += 250
        petName.position.y += 355
        self.addChild(petName)
        
        //petVisitedCount = BMGlyphLabel(txt: String(loadedPet.VisitedTime), fnt: BMGlyphFont(name: "TitleText"))
        petVisitedCount = BMGlyphLabel(txt: _visitedCount, fnt: BMGlyphFont(name: "TitleText"))
        petVisitedCount.zPosition = 21
        petVisitedCount.setScale(3)
        petVisitedCount.position = petName.position
        petVisitedCount.position.y -= 120
        self.addChild(petVisitedCount)
        
        //petGift = BMGlyphLabel(txt: "???", fnt: BMGlyphFont(name: "TitleText"))
        petGift = BMGlyphLabel(txt: _gift, fnt: BMGlyphFont(name: "TitleText"))
        petGift.zPosition = 21
        petGift.setScale(3)
        petGift.position = petVisitedCount.position
        petGift.position.y -= 120
        self.addChild(petGift)
        
        for i in 0...2{
            let petFavoriteFoodLabel = BMGlyphLabel(txt: "?", fnt: BMGlyphFont(name: "TitleText"))
            petFavoriteFoodLabel.zPosition = 21
            petFavoriteFoodLabel.setScale(2.5)
            petFavoriteFoodLabel.position.y = petGift.position.y - 320
            petFavoriteFoodLabel.position.x = CGFloat(i) * 300 - 300
            petFavoriteFoodLabels.append(petFavoriteFoodLabel)
            addChild(petFavoriteFoodLabel)
        }
    }
    
    func SetPetDataInfo(by index: Int){
        //Set after pet has visited
        let _name = "...?"
        let _visitedCount = "?"
        let _gift = "?"
        petName.setGlyphText(_name)
        petVisitedCount.setGlyphText(_visitedCount)
        petGift.setGlyphText(_gift)
    }
    
    func Update() {
        if loadedPet.hasVisited {
            petImage.texture = SKTexture(imageNamed: loadedPet.petName.rawValue + "InfoDisplay" )
            
            petVisitedCount.setGlyphText(String(loadedPet.VisitedTime))
        }
    }
}
