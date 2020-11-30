//
//  SceneEnvironment.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 2/8/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class SceneEnvironment{
    
    private let device: DeviceDependency = .sharedInstance
    
    public var currentSKScene: SKScene!
    
    private var treeCount: Int = 9
    

    public var allTrees: [Tree] = []
    
    private var allEnvironmentObjects: [SKSpriteNode] = []
    
    public var mainBackground: SKSpriteNode!
    
    private var house: SKSpriteNode!
    private var wall: SKSpriteNode!
    
    
    private var treePositions: [CGPoint] = [
        
        
        CGPoint(x: -195, y: -50),
        
        
        CGPoint(x: -100, y: -750),
        
        CGPoint(x: 220, y: -1000),
        
        
        CGPoint(x: 320, y: 150),
        
        CGPoint(x: 50, y: 340),
        
        
        
        
        CGPoint(x: -320, y: 20),
        
        
        CGPoint(x: 200, y: 250),
        
        
        CGPoint(x: 330, y: -800),
        
        CGPoint(x: 310, y: 300)
        
    ]
    
    
    init(skScene: SKScene) {
        currentSKScene = skScene
        
        LoadEnvironment()
        LoadTrees()
        SortTreesLayer()
        
        MoveNodesToScene()
        wall.setScale(0.47)
        wall.move(toParent: currentSKScene)
    }
    
    private func LoadEnvironment(){
        
        mainBackground = SKSpriteNode(imageNamed: "CleanBackground")
        mainBackground.position = CGPoint(x: currentSKScene.frame.midX, y: currentSKScene.frame.midY)
        mainBackground.position.x += device.mainBackground_Pos.x
        mainBackground.position.y += device.mainBackground_Pos.y
        
        mainBackground.zPosition = -20
        mainBackground.setScale(device.mainBackground_Scale)
        currentSKScene.addChild(mainBackground)
        
        
        house = SKSpriteNode(imageNamed: "house")
        house.anchorPoint = CGPoint(x: 0.5, y: 0)
        house.setScale(1)
        house.zPosition = 0.5
        house.position = CGPoint(x: -205, y: 295)
        mainBackground.addChild(house)
        //currentSKScene.addChild(house)
        
        wall = SKSpriteNode(imageNamed: "wall")
        wall.anchorPoint = CGPoint(x: 0.5, y: 0)
        wall.setScale(1)
        wall.zPosition = 20
        wall.position = CGPoint(x: -200, y: -1000)
        mainBackground.addChild(wall)
        //currentSKScene.addChild(wall)
        
        allEnvironmentObjects.append(contentsOf: [house, wall])
    }
    
    
    private func LoadTrees(){
        for i in 0...treeCount - 1{
            let tree = Tree(index: i, imageNamed: "tree" + "\(i + 1)", skScene: currentSKScene)
            tree.position = treePositions[i]
            tree.zPosition = 20
            tree.setScale(1)
            mainBackground.addChild(tree)
            //currentSKScene.addChild(tree)
            allTrees.append(tree)
            
            allEnvironmentObjects.append(tree)
        }
    }
    
    
    
    private func SortTreesLayer(){
        allTrees = allTrees.sorted(by: { $0.position.y > $1.position.y })
        
        for i in 0...allTrees.count - 1{
            allTrees[i].zPosition = CGFloat(i) + 1
        }
    }
    
    private func SortLayer(){
        allEnvironmentObjects = allEnvironmentObjects.sorted(by: { $0.position.y > $1.position.y })
        for i in 0...allEnvironmentObjects.count - 1{
            allEnvironmentObjects[i].zPosition = CGFloat(i)
        }
    }
    
    public func UpdateTouched(on location: CGPoint){
        for tree in allTrees{
            tree.OnTouched(at: location)
        }
    }
    
    private func GetCGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    private func GetCGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(GetCGPointDistanceSquared(from: from, to: to))
    }
    
    private func MoveNodesToScene(){
        for tree in allTrees{
            tree.setScale(0.47)
            tree.move(toParent: currentSKScene)

            
        }
    }
}
