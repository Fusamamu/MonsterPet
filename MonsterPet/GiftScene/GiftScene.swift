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
    
    private let giftPageManager: GiftPageManager = .sharedInstance
    
    private var uiManager   : GiftUIManager!
    unowned var currentPage : GiftPage!
    
    var currentPageIndex: Int = 0
    
    override func didMove(to view: SKView) {
        uiManager = GiftUIManager(skScene: self)
        
        currentPage = giftPageManager.pages[currentPageIndex]
        addChild(currentPage)
        
        CreateBackground()
    }
    
    override func willMove(from view: SKView) {
        currentPage.removeFromParent()
        currentPage = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        uiManager.UpdateTouch(at: location!)
    }
    
    func CreateBackground(){
        let backgroundTexture = SKTexture(imageNamed: "giftInfoBackground")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let scale: CGFloat = 0.4
            background.zPosition = -30
            background.setScale(scale)
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (backgroundTexture.size().width*scale * CGFloat(i)) , y: 0)
            self.addChild(background)
            
            let moveLeft    = SKAction.moveBy(x: -backgroundTexture.size().width*scale, y: 0, duration: 20)
            let moveReset   = SKAction.moveBy(x: backgroundTexture.size().width*scale, y: 0, duration: 0)
            let moveLoop    = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
}
