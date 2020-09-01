//
//  UnpackPanel.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 2/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

enum UnpackMenuName: String, CaseIterable{
    case green      = "GreenUnpackMenu"
    case yellow     = "YellowUnpackMenu"
    case orange     = "OrangeUnpackMenu"
    case purple     = "PurpleUnpackMenu"
}

class UnpackPanel: Panel {
    
    public var unpackButton: Button!
    public var cancelButton: Button!
    
    public var alphaBlackPanel: Panel!
    
    private var index: Int!
    
    init(index: Int, skScene: SKScene){
        self.index = index
        super.init(panelImage: UnpackMenuName.green.rawValue, skScene: skScene)
        self.setScale(0.23)
        self.zPosition = 50;
        
        
        alphaBlackPanel = Panel(panelImage: "AlphaBlack", skScene: skScene)
        alphaBlackPanel.zPosition = 49
        alphaBlackPanel.position = CGPoint(x: self.position.x, y: self.position.y)
        alphaBlackPanel.color = .black
        alphaBlackPanel.size = alphaBlackPanel.texture!.size()
        alphaBlackPanel.setScale(1.5)
        alphaBlackPanel.alpha = 0.5
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func AddButtons() {
        unpackButton = Button(DefaultImage: "UnpackButton", PressedImage: "UnpackButton", skScene: currentSKscene)
        unpackButton.zPosition = 60
        unpackButton.setScale(0.23)
        unpackButton.position = CGPoint(x: currentSKscene.frame.midX, y: currentSKscene.frame.midY)
        unpackButton.position.x -= 50
        unpackButton.position.y -= 60
        unpackButton.SubscribeButton(target: self)
        unpackButton.SubscribeButton(target: alphaBlackPanel)
        
        currentSKscene.addChild(unpackButton)
        
        
        cancelButton = Button(DefaultImage: "UnpackCancelButton", PressedImage: "UnpackCancelButton", skScene: currentSKscene)
        cancelButton.zPosition = 60
        cancelButton.setScale(0.23)
        cancelButton.position = CGPoint(x: currentSKscene.frame.midX, y: currentSKscene.frame.midY)
        cancelButton.position.x += 50
        cancelButton.position.y -= 60
        cancelButton.SubscribeButton(target: self)
        cancelButton.SubscribeButton(target: alphaBlackPanel)
        
        currentSKscene.addChild(cancelButton)
    }
    
    override func RemoveAllButtonReferences() {
        cancelButton.UnsubscribeButton()
        cancelButton.removeFromParent()
        cancelButton = nil;
        
        unpackButton.UnsubscribeButton()
        unpackButton.removeFromParent()
        unpackButton = nil;
    }
    
    func GetUnpackMenuImageName(by index: Int) -> String{
        var unpackMenuName = ""
        
        if index < 6{
            unpackMenuName = UnpackMenuName.green.rawValue
        }else if index >= 6 && index < 12 {
            unpackMenuName = UnpackMenuName.yellow.rawValue
        }else if index >= 12 && index < 18 {
            unpackMenuName = UnpackMenuName.orange.rawValue
        }else if index >= 18{
            unpackMenuName = UnpackMenuName.purple.rawValue
        }
        
        return unpackMenuName
    }
    
}
