//
//  GameData.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 27/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit



struct GameCurrency: Codable{
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

class SaveNLoadManager{
    
    static let sharedInstance = SaveNLoadManager()
    
    let currencyManager: CurrencyManager = .sharedInstance
    
    let subDir          = "SaveDatas"
    let currencyData    = "CurrencyData.txt"
    
    private init() {
           
    }
    
    public func SaveCurrencyData(){
        let codable_CurrencyData = GameCurrency(heart: currencyManager.HeartCounts, coin: currencyManager.CoinCounts)
        let json_CurrencyData    = EncodeGameData(data: codable_CurrencyData)!
        let data_CurrencyData    = json_CurrencyData.data(using: .utf8)
        
        createFileToURL(withData: data_CurrencyData, withName: currencyData, withSubDirectory: subDir)
        
        print(json_CurrencyData)
    }
    
    
    public func LoadCurrencyData(){
        let target_path = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let full_path   = target_path?.appendingPathComponent(subDir + "/" + currencyData)
        let loaded_currencyObject = DecodeGameData(from: full_path!, to: GameCurrency(heart: 0, coin: 0)) as! GameCurrency
        
        currencyManager.HeartCounts = loaded_currencyObject.heart
        currencyManager.CoinCounts = loaded_currencyObject.coin
        
    }
    public func DecodeGameData<T>(from fileUrl: URL, to dataType: T) -> Any? where T:Codable{
            
        let decoder = JSONDecoder()

        do {
            let saveData = try Data(contentsOf: fileUrl)
            let gameDataObj = try decoder.decode(T.self, from: saveData)
            
            return gameDataObj
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    
//    public func DecodeGameData2<T>(gameData: String,to dataType: T) -> Any? where T:Codable{
//        if let jsonData = gameData.data(using: .utf8){
//
//            let decoder = JSONDecoder()
//
//                do {
//                    let gameData = try decoder.decode(T.self, from: jsonData)
//                    return gameData
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//
//            return nil
//    }
    
    public func EncodeGameData<T>(data: T) -> String? where T:Codable{
        
        let encoder = JSONEncoder()
        
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(data.self)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                //print(jsonString)
                return jsonString
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    func removeDirectory (withDirectoryName originName:String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager = FileManager.default
        let path = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL = path.first?.appendingPathComponent(originName) {
            do {
                try fileManager.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
        
    func createDirectory(withFolderName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: directory, in: .userDomainMask)
        if let applicationSupportURL = urls.last {
            do{
                var newURL = applicationSupportURL
                newURL = newURL.appendingPathComponent(dest, isDirectory: true)
                try fileManager.createDirectory(at: newURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                print("error \(error)")
            }
        }
    }
    
    func createFile(withData data: Data?, withName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManager = FileManager.default
        if let destPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first {
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/")
            if let newFile = fullDestPath.appendingPathComponent(name)?.path {
            if(!fileManager.fileExists(atPath:newFile)){
                fileManager.createFile(atPath: newFile, contents: data, attributes: nil)
            }else{
                print("File is already created, or other error")
            }
            }
        }
    }
    
    func createFileToURL(withData data: Data?, withName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory)  {
        let fileManager = FileManager.default
        let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        if let fullDestPath = destPath?.appendingPathComponent(name), let data = data {
            do{
                try data.write(to: fullDestPath, options: .atomic)
            } catch let error {
                print ("error \(error)")
            }
        }
    }
    
    
    func createFileToURL(withData data: Data?, withName name: String, withSubDirectory subdir: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory)  {
        let fileManager = FileManager.default
        let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        createDirectory(withFolderName: subdir, toDirectory: directory)
        if let fullDestPath = destPath?.appendingPathComponent(subdir + "/" + name), let data = data {
            do{
                try data.write(to: fullDestPath, options: .atomic)
            } catch let error {
                print ("error \(error)")
            }
        }
    }
    
    func removeItem(withItemName originName:String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManger = FileManager.default
        let urls = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL = urls.first?.appendingPathComponent(originName) {
            do {
                try fileManger.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
    
    func removeItem(withItemName originName:String, withSubDirectory dir: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) {
        let fileManger = FileManager.default
        let urls = FileManager.default.urls(for: directory, in: .userDomainMask)
        if let originURL = urls.first?.appendingPathComponent(dir + "/" + originName) {
            do {
                try fileManger.removeItem(at: originURL)
            }
            catch let error {
                print ("\(error) error")
            }
        }
    }
    
    func writeStringToDirectory(string: String, withDestinationFileName dest: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory, withSubDirectory: String = "") {
        if let destPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first {
            createDirectory(withFolderName: withSubDirectory, toDirectory: directory)
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/" + withSubDirectory + "/" + dest)
            do {
                
                try string.write(to: fullDestPath as URL, atomically: true, encoding: .utf8)
            } catch let error {
                print ("error\(error)")
            }
        }
    }
    
    func copyDirect(withOriginName originName:String, withDestinationName destinationName: String) {
        let fileManager = FileManager.default
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let originURL = path.first?.appendingPathComponent(originName) {
            if let destinationURL = path.first?.appendingPathComponent(destinationName) {
                do {
                    try fileManager.copyItem(at: originURL, to: destinationURL)
                }
                catch let error {
                    print ("\(error) error")
                }
            }
        }
    }
    
    func createDataTempFile(withData data: Data?, withFileName name: String) -> URL? {
        if let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileManager = FileManager.default
            var itemReplacementDirectoryURL: URL?
            do {
                try itemReplacementDirectoryURL = fileManager.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: destinationURL, create: true)
            } catch let error {
                print ("error \(error)")
            }
            guard let destURL = itemReplacementDirectoryURL else {return nil}
            guard let data = data else {return nil}
            let tempFileURL = destURL.appendingPathComponent(name)
            do {
                try data.write(to: tempFileURL, options: .atomic)
                return tempFileURL
            } catch let error {
                print ("error \(error)")
                return nil
            }
        }
        return nil
    }
    
    func replaceExistingFile(withTempFile fileURL: URL?, existingFileName: String, withSubDirectory: String) {
        guard let fileURL = fileURL else {return}
        let fileManager = FileManager.default
        let destPath = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        if let fullDestPath = destPath?.appendingPathComponent(withSubDirectory + "/" + existingFileName) {
            
                do {
                    let dta = try Data(contentsOf: fileURL)
                    createDirectory(withFolderName: "\(withSubDirectory)", toDirectory: .applicationSupportDirectory)
                    try dta.write(to: fullDestPath, options: .atomic)
                }
                catch let error {
                    print ("\(error)")
                }
        }
    }
    
    func urlOfFileInDirectory(withFileName name: String, toDirectory directory: FileManager.SearchPathDirectory = .applicationSupportDirectory) -> URL? {
        if let destPath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first {
            let fullDestPath = NSURL(fileURLWithPath: destPath + "/" + name)
            return fullDestPath as URL
        }
        return nil
    }

    
}
