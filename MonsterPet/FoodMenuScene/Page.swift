import Foundation
import SpriteKit


class ItemSelectionPage: Page {
    
    var slots: [Slot] = []
    
    let row: Int = 2
    let column: Int = 2
    
    let slotOffset_X: CGFloat = 83
    let slotOffset_Y: CGFloat = 525
    
    let slotScale       : CGFloat = 0.15
    let slotZposition   : CGFloat = 40
    let slotPadding     : CGFloat = 5
    
    init(pageIndex: Int, itemIndex: Int, skScene: SKScene){
        super.init(index: pageIndex, skScene: skScene)
        self.GenerateSlots(from: itemIndex)
    }
    
    init(pageIndex: Int, itemIndex: Int){
        super.init(index: pageIndex)
        self.GenerateSlots(from: itemIndex)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func GenerateSlots(from index: Int){
        
        var indexCount: Int = index
        
        for y in 0...column{
            for x in 0...row{
                let slot = Slot(index: indexCount)
                let x = slotOffset_X + CGFloat(x) * slot.lockImage.size().width/slotPadding
                let y = slotOffset_Y - CGFloat(y) * slot.lockImage.size().height/slotPadding
                slot.position = CGPoint(x: x, y: y)
                slot.setScale(slotScale)
                slot.zPosition = slotZposition
                self.addChild(slot)
            
                indexCount += 1
                slots.append(slot)
            }
        }
    }
}


class Page: SKNode {
    
    var pageIndex: Int!
    var currentSKScene: SKScene!
    
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

    init(index: Int, skScene: SKScene){
        super.init()
        pageIndex = index
        currentSKScene = skScene
    }
    
    init(index: Int){
        super.init()
        pageIndex = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func MoveOutRight(){
        let movetoRight = SKAction.moveTo(x: 600, duration: 0.2)
        self.run(movetoRight, completion: { [unowned self] in self.removeFromParent()})
        
    }

    func MoveOutLeft(){
        let movetoLeft = SKAction.moveTo(x: -600, duration: 0.2)
        self.run(movetoLeft, completion: { [unowned self] in self.removeFromParent()})
    }
    
    func MoveInRight(){
        let moveInRight = SKAction.moveTo(x: 0, duration: 0.2)
        self.run(moveInRight)
    }
    
    func MoveInLeft(){
        let moveInLeft = SKAction.moveTo(x: 0, duration: 0.2)
        self.run(moveInLeft)
    }
    
}
