//
//  Animation.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 25/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class Animation{
    
    enum AnimationName {
        case coin
        case gotItAffect
    }
    
    
    private var textureAtlas    : SKTextureAtlas!
    private var frames          : [SKTexture] = []
    private var numberImages    : Int!
    
    init() {
        
    }
    
    public func GetBuiltFrames(from atlasName: String) -> [SKTexture]{
        textureAtlas = SKTextureAtlas(named: atlasName)
        numberImages = textureAtlas.textureNames.count
        
        for i in 1...numberImages{
            let textureName = atlasName + "_\(i)"
            print(textureName)
            frames.append(textureAtlas.textureNamed(textureName))
        }
        
        return frames
    }
    
    public func GetAnimatedObject(by animationName: AnimationName) -> SKSpriteNode{
        
        var animatedNode: SKSpriteNode!
        var tempFrames: [SKTexture]!
        
        switch animationName {
            case .coin:
                tempFrames = GetBuiltFrames(from: "coin")
                animatedNode = SKSpriteNode(texture: tempFrames[0])
                
                let animation = SKAction.repeatForever(SKAction.animate(with: tempFrames, timePerFrame: 0.085, resize: false, restore: true))

                animatedNode.run(animation, withKey: "coinSpin")
                return animatedNode
            case .gotItAffect:
                print("did not do anything")
            
                return animatedNode
        }
    }
    
    public func GetAnimatedObject(from frames: [SKTexture]) -> SKSpriteNode{
        let animatedNode = SKSpriteNode(texture: frames[0])
        let animation   = SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.085, resize: false, restore: true))
        animatedNode.run(animation, withKey: "default")
        return animatedNode
    }
    
    public func GetAnimatedAction(from frames: [SKTexture], timePerFrame: TimeInterval = 0.085) -> SKAction{
       
        let animation   = SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: timePerFrame, resize: false, restore: true))
        
        return animation
    }
    
    public func animateSmoke(at position: CGPoint, in skScene: SKScene){
        
        let smokeAtlas = SKTextureAtlas(named: "Smoke")
        var smokeFrames: [SKTexture] = []
        
        let numberImages = smokeAtlas.textureNames.count
        
        for i in 1...numberImages{
            let smokeTextureName = "smoke\(i)"
            smokeFrames.append(smokeAtlas.textureNamed(smokeTextureName))
        }
        
        let smoke = SKSpriteNode(texture: smokeFrames[0])
        smoke.setScale(0.15)
        smoke.zPosition = 2
        smoke.position = position
        smoke.position.y -= 20
        skScene.addChild(smoke)
        
        let smokeAnimate = SKAction.animate(with: smokeFrames, timePerFrame: 0.1, resize: false, restore: true)
        smoke.run(SKAction.repeat(smokeAnimate, count: 1), completion: { smoke.removeFromParent() })
    }
    
}


//
//if gotIt_AffectNode == nil{
//    gotIt_AnimationFrames = Animation().GetBuiltFrames(from: "gotItAffect")
//    gotIt_AffectNode = SKSpriteNode(texture: gotIt_AnimationFrames[0])
//    gotIt_AffectNode.setScale(0.8)
//    gotIt_AffectNode.zPosition = 16
//}
//
//let animation  = SKAction.repeatForever(SKAction.animate(with: gotIt_AnimationFrames, timePerFrame: 0.5, resize: false, restore: true))
//let rotateAnimation = SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 0.65))
//let group = SKAction.group([animation, rotateAnimation])
//gotIt_AffectNode.run(group)
//
//self.addChild(gotIt_AffectNode)
