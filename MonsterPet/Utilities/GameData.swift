//
//  GameData.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 27/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit



let myString = """
{
    "heart":0,
    "coin":0
}
"""


struct GameData: Codable{
    
    var heart: Int
    var coin: Int
    
    enum CodingKeys: String, CodingKey {
        case heart
        case coin
    }
    
    

}

struct ItemInventoryQuantity: Codable{
    var item0: Int
    var item1: Int
    
    enum CodingKeys: String, CodingKey {
        case item0
        case item1
    }
}

class SaveLoadGameData{
    
    
    
    init() {
           
    }
    
    
    public func LoadGameData(){
        if let jsonData = myString.data(using: .utf8){
                   let decoder = JSONDecoder()
                   
                   do {
                       let gameData = try decoder.decode(GameData.self, from: jsonData)
                       print(gameData.heart)
                       print(gameData.coin)
                   } catch  {
                       print(error.localizedDescription)
                   }
               }
    }
    
    public func SaveGameData(){
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        var gameData = GameData(heart: 0, coin: 0)
        gameData.coin = 10
        gameData.heart = 15
        

        do {
            let jsonData = try encoder.encode(gameData)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
}
