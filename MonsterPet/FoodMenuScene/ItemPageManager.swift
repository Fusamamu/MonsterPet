import Foundation
import SpriteKit

class ItemPageManager{
    
    static let sharedInstance = ItemPageManager()
    let itemManager: ItemManager = .sharedInstance
    
    public var currentPage: ItemSelectionPage!
    
    public var pages:[ItemSelectionPage] = []
    
    var page_1 : ItemSelectionPage!
    var page_2 : ItemSelectionPage!
    var page_3 : ItemSelectionPage!
    var page_4 : ItemSelectionPage!
    
    
    
    private init(){
        
    }
    
    public func LoadItemSelectionPage(){
        page_1  = ItemSelectionPage(pageIndex: 0, itemIndex: 0)
        page_2  = ItemSelectionPage(pageIndex: 1, itemIndex: 9)
        page_3  = ItemSelectionPage(pageIndex: 2, itemIndex: 18)
        page_4  = ItemSelectionPage(pageIndex: 3, itemIndex: 27)
        
        page_1.name = "Page_NO.1"
        page_2.name = "Page_NO.2"
        page_3.name = "Page_NO.3"
        page_4.name = "Page_NO.4"
        
        pages.append(contentsOf:[page_1, page_2, page_3, page_4])
        
        currentPage = pages[0]
    }
    
    public func UpdateItemCount(){
        for page in pages{
            for slot in page.slots{
                slot.ItemCount  = itemManager.itemCountInventory[ItemName.allCases[slot.slotIndex]]!
                //slot.itemInSlot.isUnlock = itemManager.slotUpdateUnpackState[slot.slotIndex]!
                slot.countLabel.setGlyphText("x\(String(describing: slot.ItemCount))")
            }
        }
    }
    

    
    
    
}
