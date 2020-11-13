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
}
