import Foundation
import SpriteKit

class PetCharacterDisplay: SKSpriteNode{
    
    private var currentPage: PetInfoPage!
    
    public var isUnlock          : Bool = false
    public var isCenterDisplayed : Bool = false
    
    private var petCharacterImage   : SKTexture!
    private var lockImage           : SKTexture!
    
    private var originPosition          : CGPoint!
    private var targetDisplayPosition   : CGPoint!
    

    init(defaultCharacterImage: String, petInfoPage: PetInfoPage){
        
        petCharacterImage   = SKTexture(imageNamed: defaultCharacterImage)
        currentPage         = petInfoPage
        
        super.init(texture: petCharacterImage, color: .clear, size: petCharacterImage.size())
        self.anchorPoint = CGPoint(x: 0.5,y: 0)
        
        targetDisplayPosition = CGPoint(x: currentPage.mid_X, y: currentPage.min_Y + 320)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func onClicked(at point: CGPoint){
        if self.contains(point) && !isCenterDisplayed{
            DisplayToCenterAnimation()
            isCenterDisplayed = true
        }else if self.contains(point) && isCenterDisplayed{
            MoveBackToOriginAnimation()
            isCenterDisplayed = false
        }
    }

    public func DisplayToCenterAnimation(){
        let moveToCenterAction  = SKAction.move(to: targetDisplayPosition, duration: 0.25)
        let scaleUpEasing = SKEase.scale(easeFunction: .curveTypeElastic, easeType: .easeTypeOut, time: 1, from: 0.15, to: 0.25)
        self.run(SKAction.sequence([moveToCenterAction, scaleUpEasing]))
    }
    
    public func MoveBackToOriginAnimation(){
        let moveBackToOrigin = SKAction.move(to: CGPoint(x: currentPage.min_X + 100, y: currentPage.mid_Y), duration: 0.25)
        let scaleBackEasing = SKEase.scale(easeFunction: .curveTypeElastic, easeType: .easeTypeInOut, time: 1, from: 0.25, to: 0.15)
       self.run(SKAction.sequence([moveBackToOrigin, scaleBackEasing]))
    }
}
