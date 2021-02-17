//
//  UnpackStateDataManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 16/2/2564 BE.
//  Copyright © 2564 BE Sukum Duangpattra. All rights reserved.
//

import Foundation

class InventoryDataManager{
    
    private var isLoaded: Bool = false
    
    static let sharedInstance = InventoryDataManager()
    
    let save_N_load : SaveNLoadManager = .sharedInstance
    
    let itemManager     : ItemManager       = .sharedInstance
    let equipmentManager: EquipmentManager  = .sharedInstance
    
    let unpackState_subDir  = "UnpackStateData"
    
            var UnpackStateInfo_Default = InventoryInfo()
            
            //may have to change name to include info both unpack state and inventory counts;
            struct InventoryInfo: Codable {
                var itemUnpackState: [Int: Bool]
                var equipmentUnpackState: [Int: Bool]
                
                var itemCountInventoryData: [String: Int]
                var recipeCountInventoryData: [String:Int]
                
                init() {
                    itemUnpackState         = [:]
                    equipmentUnpackState    = [:]
                    
                    itemCountInventoryData  = [:]
                    recipeCountInventoryData = [:]
                }
            }
    
    private init(){
        
    }
    
    public func SaveUnpackState(){
        
        var inventoryInfo = InventoryInfo()
        
        inventoryInfo.itemUnpackState      = itemManager.slotUpdateUnpackState
        inventoryInfo.equipmentUnpackState = equipmentManager.slotUpdateUnpackState
        
        for (itemName,count) in itemManager.itemCountInventory {
            inventoryInfo.itemCountInventoryData[itemName.rawValue] = count
        }
        for (recipeName,count) in equipmentManager.RecipeCountInventory {
            inventoryInfo.recipeCountInventoryData[recipeName.rawValue] = count
        }
        
        let json = save_N_load.EncodeGameData(data: inventoryInfo)
        let data = json?.data(using: .utf8)
        let path = "EquipmentUnpackStateData.txt"
        
        save_N_load.createFileToURL(withData: data, withName: path, withSubDirectory: unpackState_subDir)
        
    }
    
    public func LoadUnpackState() {
        
        if !isLoaded {
            let target_path = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let full_path = target_path?.appendingPathComponent(unpackState_subDir + "/" +  "EquipmentUnpackStateData.txt")
            
            guard let loadedEquipmentUnpackData = save_N_load.DecodeGameData(from: full_path!, to: UnpackStateInfo_Default) as? InventoryInfo else { return }
            
            itemManager.slotUpdateUnpackState       = loadedEquipmentUnpackData.itemUnpackState
            equipmentManager.slotUpdateUnpackState  = loadedEquipmentUnpackData.equipmentUnpackState
            
            for (itemName, count) in loadedEquipmentUnpackData.itemCountInventoryData{
                itemManager.itemCountInventory[ItemName(rawValue: itemName)!] = count
            }
            for (recipeName, count) in loadedEquipmentUnpackData.recipeCountInventoryData{
                equipmentManager.RecipeCountInventory[RecipeName(rawValue: recipeName)!] = count
            }
            
            isLoaded = true
        }
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
