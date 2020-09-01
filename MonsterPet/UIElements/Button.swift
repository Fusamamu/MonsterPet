import Foundation
import SpriteKit

protocol ButtonDelegate {
    
    var isOpened: Bool! { get set }
    var sender: Button! { get set }
    func Invoked()
    func Open()
    func Close()
    
}


class Button: SKSpriteNode{
    
    var currentSKscene: SKScene!

    var buttonDelegates: [ButtonDelegate]?
    var defaultTexture: SKTexture!
    var pressedTexture: SKTexture!
    
    var paddle: CGFloat = 20
    
    var index       : Int       = 0
    var itemName    : String    = "Unsigned"
    var isSeleted   : Bool      = false
    
    init(DefaultImage: String){

        buttonDelegates = []
        defaultTexture = SKTexture(imageNamed: DefaultImage)
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())
    }
    
    init(DefaultImage: String, PressedImage: String, skScene: SKScene){

        buttonDelegates = []
        defaultTexture = SKTexture(imageNamed: DefaultImage)
        pressedTexture = SKTexture(imageNamed: PressedImage)
        currentSKscene = skScene
        
        super.init(texture: defaultTexture, color: .clear, size: defaultTexture.size())

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SubscribeButton(target: ButtonDelegate){
         buttonDelegates?.append(target)
    }
    
    func SubscribeButton(sender: Button, target: ButtonDelegate){
        buttonDelegates?.append(target)
     
    }
    
    func UnsubscribeButton(){
        buttonDelegates?.removeAll()
    }
    
    func OnClicked(at location: CGPoint){
        
        if self.contains(location){
            for delegate in buttonDelegates!{
                    delegate.Invoked()
            }
        }
        
    }
    
}
