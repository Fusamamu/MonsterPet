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
        
        self.run(Animation().GetAnimatedAction(from: animatedFrames, timePerFrame: 0.085), withKey: "bonusPanelAnimation")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func Open() {
        
    }
    
    override func Close() {
        
    }
}
