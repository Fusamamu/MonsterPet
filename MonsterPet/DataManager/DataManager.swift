//
//  DataManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 8/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class DataManager{
    static let sharedInstance = DataManager()
    
    public var petInfos_JasonData: [Codable] = []
    
    private init(){
        
    }
    
    func Save(){
        
    }
    
    func SavePetInfo(){
        for key in PetName.allCases{
            
            if let pet = PetManager.sharedInstance.petInStore[key]{
                var petInfo = PetInfo(petName: "none", visitedCount: 0, isFirstTime: true, hasGivenSpecialItem: false)
                petInfo.petName                 = pet!.petName.rawValue
                petInfo.isFirstTime             = pet!.isFirstTime
                petInfo.hasGivenSpecialItem     = pet!.hasGivenSpecialItem
                let jsonData = try! JSONEncoder().encode(petInfo)
                petInfos_JasonData.append(jsonData)
            }
        }
    }
    
    func Load(){
        
    }
    
    func LoadPetInfo(){
        for json in petInfos_JasonData{
            let saveData = String(data: json as! Data, encoding: .utf8)
            print(saveData!)
        }
    }
    

    
}
