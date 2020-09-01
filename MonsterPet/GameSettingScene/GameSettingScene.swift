import Foundation
import SpriteKit

class GameSettingScene : SKScene{
    
    private let currencyManager : CurrencyManager = .sharedInstance
    
    private var uiManager       : GameSettingUIManager!
    private var swipeManager    : SwipeManager!
    
    var currentPageIndex: Int = 0
    var currentPage     : EquipmentSelectionPage!
    
    override func didMove(to view: SKView) {
        uiManager = GameSettingUIManager(skScene: self)
        self.backgroundColor = UIColor(red: 178/255, green: 176/255, blue: 122/255, alpha: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
    }
}
