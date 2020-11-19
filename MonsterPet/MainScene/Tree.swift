//
//  Tree.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 1/8/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class Tree: SKSpriteNode{
    
    private let currency: CurrencyManager = .sharedInstance
    
    public var textureImage: SKTexture!
    
    private var currentSKScene: SKScene!
    private var currentScenario: SKSpriteNode!
    
    private var coinLimitCount   : Int = 10
    private var heartLimitCount  : Int = 10
    
//    public var positionY:CGFloat!
    
    init(imageNamed: String, skScene: SKScene){
        textureImage = SKTexture(imageNamed: imageNamed)
        super.init(texture: textureImage , color: .clear, size: textureImage.size())
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.setScale(0.47)
        
        
       // currentScenario = scenario
        currentSKScene = skScene
        
        
        

        self.run(GetIdleTreeAnimation(), withKey: "IdleAnimation")
        
//        positionY = self.position.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func OnTouched(at location: CGPoint){
        if self.contains(location){
            PopUpCoin(at: self.position)
            
            self.removeAction(forKey: "IdleAnimation")
            self.run(GetWhenTouchedTreeAnimation(), completion: {
                self.run(self.GetIdleTreeAnimation(), withKey: "IdleAnimation")
                
            })
        }
    }
    
    
    //make this function to be able popup Heart//
    private func PopUpCoin(at position: CGPoint){
        let node = Animation().GetAnimatedObject(by: .coin)
        
        node.zPosition = self.zPosition + 1
        node.setScale(0.14)
        node.position = CGPoint(x: self.position.x, y: self.position.y + 80)

        currentSKScene.addChild(node)
        
        //currentScenario.addChild(node)
        
        let popUpHeight: CGFloat = 300
        
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
}
