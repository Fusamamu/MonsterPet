//
//  PackageManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 30/11/2563 BE.
//  Copyright © 2563 BE Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class PackageManager: Observable{
    
    static let sharedInstance = PackageManager()
    
    let itemManager        : ItemManager        = .sharedInstance
    let equipmentManager   : EquipmentManager   = .sharedInstance
    
    public var observers            : [Observer] = []
    public var currentScene         : SKScene!
    public var packageInSceneData   : [CGPoint: Package?] = [:]
    
    private init(){
        packageInSceneData = Dictionary(minimumCapacity: 5)
    }
    
    public func InitializePackageInSceneDataPoint(pointData: [CGPoint]){
        for point in pointData{
            packageInSceneData[point] = nil
        }
    }
    
    func SetCurrentScene(gameScene: SKScene){
        currentScene = gameScene
    }
    
//    func ScanPackages(at currentTime: CFTimeInterval){
//
//    }
    
    func UpdateTouch(at location: CGPoint){
        for package in packageInSceneData.values{
            if package!.contains(location){
                Remove(package: package!)
            }
        }
    }

    func LoadPackageInScene(){
        for package in packageInSceneData.values{
            if package != nil{
                currentScene.addChild(package!)
            }
        }
    }
    
    func Remove(package: Package){
        
        self.itemManager.itemData[package.position]!.isPlacable = true
        self.equipmentManager.equipmentData[package.position]!.isPlacable = true
        
        package.texture = package.openedImage
        
        let wait        = SKAction.wait(forDuration: 3)
        let fadeOut     = SKAction.fadeOut(withDuration: 1)
        
        package.run(SKAction.sequence([wait, fadeOut])){
            
            package.removeFromParent()
            //self.packageInScene = self.packageInScene.filter({ $0 != package })
            
            //have to wait until completely fade away to become placable again//
            self.packageInSceneData[package.position] = nil
        }
    }
    
    func AddObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func RemoveObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }

    func NotifyAllObservers() {
        for observer in observers{
            observer.Update()
        }
    }
}
