//
//  GotItPanel.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 25/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class GotItPanel: SKNode, ButtonDelegate{
    
    private let layerManager: LayerManager = .sharedInstance
    
    var isOpened: Bool!
    var sender: Button!
    
    public var currentSKScene: SKScene!
    
    public  var gotIt_AffectNode: SKSpriteNode!
    private var gotIt_AnimationFrames: [SKTexture] = []
    //private var gotIt_Item: ItemProtocol!
    
    private var particle: SKEmitterNode!
    private var alphaBlack: SKSpriteNode!
    
    public var gotIt_Item: SKSpriteNode!
    
    
    
    
    override init(){
        
        super.init()
        
        isOpened = false
        
        if gotIt_AffectNode == nil{
            gotIt_AnimationFrames = Animation().GetBuiltFrames(from: "gotItAffect")
            gotIt_AffectNode = SKSpriteNode(texture: gotIt_AnimationFrames[0])
            gotIt_AffectNode.setScale(0.8)
            gotIt_AffectNode.zPosition = 16
        }
        
        let animation  = SKAction.repeatForever(SKAction.animate(with: gotIt_AnimationFrames, timePerFrame: 0.5, resize: false, restore: true))
        let rotateAnimation = SKAction.repeatForever(SKAction.rotate(byAngle: 1, duration: 0.65))
        let group = SKAction.group([animation, rotateAnimation])
        gotIt_AffectNode.run(group)
        
        self.addChild(gotIt_AffectNode)
        

        if alphaBlack == nil{
            alphaBlack = SKSpriteNode(imageNamed: "AlphaBlack")
            alphaBlack.zPosition = 15
            alphaBlack.alpha = 0
            self.addChild(alphaBlack)
        }
        
        if particle == nil{
            particle = SKEmitterNode(fileNamed: "flare.sks")
            particle?.zPosition = 17
            self.addChild(particle!)
        }
        
        if gotIt_Item == nil{
            gotIt_Item = SKSpriteNode(imageNamed: "default")
            gotIt_Item.setScale(1.1)
            gotIt_Item.zPosition = 20
            self.addChild(gotIt_Item)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func Invoked() {
        isOpened ? Close(): Open()

    }
    
    func Open() {
        isOpened = true
        
        self.position = CGPoint(x: currentSKScene.frame.midX, y: currentSKScene.frame.midY)
        currentSKScene.addChild(self)
        
        alphaBlack.alpha = 0
        alphaBlack.run(SKAction.fadeAlpha(to: 0.8, duration: 0.3))
    }
    
    func Close() {
        self.removeFromParent()
        isOpened = false
    }
    
    
    
    
}
