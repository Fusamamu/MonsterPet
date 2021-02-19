import Foundation
import SpriteKit
//import UIKit
import GameplayKit

class FoodMenuScene: SKScene, Observer{
    
    public var sceneName: String = "FoodMenuScene"
    
    private let currencyManager : CurrencyManager   = .sharedInstance
    private let itemManager     : ItemManager       = .sharedInstance
    private let itemPageManager : ItemPageManager   = .sharedInstance
    
    private var uiManager: FoodMenuUIManager!
    private var swipeManager: SwipeManager!
  
    
    var id: Int = 0
    let maxPageNumber: Int = 3
    
    unowned var currentPage: ItemSelectionPage!
    var currentPageIndex: Int = 0
    
   // private var pages:[ItemSelectionPage] = []
    

    private var pageCountLabel = LabelBuilder().Build(selectedLabel: .pageCountLabel)
    
    private var currentSelectedSlot     : Slot!
    private var slotSelectionHighlight  : SKSpriteNode!
    private var slotPopUpInfo           : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        currentSelectedSlot = nil
        self.name = "FoodMenuScene is the parent"
        //itemPageManager.SetCurrentSKScene(to: self as SKScene)
        uiManager      = FoodMenuUIManager(skScene: self)
        swipeManager   = SwipeManager(skScene: self)
        swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
        
        //reset page to index 0, positionx = 0
        itemPageManager.pages[currentPageIndex].position.x = 0
        itemPageManager.UpdateItemCount()
        currentPage = itemPageManager.pages[currentPageIndex]
        addChild(currentPage)
        
        //Load Slot Unpack State from SaveData//
        for page in itemPageManager.pages {
            for slot in page.slots{
                slot.itemInSlot.isUnlock = itemManager.slotUpdateUnpackState[slot.itemInSlot.itemIndex]!
            }
        }
        
        
        pageCountLabel.position.x = uiManager.mid_X
        pageCountLabel.position.y += 30
        //pageCountLabel.setGlyphText("\(String(describing: currentPageIndex))|\(String(describing: maxPageNumber))")
        pageCountLabel.setGlyphText("1|\(String(describing: maxPageNumber))")
        addChild(pageCountLabel)
        
        slotSelectionHighlight = SKSpriteNode(imageNamed: "SelectionHighlight")
        slotPopUpInfo = SKSpriteNode(imageNamed:"popUpInfo")
        
