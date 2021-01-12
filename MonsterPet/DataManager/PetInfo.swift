//
//  PetInfo.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 8/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

struct PetInfo: Codable {
    var petName             : String
    var visitedCount        : Int
    var isFirstTime         : Bool
    var hasGivenSpecialItem : Bool
    
    var timeWhenPlaced      : CGFloat
    var timeWhenLeftScene   : CGFloat
    
    var isAdded             : Bool
    
    var scale               : CGFloat
    var position            : CGPoint
    
    var direction           : Int
    
    init(){
        petName                 = "Nil"
        visitedCount            = 0
        isFirstTime             = true
        hasGivenSpecialItem     = false
        timeWhenPlaced          = 0
        timeWhenLeftScene       = 0
        isAdded                 = false
        
        scale                   = 1
        position                = CGPoint(x: 0, y: 0)
        direction               = 0
    }
    
}
