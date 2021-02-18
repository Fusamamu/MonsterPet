import Foundation
import SpriteKit

class EquipmentMenuScene : SKScene{
    
    public var sceneName: String = "EquipmentMenuScene"
    
    private let currencyManager : CurrencyManager   = .sharedInstance
    private let equipmentManager: EquipmentManager  = .sharedInstance
    
    private var equipUImanager: EquipmentUIManager!
    private var swipeManager: SwipeManager!
    
    var midX            : CGFloat { get { return frame.midX } }
    var midY            : CGFloat { get { return frame.midY } }
    var centerPosition  : CGPoint { get { return CGPoint(x: midX, y: midY)}}
    
    var swipeRight  : UISwipeGestureRecognizer!
    var swipeLeft   : UISwipeGestureRecognizer!
    
    var page_1: EquipmentSelectionPage!
    var page_2: EquipmentSelectionPage!
    
    var pages:[EquipmentSelectionPage] = []
    
    var currentPage: EquipmentSelectionPage!
    var currentPageIndex: Int = 0
    
    private var currentSelectedSlot     : EquipmentSlot!
    private var slotSelectionHighlight  : SKSpriteNode!
    
    private var pageCountLabel = LabelBuilder().Build(selectedLabel: .pageCountLabel)
    
    
    
    
    override func didMove(to view: SKView) {
       
        equipUImanager  = EquipmentUIManager(skScene: self)
        swipeManager    = SwipeManager(skScene: self)
        swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
        
        page_1 = EquipmentSelectionPage(pageIndex: 0, equipmentIndex: 0, skScene: self as SKScene)
        page_2 = EquipmentSelectionPage(pageIndex: 1, equipmentIndex: 4, skScene: self as SKScene)
        pages.append(contentsOf:[page_1, page_2])
        currentPage = pages[currentPageIndex]
        addChild(currentPage)
        
        AddPageCountLabel()
        
        for page in pages{
            for slot in page.slots{
                slot.equipmentInSlot.isUnlock = equipmentManager.slotUpdateUnpackState[slot.slotIndex]!
            }
        }
    }
    
    override func willMove(from view: SKView) {
        for page in pages{
            for slot in page.slots {
                if slot.equipmentInSlot != nil{
                    slot.equipmentInSlot.removeFromParent()
                }
            }
        }
        
        swipeManager.RemoveSwipeGesture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        equipUImanager.UpdateTouch(at: location!)
        
        switch equipUImanager.state {
            
            case .allClose:
                
                if currentSelectedSlot != nil{
                    if !currentSelectedSlot.contains(location!){
                        RemoveHighlight()
                        currentSelectedSlot.isSelected = false
                        currentSelectedSlot = nil
                    }else{
                        if currentSelectedSlot.isSelected{
                            let EquipDetailScene = EquipmentDetailScene(size: view!.bounds.size)
                            EquipDetailScene.scaleMode = .aspectFill
                            EquipDetailScene.currentEquipmentIndex = currentSelectedSlot.equipmentInSlot.equipmentIndex
                            view?.presentScene(EquipDetailScene)
                        }
                    }
                }
                
                for slot in currentPage.slots{
                    if slot.isLock && slot.contains(location!){
                        slot.OnClicked(at: location!)
                        equipUImanager.state = .unpackMenuOpend
                        currentSelectedSlot = slot
                        swipeManager.RemoveSwipeGesture()
                        
                    }
                    
                    if !slot.isLock && !slot.isSelected && slot.contains(location!){
                    
                        currentSelectedSlot = slot
                        currentSelectedSlot.isSelected = true
                        AddHighlight(at: currentSelectedSlot.position)
                        
//                        if !scene!.contains(equipUImanager.dialogueLabel) {
//                            equipUImanager.AddDialogueLabel()
//                        }
                        equipUImanager.AddDialogueLabel(by: currentSelectedSlot.equipmentInSlot.equipmentName.rawValue)
                    }
                }
                
                if equipUImanager.nextPageLeftButton.contains(location!){
                    equipUImanager.RemoveDialogueBlock()
                    TurnPageLeft()
                }
                if equipUImanager.nextPageRightButton.contains(location!) {
                    equipUImanager.RemoveDialogueBlock()
                    TurnPageRight()
                }
                
               
            
                
            case .unpackMenuOpend:
                guard let cancelButton = currentSelectedSlot.unpackMenuPanel.cancelButton else { return }
                guard let unpackButton = currentSelectedSlot.unpackMenuPanel.unpackButton else { return }
                           
                if cancelButton.contains(location!){

                   cancelButton.OnClicked(at: location!)

                   currentSelectedSlot.unpackMenuPanel.removeFromParent()
                   currentSelectedSlot = nil
                   
                   equipUImanager.state = .allClose
                   swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
                }
                           
                if unpackButton.contains(location!){

                    unpackButton.OnClicked(at: location!)

                    if currencyManager.HeartCounts > 50{
                        
                        currentSelectedSlot.equipmentInSlot.isUnlock = true
                        equipmentManager.slotUpdateUnpackState[currentSelectedSlot.slotIndex] = true
                    }

                    currentSelectedSlot.unpackMenuPanel.removeFromParent()
                    currentSelectedSlot = nil

                    equipUImanager.state = .allClose
                    swipeManager.AddSwipeGesture(target: self, swipeRightAction: #selector(self.swipedRight(sender:)), swipeLeftAction: #selector(self.swipedLeft(sender:)))
                }
        }
    }
    
    
    @objc func swipedRight(sender:UISwipeGestureRecognizer){
        print("swipeRight")
        TurnPageLeft()
    }
    
    @objc func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swipeLeft")
        TurnPageRight()
    }
    
