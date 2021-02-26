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
    case penClick       = "Pen Click Sfx"
    case coin           = "mixkit-fairy-arcade-sparkle-866"
    case heart          = "mixkit-magic-bubbles-spell-2999"
    case slide          = "mixkit-paper-slide-1530"
    case clickError     = "mixkit-click-error-1110"
    case interfaceClick = "mixkit-cool-interface-click-tone-2568"
}

class SoundManager {
    
    static let sharedInstanced = SoundManager()
    
    enum SoundMode {
        case AVAUDIOPLAYER
        case SKAUDIONODE
    }
    
    public var BMG_AudioPlayer      : SKAudioNode!
    
    public var BGM_AVAudioPlayer    : AVAudioPlayer!
    public var SE_AVAudioPlayer     : AVAudioPlayer!
    
    public var BGM_Volume: Float!
    public var SE_Volume: Float!
    
    public var BMG_ADDED: Bool = false
    
    public var BMG_ON   : Bool = false
    public var SE_ON    : Bool = false

    public var BGM_NODE: SKNode!
    public var ref_skscene: SKScene!
    
    private init(){
        BGM_NODE = SKNode()
        
        BGM_Volume  = 0.5
        SE_Volume   = 0.5
    }
    
    public func Play_SE(by name: String) {
        //return SKAction.playSoundFileNamed(name, waitForCompletion: false)
        
//        let sound   = SKAction.playSoundFileNamed(name, waitForCompletion: false)
//        let action  = SKAction.changeVolume(to: 0, duration: 0)
//
//        return SKAction.group([sound,action])
        
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "wav") else { return }
        
        do{
            SE_AVAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            //Load Save USER SOUND SETTING PREF//
            SE_AVAudioPlayer.volume = SoundManager.sharedInstanced.SE_Volume
            SE_AVAudioPlayer.numberOfLoops = 0
            SE_AVAudioPlayer.prepareToPlay()
            SE_AVAudioPlayer.play()
        }catch{
            print("FAILED TO LOAD MP3 FILE")
        }
    }
    
                                                            //    public func Play(by name: SoundName)->SKAction{
                                                            //        return SKAction.playSoundFileNamed(name.rawValue, waitForCompletion: false)
                                                            //    }
    
                                                            //--------------------------NO LONGER USED-------------------------------//
                                                            public func Play_BMG(in skScene: SKScene){
                                                                if !BMG_ADDED{
                                                                    let temp_audio = SKAudioNode(fileNamed: "bensound-ukulele.mp3")
                                                                    temp_audio.run(SKAction.changeVolume(to: 0.2, duration: 0))
                                                                    BMG_AudioPlayer = temp_audio
                                                                    skScene.addChild(BMG_AudioPlayer)
                                                                    BMG_AudioPlayer.autoplayLooped = true
                                                                    
                                                                    BMG_ADDED = true
                                                                }
                                                            }
                                                            //------------------------------------------------------------------------//
    
    public func Play_BMG(by mode: SoundMode, in skScene: SKScene?){
        switch mode {
        case .AVAUDIOPLAYER:
            guard let fileURL = Bundle.main.url(forResource: "bensound-ukulele", withExtension: "mp3") else { return }
            
            do{
                BGM_AVAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                //Load Save USER SOUND SETTING PREF//
                Set_BGM_VOL(by: 0.1)
                BGM_AVAudioPlayer.prepareToPlay()
                BGM_AVAudioPlayer.play()
            }catch{
                print("FAILED TO LOAD MP3 FILE")
            }
        case .SKAUDIONODE:
            print("SKAUDIONODE MODE")
        }
    }
    
    public func Set_BGM_VOL(by volume: Float){
        if BGM_AVAudioPlayer != nil {
            if volume < 0 { BGM_Volume = 0 }
            if volume > 1 { BGM_Volume = 1 }
            BGM_Volume = volume
            BGM_AVAudioPlayer.volume = BGM_Volume
        }
    }
    
    public func Set_SE_VOL(by volume: Float){
        if SE_AVAudioPlayer != nil {
            if volume < 0 { SE_Volume = 0 }
            if volume > 1 { SE_Volume = 1 }
            SE_Volume = volume
            SE_AVAudioPlayer.volume = SE_Volume
        }
    }
    
                                                                        //NO LONGER USED//
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
