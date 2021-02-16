//
//  AppDelegate.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 1/3/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import UIKit
import GoogleMobileAds



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // PetSaveDataManager.sharedInstance.LoadPetInSceneData()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
       // TimerManager.sharedInstance.passedTime = CFTimeInterval.init()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //TimerManager.sharedInstance.moveToBackGroundTime = Date.timeIntervalSinceReferenceDate
        //print(TimerManager.sharedInstance.moveToBackGroundTime)
        
//        for key in PetName.allCases{
//
//            var petInfo = PetInfo(petName: "none", visitedCount: 0, isFirstTime: true, hasGivenSpecialItem: false)
//            if let pet = PetManager.sharedInstance.petInStore[key] {
//                petInfo.petName                 = pet!.petName.rawValue
//                petInfo.isFirstTime             = pet!.isFirstTime
//                petInfo.hasGivenSpecialItem     = pet!.hasGivenSpecialItem
//                petInfo.visitedCount            = pet!.VisitedTime
//            }
//
//            let jsonData = try! JSONEncoder().encode(petInfo)
//            let saveData = String(data: jsonData, encoding: .utf8)
//            print(saveData!)
//        }
        
       // SaveNLoadManager.sharedInstance.SaveCurrencyData()
       /// SaveNLoadManager.sharedInstance.SaveCurrencyData()
        
        SaveNLoadManager.sharedInstance.SaveCurrencyData()
        PetSaveDataManager.sharedInstance.SavePetInSceneData()
        
        PetSaveDataManager.sharedInstance.SavePetInfo()
        
        UnpackStateDataManager.sharedInstance.SaveUnpackState()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //TimerManager.sharedInstance.startTime  = Date.timeIntervalSinceReferenceDate
        //print(TimerManager.sharedInstance.startTime)
       // print(timer)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
//        let petInfo = PetInfo(petName: "Peng", visitedCount: 2, isFirstTime: true, hasGivenSpecialItem: true)
//        let jsonData = try! JSONEncoder().encode(petInfo)
//        let saveData = String(data: jsonData, encoding: .utf8)!
//        print(saveData)
//
       
        
    }


}

