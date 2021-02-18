//
//  SoundManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 18/2/2564 BE.
//  Copyright © 2564 BE Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

enum SoundName: String {
    case penClick       = "Pen Click Sfx.wav"
    case coin           = "mixkit-fairy-arcade-sparkle-866.wav"
    case heart          = "mixkit-magic-bubbles-spell-2999.wav"
    case slide          = "mixkit-paper-slide-1530.wav"
    case clickError     = "mixkit-click-error-1110.wav"
    case interfaceClick = "mixkit-cool-interface-click-tone-2568.wav"
}

class SoundManager {
    static let sharedInstanced = SoundManager()
    
    public var musicVolume: Float!
    public var effectVolume: Float!
    
    public var BMG_ON   : Bool = false
    public var SE_ON    : Bool = false
    
    public let penClick    = "Pen Click Sfx.wav"
    public let coin        = "mixkit-fairy-arcade-sparkle-866.wav"
    
    
    
    
    private init(){
        
    }
    
    public func Play(by name: String)->SKAction{
        return SKAction.playSoundFileNamed(name, waitForCompletion: false)
        
        
//        let sound = SKAction.playSoundFileNamed("machinegun")
//        let action = SKAction.changeVolume(by: -1, duration: 1)
//        let group = SKAction.group([sound,action])
    }
    
    public func Play(by name: SoundName)->SKAction{
        return SKAction.playSoundFileNamed(name.rawValue, waitForCompletion: false)
    }
}
