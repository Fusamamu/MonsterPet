//
//  Gift.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 14/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class Gift: SKSpriteNode, Observable{
    
    public var observers: [Observer] = []
    public var giftName: GiftName!
    public var giftImage: SKTexture!
    public var giftIndex: Int!
    
    public var isUnlock: Bool = false { didSet { NotifyAllObservers() } }
    
    init(index: Int) {
        giftIndex = index   
        giftImage = SKTexture(imageNamed: GiftName.allCases[index].rawValue)
        giftName  = GiftName.allCases[index]
        
        super.init(texture: giftImage, color: .clear, size: giftImage.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
