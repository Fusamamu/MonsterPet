import Foundation
import SpriteKit

class LabelBuilder{
    

    
    private var font: BMGlyphFont!
    private var chalkboardRegular : BMGlyphFont!
    
    private(set) var defaultLabelScale      : CGFloat  = 2
    private(set) var itemCountLabelScale    : CGFloat   = 5
    private(set) var defaultZPosition       : CGFloat  = 7
    
    enum LabelTypes {
        case itemCountLabel
        case pageCountLabel
        case priceTag
        case equipmentNameLabel
        case titleLabel
    }
    
    
    init() {

//        font = BMGlyphFont(name: "petText")
//        chalkboardRegular = BMGlyphFont(name: "ChalkboardRegular")
        font = BMGlyphFont(name: "TitleText")
        chalkboardRegular = BMGlyphFont(name: "hd")
    }
    
    public func Build(selectedLabel: LabelTypes) -> BMGlyphLabel{
        switch selectedLabel {
        case .itemCountLabel:
            let itemCountLabel = BMGlyphLabel(txt: "Default Text.", fnt: font)
            
            itemCountLabel.setHorizontalAlignment(.right)
            itemCountLabel.setScale(itemCountLabelScale)
            itemCountLabel.zPosition = defaultZPosition
            itemCountLabel.position  = CGPoint(x: 250, y: -160)
            
            return itemCountLabel
        case .pageCountLabel:
            let pageCountLabel = BMGlyphLabel(txt: "Default Text", fnt: font)
            
            pageCountLabel.setHorizontalAlignment(.centered)
            pageCountLabel.setScale(1)
            pageCountLabel.zPosition = 12
           
            return pageCountLabel
        case .priceTag:
            let priceTag = BMGlyphLabel(txt: "Defaulte Text", fnt: font)
            
            priceTag.setHorizontalAlignment(.centered)
            priceTag.setScale(2.1)
            priceTag.zPosition = 12
            
            return priceTag
        case .equipmentNameLabel:
            let equipmentNameLabel = BMGlyphLabel(txt: "Default Text", fnt: chalkboardRegular)
            
            equipmentNameLabel.setHorizontalAlignment(.centered)
            equipmentNameLabel.setScale(3)
            equipmentNameLabel.zPosition = defaultZPosition
            return equipmentNameLabel
        case .titleLabel:
            let titleLabel = BMGlyphLabel(txt: "Default Text", fnt: BMGlyphFont(name: "TitleText"))
            
            titleLabel.setHorizontalAlignment(.centered)
            titleLabel.setScale(1.2)
            titleLabel.zPosition = defaultZPosition
            return titleLabel
        }
    }
}
