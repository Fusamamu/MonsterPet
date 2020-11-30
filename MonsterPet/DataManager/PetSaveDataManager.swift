//
//  DataManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 8/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class PetSaveDataManager{
    
    static let sharedInstance = PetSaveDataManager()
    
    let save_N_load : SaveNLoadManager      = .sharedInstance
    let petManager  : PetManager            = .sharedInstance
    
    //Sub-Directory to store SAVE DATA//
    let subDir              = "PetInSceneData"
    let petInfoData_subdir  = "PetInfoData"
    //--------------------------------//
    
    var petInfo_Default: PetInfo!
    
    private init(){
        petInfo_Default = PetInfo()
    }
    
    func Save(){
        
    }
    
    func Load(){
        
    }
    
    func SavePetInSceneData(){
        
        for pet in petManager.petInScene{
            
            if let u_pet = pet{
                
                var petInfo = PetInfo()
                petInfo.petName                     = u_pet.petName.rawValue
                petInfo.visitedCount                = u_pet.VisitedTime
                petInfo.isFirstTime                 = u_pet.isFirstTime
                petInfo.hasGivenSpecialItem         = u_pet.hasGivenSpecialItem
                petInfo.timeWhenPlaced              = CGFloat(u_pet.timeWhenPlaced)
               //  petInfo.timeWhenLeftScene   = CGFloat(u_pet.timeWhenLeftScene)
                petInfo.isAdded                     = u_pet.isAdded
                
                let json    = SaveNLoadManager.sharedInstance.EncodeGameData(data: petInfo)
                let data    = json?.data(using: .utf8)
                let path    = "PetInScene_name_" + u_pet.petName.rawValue + ".txt"
                
//                save_N_load.createFileToURL(withData: data, withName: path, withSubDirectory: subDir)
            }
        }
    }
    
    func LoadPetInSceneData(){
       // var loadedPets: [Pet] = []
        
        for petName in PetName.allCases{
            
            let target_path = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let full_path = target_path?.appendingPathComponent(subDir + "/" +  "PetInScene_name_" + petName.rawValue + ".txt")
            
            guard let loadedPet = save_N_load.DecodeGameData(from: full_path!, to: petInfo_Default) as? PetInfo else { return }
            
            if loadedPet.isAdded {
                let petName: PetName = PetName(rawValue: loadedPet.petName)!
                let pet = Pet(petName: petName)
                
                //should know only if the pet is added to scene or not
                //Other data for pet should be save regularly from sigleton
                
            }
        }
    }
    
    func SavePetInfo(){
        
        for key in PetName.allCases{
            
            if let pet = petManager.petInStore[key]{
                var petInfo = PetInfo()
                
                petInfo.petName             = pet!.petName.rawValue
                petInfo.position            = pet!.position
                
                petInfo.isAdded             = pet!.isAdded
                petInfo.visitedCount        = pet!.VisitedTime
                petInfo.isFirstTime         = pet!.isFirstTime
                petInfo.hasGivenSpecialItem = pet!.hasGivenSpecialItem
                
                petInfo.timeWhenPlaced      = (CGFloat)(pet!.timeWhenPlaced)
                petInfo.timeWhenLeftScene   = (CGFloat)(pet!.timeWhenLeftScene)
                
                let json_petInfo    = save_N_load.EncodeGameData(data: petInfo)
                let data_petInfo    = json_petInfo?.data(using: .utf8)
                
                                    print(json_petInfo!)
                
                let FULLPATH = pet!.petName.rawValue + "_InfoData.txt"
                
                save_N_load.createFileToURL(withData: data_petInfo, withName: FULLPATH, withSubDirectory: petInfoData_subdir)
            }
        }
    }
    
    func LoadPetInfo(){
        
        for key in PetName.allCases{
            
            let target_path = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let FULLPATH    = target_path?.appendingPathComponent(petInfoData_subdir + "/" + key.rawValue + "_InfoData.txt")
            
            guard let loaded_petInfo_Obj = save_N_load.DecodeGameData(from: FULLPATH!, to: PetInfo()) as? PetInfo else { return }
            
            petManager.petInStore[key]!!.VisitedTime                = loaded_petInfo_Obj.visitedCount
            petManager.petInStore[key]!!.isFirstTime                = loaded_petInfo_Obj.isFirstTime
            petManager.petInStore[key]!!.hasGivenSpecialItem        = loaded_petInfo_Obj.hasGivenSpecialItem
            petManager.petInStore[key]!!.timeWhenPlaced             = (CFTimeInterval)( loaded_petInfo_Obj.timeWhenPlaced)
            petManager.petInStore[key]!!.timeWhenLeftScene          = (CFTimeInterval)( loaded_petInfo_Obj.timeWhenLeftScene)
            petManager.petInStore[key]!!.isAdded                    = loaded_petInfo_Obj.isAdded
            
            petManager.petInStore[key]!!.position                   = loaded_petInfo_Obj.position
        }
    }
    
    func LoadPetInScene(){
        
        petManager.petInScene.removeAll()
        
        for key in PetName.allCases{
            if let pet = petManager.petInStore[key]{
                if pet!.isAdded {
                    pet?.setScale(0.1)
                    //petManager.currentScene?.addChild(pet!)
                    petManager.petInScene.append(pet)
                }
            }
        }
    }
}
