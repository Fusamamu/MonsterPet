import Foundation
import SpriteKit

class PlaceHolderManager{
    
    static let sharedInstance = PlaceHolderManager()
    
    private let itemManager         = ItemManager.sharedInstance
    private let packageManager      = PackageManager.sharedInstance
    private let equipmentManager    = EquipmentManager.sharedInstance
    
    var pointData               : [CGPoint] = []
   // var surroundingPointData    : [CGPoint: [CGPoint: Bool]] = [:]
    var surroundingPointData: [CGPoint:[Bool]] = [:]
    
    let point_1 = CGPoint(x: 200, y: 450)
    let point_2 = CGPoint(x: 285, y: 375)
    let point_3 = CGPoint(x: 110, y: 270)
    let point_4 = CGPoint(x: 290, y: 250)
    let point_5 = CGPoint(x: 205, y: 160)
    
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
        
        surroundingPointData = Dictionary(minimumCapacity: 5)
        surroundingPointData =
            [point_1: [true, true, true, true],
             point_2: [true, true, true, true],
             point_3: [true, true, true, true],
             point_4: [true, true, true, true],
             point_5: [true, true, true, true]]
        
        itemManager.InitilizeObjectData(pointData: pointData)
        packageManager.InitializePackageInSceneDataPoint(pointData: pointData)
        equipmentManager.InitilizeObjectData(pointData: pointData)
    }
    
    func AddArrowImages(to scene: SKScene?){
        //Check place available// need to make it cleaner
        for point in pointData{
            itemManager.itemData[point]?.isPlacable = isPlaceAvailable(at: point)
            
            if itemManager.itemData[point]!.item != nil {
                itemManager.itemData[point]?.isPlacable = false
            }
        }
        
        
        arrowIsAdded = true
        
        for i in 0...4{
            guard let itemData      = itemManager.itemData[pointData[i]]            else { continue }
            guard let equipmentData = equipmentManager.equipmentData[pointData[i]]  else { continue }
            
            if itemData.isPlacable && equipmentData.isPlacable{
                arrowImages[i] = SKSpriteNode(imageNamed: "HereOK")
                arrowImages[i]?.name = "arrow" + String(i)
                arrowImages[i]?.anchorPoint = CGPoint(x: 0.2, y: 0.2)
                arrowImages[i]?.position = pointData[i]
                arrowImages[i]?.setScale(0.47)
                arrowImages[i]?.zPosition = 6
                scene!.addChild(arrowImages[i]!)
            }else{
                // this is wrong on so many levels
//                if itemData.item == nil{
//                    itemManager.itemData[pointData[i]]?.isPlacable = true
//                }

                
            }
        }
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
    
    func isPlaceAvailable(at point: CGPoint) -> Bool{
        var _isPlacable: Bool = true
        
        for index in 0...3 {
            if surroundingPointData[point]![index] == false {
                _isPlacable = false
            }
        }
 
        if packageManager.packageInSceneData[point] != nil {
            _isPlacable = false
        }
        
        return _isPlacable
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
