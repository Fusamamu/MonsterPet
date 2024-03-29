//
//  CoreObjectManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 1/12/2563 BE.
//  Copyright © 2563 BE Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class CoreObjectManager{
    
    static let  sharedInstance = CoreObjectManager()
    
    let petMG           : PetManager           = .sharedInstance
    let itemMG          : ItemManager          = .sharedInstance
    let equipmentMG     : EquipmentManager     = .sharedInstance
    let packageMG       : PackageManager       = .sharedInstance
    
    let placeHolderMG   : PlaceHolderManager   = .sharedInstance

    private init (){

    }
    
    private func InitializeData(){
        
    }
    
    public func ScanObjects(at currentTime: CFTimeInterval){
        ScanItems(at: currentTime)
        ScanPets(at: currentTime)
        ScanEquipment(at: currentTime)
    }
    
    public func UpdateTouch(at location: CGPoint){
        petMG.UpdateTouch(at: location)
        packageMG.UpdateTouch(at: location)
    }

    
    func ScanItems(at currentTime: CFTimeInterval){
        
        let point = placeHolderMG.pointData[Int.random(in: 0...4)]
        guard let checkingItem = itemMG.itemData[point]?.item else { return }
        
        let elapsedTime = currentTime - checkingItem.timeWhenPlaced
        
        for pet in petMG.petInStore.values{
            
            if pet!.timeWhenLeftScene == 0{
                if !(pet!.isAdded){
                    petMG.Call(pet!,to: point,for: checkingItem, elapsedTime: elapsedTime)
                    break;
                }
            }else{
                let nextCallelapsedTime = currentTime - pet!.timeWhenLeftScene
            
                if nextCallelapsedTime > pet!.waitTime + 10{
                    if !(pet!.isAdded) {
                        petMG.Call(pet!,to: point,for: checkingItem, elapsedTime: elapsedTime)
                        break;
                    }
                }
            }
        }
        
        if !(checkingItem.isBeingEaten) && elapsedTime > checkingItem.timeOnScreen {
            petMG.Remove(item: checkingItem, at: elapsedTime)
        }
        
    }
    
    func ScanEquipment(at currentTime: CFTimeInterval){
        let point = placeHolderMG.pointData[Int.random(in: 0...4)]
        guard let checkingEquipment = equipmentMG.equipmentData[point]?.equipment else { return }
        
        let elapsedTime = currentTime - checkingEquipment.timeWhenPlaced
        
        
        for pet in petMG.petInStore.values{
            
            if pet!.timeWhenLeftScene == 0{
                if !(pet!.isAdded){
                    petMG.Call(pet!,to: point,for: checkingEquipment, elapsedTime: elapsedTime)
                    break;
                }
            }else{
                let nextCallelapsedTime = currentTime - pet!.timeWhenLeftScene
            
                if nextCallelapsedTime > pet!.waitTime + 10{
                    if !(pet!.isAdded) {
                        petMG.Call(pet!,to: point,for: checkingEquipment, elapsedTime: elapsedTime)
                        break;
                    }
                }
            }
        }
        
        if !(checkingEquipment.isBeingEaten) && elapsedTime > checkingEquipment.timeOnScreen {
           // petMG.Remove(item: checkingItem, at: elapsedTime)
            equipmentMG.Remove(equipment: checkingEquipment, at: elapsedTime)
        }
    }
    
    
    
    func ScanPets(at currentTime: CFTimeInterval){
            
        //if petMG.petInScene.count != 0{
        guard petMG.petInScene.count != 0 else { return }
        
        for i in 0...petMG.petInScene.count - 1{

            guard let checkingPet = petMG.petInScene[i] else { continue }

            if checkingPet.isAdded{
                let elapsedTime = currentTime - checkingPet.timeWhenPlaced

                // Logic to give Heart and Pakage HERE!!!
                checkingPet.AddFloatingHeartPopUp(waitTime: elapsedTime)


                if checkingPet.nowEatingItem != nil {
                    checkingPet.DropItemPackage(at: checkingPet.nowEatingItem.position, whenTimePassed: elapsedTime)
                    petMG.Remove(item: checkingPet.nowEatingItem, at: elapsedTime)
                }
                
                if checkingPet.nowEatingEquipment != nil {
                    checkingPet.DropItemPackage(at: checkingPet.nowEatingEquipment.position, whenTimePassed: elapsedTime)
                    equipmentMG.Remove(equipment: checkingPet.nowEatingEquipment, at: elapsedTime)
                }
               
                petMG.Remove(pet: checkingPet, at_Index: i, at: elapsedTime)
               
                //packageMG.packageInScene.append(checkingPet.dropPackage)


                
            }
        }
        ///}
        
        petMG.petInScene = petMG.petInScene.filter({ $0 != nil })
    }
    
    public func ScanEquipments(at currentTime: CFTimeInterval){
        
    }
    
    public func ScanPackages(at currentTime: CFTimeInterval){
        
    }
    
    
}
