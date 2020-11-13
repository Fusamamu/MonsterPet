//
//  GiftScene.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 3/10/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class GiftScene: SKScene{
    public var sceneName: String = "FoodMenuScene"
    
    private var uiManager: GiftUIManager!
    
    var page_1: GiftPage!
    
    override func didMove(to view: SKView) {
        uiManager = GiftUIManager(skScene: self)
        
        page_1 = GiftPage(pageIndex: 0, itemIndex: 0, skScene: self as SKScene)
        addChild(page_1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
    }
}
