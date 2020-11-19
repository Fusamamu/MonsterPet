//
//  GiftManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 14/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

enum GiftName: String, CaseIterable{
    
    case origami = "Origami"
    case dutchShoe = "DutchShoes"
    
    
    static var count: Int { return GiftName.dutchShoe.hashValue + 1}
}

class GiftManager: Observable{
    
    static let sharedInstance = GiftManager()
    
    var observers: [Observer] = []

    
    public var m_GiftNumber:Int = 9
    public var Gifts: [Gift] = []
    
    public var giftUnlockState: [GiftName: Bool] = [:]
    
    private init(){
        InitializeGifts()
        InitializeGiftUnlockState()
    }
    
    func AddObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func RemoveObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }
    
    func NotifyAllObservers() {
        for observer in observers{
            observer.Update()
        }
    }
    
    private func InitializeGifts(){
        for _ in 0...m_GiftNumber - 1{
            let gift = Gift(index: 0)
            gift.setScale(0.25)
            gift.zPosition = 50
            Gifts.append(gift)
        }
    }
    
    private func InitializeGiftUnlockState(){
        for giftName in GiftName.allCases{
            giftUnlockState[giftName] = false
        }
    }
}
