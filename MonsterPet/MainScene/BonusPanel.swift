//
//  BonusPanel.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 20/11/2563 BE.
//  Copyright © 2563 BE Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class BonusPanel: Panel{
    
    public var animatedFrames: [SKTexture] = []
    
    override init(panelImage: String, skScene: SKScene) {
        super.init(panelImage: panelImage, skScene: skScene)
        
        animatedFrames = Animation().GetBuiltFrames(from: "getBonusPanel")
        texture        = animatedFrames[0]
        size           = texture!.size()
        
        self.run(Animation().GetAnimatedAction(from: animatedFrames, timePerFrame: 0.17), withKey: "bonusPanelAnimation")
        self.setScale(0.25)
        self.zPosition = 200
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Open() {
        self.position = CGPoint(x: currentSKscene.frame.midX, y: 0 - self.texture!.size().width)
        
        let moveUp = SKEase.move(easeFunction: .curveTypeCubic, easeType: .easeTypeOut, time:0.4, from: self.position, to: CGPoint(x: currentSKscene.frame.midX, y: 150))
        
       
        self.run(moveUp)
        
        currentSKscene.addChild(self)
        isOpened = true
    }
    
    override func Close(){
        self.removeFromParent()
        isOpened = false
        RemoveAllButtonReferences()
    }
}
