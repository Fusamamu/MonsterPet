//
//  TextAnimation.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 2/8/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class TextAnimation: Observer{
    
    var id: Int = 0
    
    private let currencyManager: CurrencyManager = .sharedInstance
    
    private var previousHeartCount  : Int!
    private var newHeartCount       : Int!
    private var previousCoinCoint   : Int!
    private var newCoinCount        : Int!
    
    public var currentSKScene: SKScene!
    
    private var font            : BMGlyphFont!
    private var currencyLabel   : BMGlyphLabel!
    
    enum LabelCase{
        case HeartLabel_Plus
        case HeartLabel_Minus
        case CoinLabel_Plus
        case CoinLabel_Minus
    }
    
    init(skScene: SKScene) {
        currentSKScene = skScene
        
        font            = BMGlyphFont(name: "TitleText")
        currencyLabel   = BMGlyphLabel(txt: "+10", fnt: font)
        currencyLabel.position = CGPoint(x: currentSKScene.frame.midX, y: currentSKScene.frame.midY)
        currencyLabel.zPosition = 200
        
        previousHeartCount = currencyManager.HeartCounts
        previousCoinCoint  = currencyManager.CoinCounts
    }
    
    func Update() {
        newHeartCount = currencyManager.HeartCounts
        newCoinCount  = currencyManager.CoinCounts
        
        var coinAmount = newCoinCount - previousCoinCoint
        if coinAmount < 0{
            coinAmount *= -1
        }
        
        var heartAmount = newHeartCount - previousHeartCount
        if heartAmount < 0{
            heartAmount *= -1
        }
        
        if newHeartCount > previousHeartCount {
            PopUpCurrencyLabel(labelCase: .HeartLabel_Plus, amount: heartAmount)
            previousHeartCount = newHeartCount
        }else if newHeartCount < previousHeartCount{
            
        }
        
        if newCoinCount > previousCoinCoint {
            PopUpCurrencyLabel(labelCase: .CoinLabel_Plus, amount: coinAmount)
            previousCoinCoint = newCoinCount
        }else if newCoinCount < previousCoinCoint{
            PopUpCurrencyLabel(labelCase: .CoinLabel_Minus, amount: coinAmount)
            previousCoinCoint = newCoinCount
        }
    }
    
    private func PopUpCurrencyLabel(labelCase: LabelCase, amount: Int){
 
        let label = BMGlyphLabel(txt: "+" + String(amount), fnt: BMGlyphFont(name: "TitleText"))
        label.setScale(0.85)
        label.zPosition = 200
        
        switch labelCase {
            case .HeartLabel_Plus:
                label.setGlyphText("+" + String(amount))
                label.position = CGPoint(x: 155, y: 600)
                currentSKScene.addChild(label)
                label.run(PopUp_PlusAnimation(), completion: { self.currencyLabel.removeFromParent() })
            case .HeartLabel_Minus:
                label.setGlyphText("-" + String(amount))
                label.position = CGPoint(x: 155, y: 600)
                currentSKScene.addChild(label)
                label.run(PopUp_MinusAnimation(), completion: { self.currencyLabel.removeFromParent() })
            case .CoinLabel_Plus:
                label.setGlyphText("+" + String(amount))
                label.position = CGPoint(x: 155, y: 570)
                currentSKScene.addChild(label)
                label.run(PopUp_PlusAnimation(), completion: { self.currencyLabel.removeFromParent() })
            case.CoinLabel_Minus:
                label.setGlyphText("-" + String(amount))
                label.position = CGPoint(x: 155, y: 600)
                currentSKScene.addChild(label)
                label.run(PopUp_MinusAnimation(), completion: { self.currencyLabel.removeFromParent() })
        }
    }
    
    private func PopUp_PlusAnimation() -> SKAction{
        let popup   = SKAction.moveBy(x: 0, y: 30, duration: 0.7)
        let fadeOut = SKAction.fadeOut(withDuration: 0.7)
        return SKAction.group([popup, fadeOut])
    }
    
    private func PopUp_MinusAnimation() -> SKAction{
        let popup   = SKAction.moveBy(x: 0, y: -30, duration: 0.7)
        let fadeOut = SKAction.fadeOut(withDuration: 0.7)
        return SKAction.group([popup, fadeOut])
    }
    
}
