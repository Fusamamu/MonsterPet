import Foundation
import SpriteKit

class BaseUIManager{
    
    var currentSKScene: SKScene!
    
    private(set) var defaultUi_Scale      : CGFloat = 0.18
    private(set) var defaultUi_Zposition  : CGFloat = 20
    
    
    private(set) var buttonScale        : CGFloat = 0.18
    private(set) var buttonZPosition    : CGFloat = 20
    
    
    var min_X: CGFloat { get { return currentSKScene.frame.minX } }
    var min_Y: CGFloat { get { return currentSKScene.frame.minY } }
    var mid_X: CGFloat { get { return currentSKScene.frame.midX } }
    var mid_Y: CGFloat { get { return currentSKScene.frame.midY } }
    var max_X: CGFloat { get { return currentSKScene.frame.maxX } }
    var max_Y: CGFloat { get { return currentSKScene.frame.maxY } }
    
    var centerPosition      : CGPoint { get { return CGPoint(x: mid_X, y: mid_Y)}}
    var upperRightPosition  : CGPoint { get { return CGPoint(x: max_X, y: max_Y)}}
    var upperLeftPosition   : CGPoint { get { return CGPoint(x: min_X, y: max_Y)}}
    var lowerLeftPosition   : CGPoint { get { return CGPoint(x: min_X, y: min_Y)}}
    var lowerRightPosition  : CGPoint { get { return CGPoint(x: max_X, y: min_Y)}}
    
    
    let padding: CGFloat = 50
    
    
    init(skScene: SKScene) {
        currentSKScene = skScene
    }
    
}


