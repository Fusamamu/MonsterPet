//
//  Tree.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 1/8/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class CoinCollectedCount{
    
    static let sharedInstance = CoinCollectedCount()
    
    public var collectedCount = 0;
    
    public var collectedCount_s:[Int] = []
    
    private init(){
        for _ in 0...8{
            collectedCount_s.append(0)
        }
    }
}

class Tree: SKSpriteNode{
    
    private let currency: CurrencyManager = .sharedInstance
    private let coinCollected: CoinCollectedCount = .sharedInstance
    
    public var index: Int!
    
    public var textureImage: SKTexture!
    
    private var currentSKScene: SKScene!
    private var currentScenario: SKSpriteNode!
    
    private var maxCoinPerHour   : Int = 3
   // private var collectedCount   : Int = CoinCollectedCount.sharedInstance.collectedCount
    
    
    private var heartLimitCount  : Int = 10
    
//    public var positionY:CGFloat!
    
    public var tapArea: SKSpriteNode!
    
    init(index: Int, imageNamed: String, skScene: SKScene){
        
        self.index = index
        
        textureImage = SKTexture(imageNamed: imageNamed)
        super.init(texture: textureImage , color: .clear, size: textureImage.size())
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.setScale(0.47)
        
        
       // currentScenario = scenario
        currentSKScene = skScene
        
        tapArea = SKSpriteNode(imageNamed: "tapArea")
        tapArea.zPosition = 10
        tapArea.setScale(0.7)
        tapArea.position.y += self.frame.height * 1.2
        tapArea.alpha = 0.2
        self.addChild(tapArea)
        

        self.run(GetIdleTreeAnimation(), withKey: "IdleAnimation")
        
      //  collectedCount = CoinCollectedCount.sharedInstance.collectedCount
        
//        positionY = self.position.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func OnTouched(at location: CGPoint){
        
        
        print(CoinCollectedCount.sharedInstance.collectedCount)
        
        if coinCollected.collectedCount_s[index] < maxCoinPerHour{
            
            if  let convertedLoc = scene?.convert(location, to: self),
                
                tapArea.contains(convertedLoc){
                
                run(SoundManager.sharedInstanced.Play(by: SoundManager.sharedInstanced.coin))
                
                coinCollected.collectedCount_s[index]  += 1
                
                PopUpCoin(at: self.position)
                self.removeAction(forKey: "IdleAnimation")
                self.run(GetWhenTouchedTreeAnimation(), completion: {
                    self.run(self.GetIdleTreeAnimation(), withKey: "IdleAnimation")
                })
            }
        }
    }
    
    //make this function to be able popup Heart//
    private func PopUpCoin(at position: CGPoint){
        let node = Animation().GetAnimatedObject(by: .coin)
        
        node.zPosition = self.zPosition + 1
        node.setScale(0.07)
        node.position = CGPoint(x: self.position.x, y: self.position.y + 80)

        currentSKScene.addChild(node)
        
        //currentScenario.addChild(node)
        
        let popUpHeight: CGFloat = 180
        
        let up = SKEase.move(easeFunction: .curveTypeExpo, easeType: .easeTypeOut, time: 0.5, from: node.position, to: CGPoint(x: position.x, y: position.y + popUpHeight))
        let down = SKEase.move(easeFunction: .curveTypeExpo, easeType: .easeTypeIn, time: 0.5, from: CGPoint(x: position.x, y: position.y + popUpHeight), to: node.position)

        let wait    = SKAction.wait(forDuration: 0.7)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)

        let upNDown = SKAction.sequence([up, down])
        let waitNFadeOut = SKAction.sequence([wait, fadeOut])
        
        let popUpAnimation = SKAction.group([upNDown, waitNFadeOut])
        node.run(popUpAnimation, completion: {node.removeFromParent()})
        
        currency.CoinCounts += 10
    }
    
    private func GetIdleTreeAnimation() -> SKAction{
        
        let duration = 0.3
        let scaleUp        = SKAction.scaleY(to: 0.49, duration: duration)
        let scaleDown      = SKAction.scaleY(to: 0.42, duration: duration)
        let idleAnimation  = SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown]))
        
        return idleAnimation
    }
    
    private func GetWhenTouchedTreeAnimation() -> SKAction{
          
        let whenTouchedAnimation = SKEase.scaleY(
        easeFunction: .curveTypeSine,
        easeType: .easeTypeOut,
        time: 0.025,
            from: 0.47, to: 0.55)

        return whenTouchedAnimation
    }
    
    public func ResetCoin(isNeeded: Bool){
        coinCollected.collectedCount_s[index]  = 0
    }
}
