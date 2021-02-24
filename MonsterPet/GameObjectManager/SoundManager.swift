//
//  SoundManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 18/2/2564 BE.
//  Copyright © 2564 BE Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit
import AVKit

enum SoundName: String {
    case BGM            = "bensound-ukulele.mp3"
    case penClick       = "Pen Click Sfx.wav"
    case coin           = "mixkit-fairy-arcade-sparkle-866.wav"
    case heart          = "mixkit-magic-bubbles-spell-2999.wav"
    case slide          = "mixkit-paper-slide-1530.wav"
    case clickError     = "mixkit-click-error-1110.wav"
    case interfaceClick = "mixkit-cool-interface-click-tone-2568.wav"
}

class SoundManager {
    static let sharedInstanced = SoundManager()
    
    public var BMG_AudioPlayer      : SKAudioNode!
    public var BGM_AVAudioPlayer    : AVAudioPlayer!
    
    public var musicVolume: Float!
    public var effectVolume: Float!
    
    public var BMG_ADDED: Bool = false
    
    public var BMG_ON   : Bool = false
    public var SE_ON    : Bool = false

    
    
    public let penClick    = "Pen Click Sfx.wav"
    public let coin        = "mixkit-fairy-arcade-sparkle-866.wav"
    
    
    public var BGM_NODE: SKNode!
    public var ref_skscene: SKScene!
    
    private init(){
        BGM_NODE = SKNode()
        ///BMG_AudioPlayer = SKAudioNode()
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
    
    public func Play_BMG(in skScene: SKScene){
//        let bgMusic = SKAudioNode(fileNamed: "bensound-ukulele.mp3")
//        bgMusic.run(SKAction.changeVolume(to: 0.2, duration: 0))
//        skScene.addChild(bgMusic)

        
//        if !BMG_ADDED {
//            BMG_ADDED = true
//            skScene.run(SKAction.playSoundFileNamed(SoundName.BGM.rawValue, waitForCompletion: false))
//
//            ref_skscene = skScene
//          //  BGM_NODE.run(SKAction.playSoundFileNamed(SoundName.BGM.rawValue, waitForCompletion: false))
//
//            skScene.run(SKAction.changeVolume(to: 0, duration: 0.1))
//            SetVolume(by: 10)
//        }
//
        
        if !BMG_ADDED{
            let temp_audio = SKAudioNode(fileNamed: "bensound-ukulele.mp3")
            temp_audio.run(SKAction.changeVolume(to: 0.2, duration: 0))
            BMG_AudioPlayer = temp_audio
            skScene.addChild(BMG_AudioPlayer)
            BMG_AudioPlayer.autoplayLooped = true
            
            BMG_ADDED = true
        }
        
    }
    
    public func SetVolume(by pencentage: CGFloat){
//        let changeVolumeAction = SKAction.changeVolume(to: 0.3, duration: 0.3)
//        node.run(changeVolume)
        
                let changeVolumeAction = SKAction.changeVolume(to: 0.0, duration: 0.3)
         
        
        ref_skscene.run(changeVolumeAction)
    }
    
    @objc public func playBackgroundSound(_ notification: Notification) {
         
         
            let name = (notification as NSNotification).userInfo!["fileToPlay"] as! String
         
         
         
            if (BGM_AVAudioPlayer != nil){
             
                BGM_AVAudioPlayer!.stop()
                BGM_AVAudioPlayer = nil
             
             
            }
         
            if (name != ""){
             
                let fileURL:URL = Bundle.main.url(forResource:name, withExtension: "mp3")!
             
                do {
                    BGM_AVAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                } catch _{
                    BGM_AVAudioPlayer = nil

                }
            
                
                
                BGM_AVAudioPlayer!.volume = 0.75
                BGM_AVAudioPlayer!.numberOfLoops = -1
                BGM_AVAudioPlayer!.prepareToPlay()
                BGM_AVAudioPlayer!.play()
             
            }
         
         
        }
    
}