    private func TurnPageRight(){
        if currentPageIndex < pages.count - 1{
            currentPage.MoveOutLeft()
            currentPageIndex += 1
            currentPage = pages[currentPageIndex]
            currentPage.position.x = 600
            addChild(currentPage)
            currentPage.MoveInLeft()
            
            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|2")
            
            run(SoundManager.sharedInstanced.Play(by: .slide))
            
        }
        else {
            print("end of page")
        }
    }
    
    private func TurnPageLeft(){
        if currentPageIndex != 0 {
            currentPage.MoveOutRight()
            currentPageIndex -= 1
            currentPage = pages[currentPageIndex]
            currentPage.position.x = -600
            addChild(currentPage)
            currentPage.MoveInRight()
            
            pageCountLabel.setGlyphText("\(String(describing: currentPageIndex + 1))|2")
            
            run(SoundManager.sharedInstanced.Play(by: .slide))

        }
        else {
            print("end of page")
        }
    }
    
    func LoadGameScene(with selectedEquip: Equipment){
        let mainScene = SceneBuilder(currentSKScene: self).Create(selectedScene: .mainScene)
        PlaceHolderManager.sharedInstance.AddArrowImages(to: mainScene)
        EquipmentManager.sharedInstance.tempEquipmentHolder = selectedEquip
        view?.presentScene(mainScene)
    }
    
    private func AddPageCountLabel(){
        pageCountLabel.position.x = frame.midX
        pageCountLabel.position.y += 30
        pageCountLabel.setGlyphText("1|2")
        addChild(pageCountLabel)
    }
    
    private func RemoveHighlight(){
        if slotSelectionHighlight != nil{
            slotSelectionHighlight.removeFromParent()
        }
    }
    
    private func AddHighlight(at point: CGPoint){
        
        slotSelectionHighlight = SKSpriteNode(imageNamed: "equipmentSelectionHighlight")

        slotSelectionHighlight.zPosition = 39
        slotSelectionHighlight.position = point
        slotSelectionHighlight.setScale(0.175)
        
        
        let scaleUp = SKAction.scale(to: 0.185, duration: 0.25)
        let scaleDown = SKAction.scale(to: 0.175, duration: 0.25)
        let loop = SKAction.sequence([scaleUp,scaleDown])
    
    
        slotSelectionHighlight.run(SKAction.repeatForever(loop))
        addChild(slotSelectionHighlight)
        
  
    }
}


