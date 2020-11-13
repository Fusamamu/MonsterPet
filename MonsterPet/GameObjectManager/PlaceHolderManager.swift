import Foundation
import SpriteKit

class PlaceHolderManager{
    
    static let sharedInstance = PlaceHolderManager()
    
    private let itemManager         = ItemManager.sharedInstance
    private let equipmentManager    = EquipmentManager.sharedInstance
    
    var pointData               : [CGPoint] = []
   // var surroundingPointData    : [CGPoint: [CGPoint: Bool]] = [:]
    var surroundingPointData: [CGPoint:[Bool]] = [:]
    
    let point_1 = CGPoint(x: 200, y: 450)
    let point_2 = CGPoint(x: 285, y: 375)
    let point_3 = CGPoint(x: 110, y: 270)
    let point_4 = CGPoint(x: 290, y: 250)
    let point_5 = CGPoint(x: 205, y: 160)
    
//    let NW_point = CGPoint(x: -40, y: 40)
//    let NE_point = CGPoint(x: 40, y: 40)
//    let SE_point = CGPoint(x: 40, y: -40)
//    let SW_point = CGPoint(x: -40, y: -40)
    
    let NW_point = CGPoint(x: -40, y: 20)
    let NE_point = CGPoint(x: 40, y: 20)
    let SE_point = CGPoint(x: 40, y: -40)
    let SW_point = CGPoint(x: -40, y: -40)
    
    var arrowImages :[SKSpriteNode?] = []
    var arrowIsAdded: Bool = false
    var arrowCount  : Int  = 5
    
    
    private init(){
        
        arrowImages = Array(repeating: SKSpriteNode(imageNamed: "HereOK"), count: 5)
        
        pointData.append(contentsOf: [point_1, point_2, point_3, point_4, point_5])
        
        itemManager.InitilizeObjectData(pointData: pointData)
        equipmentManager.InitilizeObjectData(pointData: pointData)
        
    
            
        surroundingPointData = Dictionary(minimumCapacity: 5)
        
        surroundingPointData =
            [point_1: [true, true, true, true],
            point_2: [true, true, true, true],
            point_3: [true, true, true, true],
            point_4: [true, true, true, true],
            point_5: [true, true, true, true]]
        
       
        
        

    }
    
    
    func AddArrowImages(to scene: SKScene?){
        
        for i in 0...4{
            
            guard let itemData      = itemManager.itemData[pointData[i]]            else { continue }
            guard let equipmentData = equipmentManager.equipmentData[pointData[i]]  else { continue }
            
            if itemData.isPlacable && equipmentData.isPlacable{
                arrowImages[i] = SKSpriteNode(imageNamed: "HereOK")
                arrowImages[i]?.name = "arrow" + String(i)
                arrowImages[i]?.position = pointData[i]
                arrowImages[i]?.setScale(0.47)
                arrowImages[i]?.zPosition = 2
                scene!.addChild(arrowImages[i]!)
            }else{
                
                // this is wrong on so many levels
                if itemData.item == nil{
                    itemManager.itemData[pointData[i]]?.isPlacable = true
                }
            }
        }
        arrowIsAdded = true
    }
    
    func RemoveAllArrow(){
        for i in 0...arrowCount - 1{
            if arrowImages[i] != nil{
                arrowImages[i]!.removeFromParent()
                arrowImages[i] = nil
            }
        }
        arrowIsAdded = false
    }
    
}


extension CGPoint : Hashable {
    func distance(point: CGPoint) -> Float {
        let dx = Float(x - point.x)
        let dy = Float(y - point.y)
        return sqrt((dx * dx) + (dy * dy))
    }
    
    public var hashValue: Int {
        return x.hashValue << 32 ^ y.hashValue
    }
    
    public func hash(into hasher: inout Hasher){ }
}

func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.distance(point: rhs) < 0.000001
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
