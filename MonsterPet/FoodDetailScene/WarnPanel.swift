//
//  WarnPanel.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 11/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class WarnPanel: Panel{
    override func Open(){
        
        self.position = CGPoint(x: currentSKscene.frame.midX, y: currentSKscene.frame.midY)
        currentSKscene.addChild(self)
        isOpened = true
        self.run(SKEase.scale(easeFunction: .curveTypeExpo, easeType: .easeTypeInOut, time: 0.1, from: 0.2, to: 0.13))
        self.run(SoundManager.sharedInstanced.Play(by: .clickError))
        
    }
}
