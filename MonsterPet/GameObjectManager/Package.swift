import Foundation
import SpriteKit

enum PackageName: String, CaseIterable{
    case woodenPackage = "closedPackage"
    case goldenPackage = "closedGoldenPackage"
}

class Package: SKSpriteNode{
    
    var Index: Int = -1
    var packageName: PackageName!
    
    var closedImage: SKTexture!
    var openedImage: SKTexture!
    
    var itemInside: Item!
    
    
    //random Type(wooden , silver, gold)
    //random Item Besed On Type
    //How to add Gift??
    
    init(){
        
        closedImage = SKTexture(imageNamed: "closedWoodPackage")
        openedImage = SKTexture(imageNamed: "openedWoodPackage")
        
        super.init(texture: closedImage, color: .clear, size: closedImage.size())
        self.setScale(0.1)
        self.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func SetItemInside(to item:Item){
        self.itemInside = item
    }

    func GetItemInside() -> Item{
        return self.itemInside
    }
    
    func OnClicked(at location: CGPoint){
        //open package
        //get item inside
        //package diappear
        if self.contains(location){
            self.texture = openedImage
            itemInside.zPosition = 3
            self.addChild(itemInside)
            
        }
        
    }
    
    
}
