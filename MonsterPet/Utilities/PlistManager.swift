//
//  PlistManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 27/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class PlistManager{
    
    var path: String!
    var dict: NSDictionary
    
    init() {
        path   = Bundle.main.path(forResource: "GameData", ofType: "plist")
        dict   = NSDictionary(contentsOfFile: path!)!
    }
    
    public func GetDictionary(by name: String) -> [String:Any]{
        let requestedDict = dict.object(forKey: name) as! [String:Any]
        return requestedDict
    }
    
    
   

}
