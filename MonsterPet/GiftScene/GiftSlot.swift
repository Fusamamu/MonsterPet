//
//  GiftSlot.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 3/10/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class GiftSlot: SKSpriteNode, Observer{
    
    var id: Int = 0;

    public var currectSKScene: SKScene!
    public var slotDelegates: [ButtonDelegate]?
   
    public var isLock      : Bool  = true
    public var isSelected  : Bool  = false
    public var isTouchable : Bool  = true
    
    public  var slotIndex                : Int!

    private(set) var slotImage   : SKTexture!
    private(set) var lockImage   : SKTexture!
    
    private var slotScale: CGFloat = 0.17


    init(index: Int, skScene: SKScene){
        slotDelegates   = []
        slotIndex       = index
        currectSKScene  = skScene

        slotImage = SKTexture(imageNamed: "giftSlot")
        lockImage = SKTexture(imageNamed: "giftSlot")
        
        super.init(texture: lockImage, color: .clear, size: slotImage.size())
        self.setScale(slotScale)
        self.zPosition = 40
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func Update() {
    }
    
    func SubscribeButton(target: ButtonDelegate){
        slotDelegates?.append(target)
    }
    
    func UnsubscribeButton(){
        slotDelegates?.removeAll()
    }
    
    func OnClicked(at location: CGPoint){
        if self.contains(location){
            for delegate in slotDelegates!{
                delegate.Invoked()
            }
        }
    }
}
