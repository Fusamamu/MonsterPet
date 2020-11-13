//
//  GiftPage.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 3/10/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class GiftPage: Page{
    
    var slots: [GiftSlot] = []
    
    let row: Int = 2
    let column: Int = 2
    
    let slotOffset_X: CGFloat = 83
    let slotOffset_Y: CGFloat = 508
    
    let slotScale       : CGFloat = 0.15
    let slotZposition   : CGFloat = 40
    let slotPadding     : CGFloat = 5
    
    init(pageIndex: Int, itemIndex: Int, skScene: SKScene){
        super.init(index: pageIndex, skScene: skScene)
        self.GenerateSlots(from: itemIndex)
    }
    
    init(pageIndex: Int, itemIndex: Int){
        super.init(index: pageIndex)
        self.GenerateSlots(from: itemIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func GenerateSlots(from index: Int){
        
        var indexCount: Int = index
        
        for y in 0...column{
            for x in 0...row{
                let slot = GiftSlot(index: indexCount,skScene: currentSKScene)
                let x = slotOffset_X + CGFloat(x) * slot.lockImage.size().width/slotPadding
                let y = slotOffset_Y - CGFloat(y) * slot.lockImage.size().height/slotPadding
                slot.position = CGPoint(x: x, y: y)
                slot.setScale(slotScale)
                slot.zPosition = slotZposition
                self.addChild(slot)
            
                indexCount += 1
                slots.append(slot)
            }
        }
    }
}