        self.backgroundColor = UIColor(red: 178/255, green: 176/255, blue: 122/255, alpha: 1)
        
                                        
    }
    
    override func willMove(from view: SKView) {
        currentPage.removeFromParent()
        itemPageManager.pages[currentPage.pageIndex].removeFromParent()
        currentPage = nil
        swipeManager.RemoveSwipeGesture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch       = touches.first
        let location    = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
        uiManager.dialogueLabel.setGlyphText("Could you just choose something")
    
        switch uiManager.state{
            case .allClose:
                if currentSelectedSlot != nil {
                    if !currentSelectedSlot.contains(location!){
                        RemoveHighlight_PopUpInfo()
                        currentSelectedSlot.isSelected = false
                        currentSelectedSlot = nil
                    }
                    else{
                        if currentSelectedSlot.isSelected{
                            
                            currentSelectedSlot.isSelected = false
                            
                            let itemDetailScene = DetailScene(size: view!.bounds.size)
                            itemDetailScene.scaleMode = .aspectFill
                            itemDetailScene.currentItemIndex = currentSelectedSlot.itemInSlot.itemIndex
                            
                            
                            view?.presentScene(itemDetailScene)
                        }
                    }
                }
                
                guard let checkedCurrentPage = currentPage else { return }
                
                for slot in checkedCurrentPage.slots{
                    if slot.isLock && slot.contains(location!){


                        slot.unpackMenuPanel = UnpackPanel(index: slot.slotIndex, skScene: self as SKScene)
                        slot.UnsubscribeButton()
                        slot.SubscribeButton(target: slot.unpackMenuPanel)
                        slot.SubscribeButton(target: slot.unpackMenuPanel.alphaBlackPanel)

                        
                        
                        
                        slot.OnClicked(at: location!)

                        currentSelectedSlot = slot
                        
                        uiManager.state = .unpackMenuOpend
                        swipeManager.RemoveSwipeGesture()
                    }
                    
                    if !slot.isLock && !slot.isSelected && slot.contains(location!){
                        currentSelectedSlot = slot
                        currentSelectedSlot.isSelected = true
                        AddHighlight_PopUpInfo(at: currentSelectedSlot.position)
                        //Update Dialogue Box by Plist here
                        uiManager.UpdateDialogueLabel(by: currentSelectedSlot.itemInSlot.itemIndex)
                    }

                }
                
                if uiManager.nextPageLeftButton.contains(location!){
                    TurnPageLeft()
                }
                if uiManager.nextPageRightButton.contains(location!){
                    TurnPageRight()
                }
                
            
            case .unpackMenuOpend:

                guard let cancelButton = currentSelectedSlot.unpackMenuPanel.cancelButton else { return }
                guard let unpackButton = currentSelectedSlot.unpackMenuPanel.unpackButton else { return }
            
                if cancelButton.contains(location!){
     
                    cancelButton.OnClicked(at: location!)

                   // currentSelectedSlot.unpackMenuPanel.removeFromParent()
                    
                   // currentSelectedSlot.isSelected = false
                    currentSelectedSlot = nil
                    
                    uiManager.state = .allClose
                    swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
                }
            
                if unpackButton.contains(location!){
           
                    unpackButton.OnClicked(at: location!)

                    if currencyManager.HeartCounts > 50{
                        currentSelectedSlot.isLock = false
                        currentSelectedSlot.itemInSlot.isUnlock = true
                        itemManager.slotUpdateUnpackState[currentSelectedSlot.slotIndex] = true
                    }
                    
                    currentSelectedSlot.unpackMenuPanel.removeFromParent()
                    currentSelectedSlot.isSelected = false
                    currentSelectedSlot = nil
                    
                    uiManager.state = .allClose
                    swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
                }
        }
    }
    
    
    
    @objc func swipedRight(sender:UISwipeGestureRecognizer){
        print("swipeRight")
        TurnPageLeft()
    }
    
    ///<-----////
    
    @objc func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swipeLeft")
        TurnPageRight()
    }
    
    private func TurnPageLeft(){
        if currentPageIndex != 0 {
            currentPage.MoveOutRight()
            currentPage = nil
            currentPageIndex -= 1
            currentPage = itemPageManager.pages[currentPageIndex]
            currentPage.position.x = -600
            addChild(currentPage)
            currentPage.MoveInRight()
            
            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|\(String(describing: maxPageNumber))")
            
            run(SoundManager.sharedInstanced.Play(by: .slide))
        }
        else {
            print("end of page")
        }
    }
    
    private func TurnPageRight(){
        if currentPageIndex < 2{
            
            currentPage.MoveOutLeft()
            currentPage = nil
            
            currentPageIndex += 1
            currentPage = itemPageManager.pages[currentPageIndex]
            currentPage.position.x = 600
            addChild(currentPage)
            currentPage.MoveInLeft()
            
            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|\(String(describing: maxPageNumber))")
            
            run(SoundManager.sharedInstanced.Play(by: .slide))
        }
        else {
            print("end of page")
        }
    }
    
    func Update() {
       
    }
    
    private func MakeSlotsTouchable(){
        for slot in currentPage.slots{
            slot.isTouchable = true
        }
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func RemoveHighlight_PopUpInfo(){
        slotSelectionHighlight.removeFromParent()
        //slotPopUpInfo.removeFromParent()
    }
    
    func AddHighlight_PopUpInfo(at point: CGPoint){
        
        let scaleUp = SKAction.scale(to: 0.13, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.1, duration: 0.5)
        let loop = SKAction.sequence([scaleUp,scaleDown])
        
        slotSelectionHighlight.zPosition = 39
        slotSelectionHighlight.position = point
        slotSelectionHighlight.setScale(0.1)
        slotSelectionHighlight.run(SKAction.repeatForever(loop))
        addChild(slotSelectionHighlight)
        
    }
    

}
