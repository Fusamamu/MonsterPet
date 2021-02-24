//
//  GameViewController.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 1/3/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SaveNLoadManager.sharedInstance.LoadCurrencyData()
        //PetSaveDataManager.sharedInstance.LoadPetInfo()
        
        
        
        
    
        
        let view = self.view as! SKView
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
        let mainScene = MainScene(size: self.view.bounds.size)
        mainScene.scaleMode = .aspectFill
        view.presentScene(mainScene)
        
        //let textureManager = TextureManager.sharedInstance
        
        ItemPageManager.sharedInstance.LoadItemSelectionPage()
        PetInfoPageManager.sharedInstance.LoadPetInfoPages()
        GiftPageManager.sharedInstance.LoadGiftPage()
        
        
        
       // NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SoundManager.sharedInstanced.playBackgroundSound(_:)), name: NSNotification.Name(rawValue: "PlayBackgroundSound"), object: nil)

      
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
