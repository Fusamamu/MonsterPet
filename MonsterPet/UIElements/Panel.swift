import Foundation
import SpriteKit

class MainMenuPanel: Panel {
    
    public var closeButton: Button!
    
    override func AddButtons(){
        closeButton = Button(DefaultImage: "CloseButton", PressedImage: "Button", skScene: currentSKscene)
        closeButton.setScale(1.35)
        closeButton.zPosition = 10
        closeButton.position = CGPoint(x: 750, y: 700)
        closeButton.SubscribeButton(target: self)
        self.addChild(closeButton)
    }
    
    override func RemoveAllButtonReferences(){
        closeButton.removeFromParent()
        closeButton = nil
    }
}

class Panel: SKSpriteNode, ButtonDelegate {
    
    public var sender: Button!
    
    public  var isOpened        : Bool!
    public  var currentSKscene  : SKScene!
    private var panelTexture    : SKTexture!
    
    init(panelImage: String, skScene: SKScene){
        isOpened = false
        currentSKscene = skScene
        panelTexture = SKTexture(imageNamed: panelImage)
        super.init(texture: panelTexture, color: .clear, size: panelTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Invoked() {
        isOpened ? Close(): Open()
    }
    
    func Open(){
        self.position = CGPoint(x: currentSKscene.frame.midX, y: currentSKscene.frame.midY)
        
        currentSKscene.addChild(self)
        isOpened = true
        AddButtons()
        AddLabels()
        AddImages()
        
        UpdateLabels()
        UpdateImages()
    }
    
    func Close(){
        self.removeFromParent()
        isOpened = false
        RemoveAllButtonReferences()
    }
    
    func AddButtons(){
    }
    
    func AddLabels(){
    }
    
    func AddImages(){
    }
    
    func UpdateLabels(){
    }
    
    func UpdateImages(){
    }
    
    func RemoveAllButtonReferences(){
    }
}




