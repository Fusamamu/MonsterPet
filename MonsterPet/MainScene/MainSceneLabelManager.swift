import Foundation
import SpriteKit

class LabelManager: BaseUIManager, Observer{
    
    var id: Int = 0;
    
    var device: DeviceDependency = .sharedInstance
    var currenyManager: CurrencyManager = .sharedInstance
    
    var countFont       : BMGlyphFont!
    var heartCountLabel : BMGlyphLabel!
    var coinCountLabel  : BMGlyphLabel!
    
    private(set) var labelScale: CGFloat = DeviceDependency.sharedInstance.heart_n_coin_LabelScale
    
    
    //let AndaleMono: String = "Andale Mono-Bold"
    

    override init(skScene: SKScene) {
        super.init(skScene: skScene)

        AddHeartCountLabel()
    
    }
    
    func AddHeartCountLabel(){
        
        countFont = BMGlyphFont(name: "TitleText")
       
        heartCountLabel = BMGlyphLabel(txt: String(currenyManager.HeartCounts), fnt: countFont)
        
       
        
       
        
        heartCountLabel.setHorizontalAlignment(.right)
        heartCountLabel.position = CGPoint(x: min_X, y: max_Y)
        heartCountLabel.position.x += device.hearCountLabelPosition.x
        heartCountLabel.position.y -= device.hearCountLabelPosition.y
        heartCountLabel.zPosition = 47
        heartCountLabel.setScale(labelScale)
        currentSKScene.addChild(heartCountLabel)
        
        coinCountLabel = BMGlyphLabel(txt: String(currenyManager.CoinCounts), fnt: countFont)
        coinCountLabel.setHorizontalAlignment(.right)
        coinCountLabel.position = heartCountLabel.position
        coinCountLabel.position.y -= 47
        coinCountLabel.zPosition = 47
        coinCountLabel.setScale(labelScale)
        currentSKScene.addChild(coinCountLabel)
        
    }
    
    func Update() {
       
        heartCountLabel.setGlyphText(String(currenyManager.HeartCounts))
        coinCountLabel.setGlyphText(String(currenyManager.CoinCounts))
    }
    
    
}
