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
    
    private var font: BMGlyphFont!
    private var currencyLabel: BMGlyphLabel!
    
    enum LabelCase{
        case HeartLabel
        case CoinLabel
    }
    
    
    init(skScene: SKScene) {
        currentSKScene = skScene
        
        font            = BMGlyphFont(name: "petText")
        currencyLabel   = BMGlyphLabel(txt: "+10", fnt: font)
        currencyLabel.position = CGPoint(x: currentSKScene.frame.midX, y: currentSKScene.frame.midY)
        currencyLabel.zPosition = 200
        
        previousHeartCount = currencyManager.HeartCounts
        previousCoinCoint  = currencyManager.CoinCounts
    }
    
    
    func Update() {
        newHeartCount = currencyManager.HeartCounts
        newCoinCount  = currencyManager.CoinCounts
        
        
        if newCoinCount > previousCoinCoint {
            PopUpCurrencyLabel(labelCase: .CoinLabel)
            
            previousCoinCoint = newCoinCount
        }
        
        if newHeartCount > previousHeartCount {
            
            PopUpCurrencyLabel(labelCase: .HeartLabel)
            previousHeartCount = newHeartCount
        }
        
        
    }
    
    
    private func PopUpCurrencyLabel(labelCase: LabelCase){
        let popup   = SKAction.moveBy(x: 0, y: 30, duration: 0.7)
        let fadeOut = SKAction.fadeOut(withDuration: 0.7)
        let popupNFadeOut = SKAction.group([popup, fadeOut])
        
        
        let label = BMGlyphLabel(txt: "+10", fnt: BMGlyphFont(name: "petText"))
        label.setScale(0.4)
        label.zPosition = 200
        
        label.position = CGPoint(x: 155, y: 570)
        
        
        switch labelCase {
            case .HeartLabel:
                label.position = CGPoint(x: 155, y: 600)
            case .CoinLabel:
                label.position = CGPoint(x: 155, y: 570)
        }
        
        
        currentSKScene.addChild(label)
        label.run(popupNFadeOut, completion: { self.currencyLabel.removeFromParent() })
        
        
    }
    
    
}
