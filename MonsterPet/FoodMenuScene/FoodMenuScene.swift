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
    
    private var pages:[ItemSelectionPage] = []
    
    var page_1 : ItemSelectionPage!
    var page_2 : ItemSelectionPage!
    var page_3 : ItemSelectionPage!
    
    private var pageCountLabel = LabelBuilder().Build(selectedLabel: .pageCountLabel)
    
    private var currentSelectedSlot     : Slot!
    private var slotSelectionHighlight  : SKSpriteNode!
    private var slotPopUpInfo           : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.name = "FoodMenuScene is the parent"
        //itemPageManager.SetCurrentSKScene(to: self as SKScene)
        uiManager      = FoodMenuUIManager(skScene: self)
        swipeManager   = SwipeManager(skScene: self)
        swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
        

        itemPageManager.pages[currentPageIndex].position.x = 0
        itemPageManager.UpdateItemCount()
        currentPage = itemPageManager.pages[currentPageIndex]
        addChild(currentPage)
        
        pageCountLabel.position.x = uiManager.mid_X
        pageCountLabel.position.y += 30
        pageCountLabel.setGlyphText("\(String(describing: currentPageIndex))|\(String(describing: maxPageNumber))")
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
        
        RemoveHighlight_PopUpInfo()
        uiManager.dialogueLabel.setGlyphText("Could you just choose something")
        
        if currentSelectedSlot != nil && !currentSelectedSlot.contains(location!){
            currentSelectedSlot.ClickedCount = 0
        }
         

        switch uiManager.state{
            case .allClose:
                
                guard let checkedCurrentPage = currentPage else { return }
                
                for slot in checkedCurrentPage.slots{
                    if slot.isLock && slot.contains(location!){
                        
                        
                        if slot.unpackMenuPanel == nil{
                            slot.unpackMenuPanel = UnpackPanel(index: slot.slotIndex, skScene: self as SKScene)
                            slot.SubscribeButton(target: slot.unpackMenuPanel)
                            slot.SubscribeButton(target: slot.unpackMenuPanel.alphaBlackPanel)
                        }
                        
                        slot.OnClicked(at: location!)
                        
                        uiManager.state = .unpackMenuOpend
                        currentSelectedSlot = slot
                        swipeManager.RemoveSwipeGesture()
                    }
                    
                  
                    
                    if !slot.isLock && !slot.isSelected &&  slot.contains(location!) {
                        
                        AddHighlight_PopUpInfo(at: slot.position)
                       
                        if currentSelectedSlot == nil {
                            currentSelectedSlot = slot
                            currentSelectedSlot.ClickedCount += 1
                        }else if currentSelectedSlot != nil && currentSelectedSlot == slot{
                            currentSelectedSlot.ClickedCount += 1
                            currentSelectedSlot.isSelected = true
                        }else if currentSelectedSlot != nil && currentSelectedSlot != slot{
                            currentSelectedSlot.isSelected = false
                            currentSelectedSlot.ClickedCount = 0
                            currentSelectedSlot = nil
                            
                            currentSelectedSlot = slot
                            currentSelectedSlot.ClickedCount += 1
                        }
                        
                        
                        //Update Dialogue Box by Plist here
                        uiManager.UpdateDialogueLabel(by: currentSelectedSlot.itemInSlot.itemIndex)
                    }
                    
                 
                    if !slot.isLock && slot.isSelected && slot.ClickedCount == 2 && slot.contains(location!) {
                        
                            slot.ClickedCount = 0
                            slot.isSelected = false
                            
                            let itemDetailScene = DetailScene(size: view!.bounds.size)
                            itemDetailScene.scaleMode = .aspectFill
                            itemDetailScene.currentItemIndex = slot.itemInSlot.itemIndex
                            
                            itemDetailScene.itemCountLabel.text = String(ItemManager.sharedInstance.TempCount)
                            view?.presentScene(itemDetailScene)
                    }
                }
            
            case .unpackMenuOpend:

                guard let cancelButton = currentSelectedSlot.unpackMenuPanel.cancelButton else { return }
                guard let unpackButton = currentSelectedSlot.unpackMenuPanel.unpackButton else { return }
            
                if cancelButton.contains(location!){
     
                    cancelButton.OnClicked(at: location!)

                    currentSelectedSlot.unpackMenuPanel.removeFromParent()
                    currentSelectedSlot = nil
                    
                    uiManager.state = .allClose
                    swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
                }
            
                if unpackButton.contains(location!){
           
                    unpackButton.OnClicked(at: location!)

                    if currencyManager.HeartCounts > 50{
                        currentSelectedSlot.itemInSlot.isUnlock = true
                        itemManager.slotUpdateUnpackState[currentSelectedSlot.slotIndex] = true
                    }
                    
                    currentSelectedSlot.unpackMenuPanel.removeFromParent()
                    currentSelectedSlot = nil
                    
                    uiManager.state = .allClose
                    swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
                }
        }
    }
    
    
    
    @objc func swipedRight(sender:UISwipeGestureRecognizer){
        print("swipeRight")
        if currentPageIndex != 0 {
            currentPage.MoveOutRight()
            currentPage = nil
            currentPageIndex -= 1
            currentPage = itemPageManager.pages[currentPageIndex]
            currentPage.position.x = -600
            addChild(currentPage)
            currentPage.MoveInRight()
            
            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|\(String(describing: maxPageNumber))")
        }
        else {
            print("end of page")
        }
    }
    
    ///<-----////
    
    @objc func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swipeLeft")
        if currentPageIndex < 2{
            
            currentPage.MoveOutLeft()
            currentPage = nil
            
            currentPageIndex += 1
            currentPage = itemPageManager.pages[currentPageIndex]
            currentPage.position.x = 600
            addChild(currentPage)
            currentPage.MoveInLeft()
            
            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|\(String(describing: maxPageNumber))")
        }
        else {
            print("end of page")
        }
    }
    
    func Update() {
        //currentPage.slots[0].isLock = false
        //currentPage.slots[0].UpdateLockStatus()
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
        slotPopUpInfo.removeFromParent()
    }
    
    func AddHighlight_PopUpInfo(at point: CGPoint){
        
        let scaleUp = SKAction.scale(to: 0.15, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.1, duration: 0.5)
        let loop = SKAction.sequence([scaleUp,scaleDown])
        
        
        slotSelectionHighlight.zPosition = 39
        slotSelectionHighlight.position = point
        slotSelectionHighlight.setScale(0.1)
        slotSelectionHighlight.run(SKAction.repeatForever(loop))
        addChild(slotSelectionHighlight)
        
        slotPopUpInfo.zPosition = 60
        slotPopUpInfo.setScale(0.15)
        slotPopUpInfo.position = point
        slotPopUpInfo.position.x += 5
        slotPopUpInfo.position.y -= 80
        addChild(slotPopUpInfo)
    }
    

}
