//
//  UnpackStateDataManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 16/2/2564 BE.
//  Copyright © 2564 BE Sukum Duangpattra. All rights reserved.
//

import Foundation

class UnpackStateDataManager{
    
    static let sharedInstance = UnpackStateDataManager()
    
    let save_N_load : SaveNLoadManager = .sharedInstance
    
    let itemManager     : ItemManager       = .sharedInstance
    let equipmentManager: EquipmentManager  = .sharedInstance
    
    let unpackState_subDir  = "UnpackStateData"
    
            var UnpackStateInfo_Default = UnpackStateInfo()
            
            struct UnpackStateInfo: Codable {
                var itemUnpackState: [Int: Bool]
                var equipmentUnpackState: [Int: Bool]
                
                init() {
                    itemUnpackState         = [:]
                    equipmentUnpackState    = [:]
                }
            }
    
    private init(){
        
    }
    
    public func SaveUnpackState(){
        
        var unpackState = UnpackStateInfo()
        unpackState.itemUnpackState      = itemManager.slotUpdateUnpackState
        unpackState.equipmentUnpackState = equipmentManager.slotUpdateUnpackState
        
        let json = save_N_load.EncodeGameData(data: unpackState)
        let data = json?.data(using: .utf8)
        let path = "EquipmentUnpackStateData.txt"
        
        save_N_load.createFileToURL(withData: data, withName: path, withSubDirectory: unpackState_subDir)
        
    }
    
    public func LoadUnpackState() {
        let target_path = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let full_path = target_path?.appendingPathComponent(unpackState_subDir + "/" +  "EquipmentUnpackStateData.txt")
        
        guard let loadedEquipmentUnpackData = save_N_load.DecodeGameData(from: full_path!, to: UnpackStateInfo_Default) as? UnpackStateInfo else { return }
        
        itemManager.slotUpdateUnpackState       = loadedEquipmentUnpackData.itemUnpackState
        equipmentManager.slotUpdateUnpackState  = loadedEquipmentUnpackData.equipmentUnpackState
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
