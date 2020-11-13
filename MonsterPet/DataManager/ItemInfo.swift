//
//  ItemInfo.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 8/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

struct ItemInfo: Codable{
    var Name        : String
    var Index       : Int
    var Count       : String
    
    var isUnlocked  : Bool
    var isBeingEaten: Bool
    
    var timeWhenPlace   : CFTimeInterval
    var timeOnScreen    : CFTimeInterval
}
