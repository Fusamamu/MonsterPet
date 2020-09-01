import Foundation
import SpriteKit

class SwipeManager{
    
    var currentSKScene: SKScene!
    
    var swipeRight  : UISwipeGestureRecognizer!
    var swipeLeft   : UISwipeGestureRecognizer!
    
    init(skScene: SKScene) {
        currentSKScene = skScene
    }
    
    func AddSwipeGesture(target: Any?, swipeRightAction: Selector?, swipeLeftAction: Selector?){
        swipeRight = UISwipeGestureRecognizer(target: target, action: swipeRightAction)
        swipeRight.direction = .right
        currentSKScene.view!.addGestureRecognizer(swipeRight)
        
        swipeLeft = UISwipeGestureRecognizer(target: target, action: swipeLeftAction)
        swipeLeft.direction = .left
        currentSKScene.view!.addGestureRecognizer(swipeLeft)
    }
    
    func RemoveSwipeGesture(){
        currentSKScene.view!.removeGestureRecognizer(swipeLeft)
        currentSKScene.view!.removeGestureRecognizer(swipeRight)
    }
}
