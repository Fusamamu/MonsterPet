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
    
    public var currentSKScene: SKScene!
    
    private var treeCount: Int = 9
    

    public var allTrees: [Tree] = []
    
    private var allEnvironmentObjects: [SKSpriteNode] = []
    private var house: SKSpriteNode!
    private var wall: SKSpriteNode!
    
    
    private var treePositions: [CGPoint] = [
        CGPoint(x: 88, y: 308),
        CGPoint(x: 131, y: 13),
        CGPoint(x: 320, y: -135),
        CGPoint(x: 340, y: 420),
        
        CGPoint(x: 208, y: 495),
        CGPoint(x: 35, y: 340),
        CGPoint(x: 280, y: 448),
        CGPoint(x: 385, y: -15),
        
        CGPoint(x: 360, y: 500)
    ]
    
    
    init(skScene: SKScene) {
        currentSKScene = skScene
        
        LoadEnvironment()
        LoadTrees()
        SortTreesLayer()
    }
    
    private func LoadEnvironment(){
        
        let mainBackground = SKSpriteNode(imageNamed: "CleanBackground")
        mainBackground.position = CGPoint(x: currentSKScene.frame.midX, y: currentSKScene.frame.midY)
        mainBackground.zPosition = -1
        mainBackground.setScale(0.47)
        currentSKScene.addChild(mainBackground)
        
        
        house = SKSpriteNode(imageNamed: "house")
        house.anchorPoint = CGPoint(x: 0.5, y: 0)
        house.setScale(0.47)
        house.zPosition = 0
        house.position = CGPoint(x: 90, y: 466)
        currentSKScene.addChild(house)
        
        wall = SKSpriteNode(imageNamed: "wall")
        wall.anchorPoint = CGPoint(x: 0.5, y: 0)
        wall.setScale(0.47)
        wall.zPosition = 10
        wall.position = CGPoint(x: 98, y: -153)
        currentSKScene.addChild(wall)
        
        allEnvironmentObjects.append(contentsOf: [house, wall])
    }
    
    
    private func LoadTrees(){
        for i in 0...treeCount - 1{
            let tree = Tree(imageNamed: "tree" + "\(i + 1)", skScene: currentSKScene)
            tree.position = treePositions[i]
            tree.zPosition = 20
            tree.setScale(0.47)
            currentSKScene.addChild(tree)
            allTrees.append(tree)
            
            allEnvironmentObjects.append(tree)
        }
    }
    
    
    
    private func SortTreesLayer(){
        allTrees = allTrees.sorted(by: { $0.position.y > $1.position.y })
        
        for i in 0...allTrees.count - 1{
            allTrees[i].zPosition = CGFloat(i)
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
}
