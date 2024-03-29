//
//  RefreshManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 20/11/2563 BE.
//  Copyright © 2563 BE Sukum Duangpattra. All rights reserved.
//

import Foundation


class RefreshManager: NSObject {

    static let  shared          = RefreshManager()
    
    private let defaults        = UserDefaults.standard
    private let defaultsKey     = "lastRefresh"
    private let calender        = Calendar.current

    func loadDataIfNeeded(completion: (Bool) -> Void) {

//        if isRefreshRequired() {
//            // load the data
//            defaults.set(Date(), forKey: defaultsKey)
//            completion(true)
//        } else {
//            completion(false)
//        }
        
        if isRefreshRequired(passingMinute: 1) {
            // load the data
            defaults.set(Date(), forKey: defaultsKey)
            completion(true)
        } else {
            completion(false)
        }
    }

    private func isRefreshRequired() -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
            return true
        }

        if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 24 {
            return true
        } else {
            return false
        }
    }
    
    private func isRefreshRequired(userPickedHour: Int = 16) -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
            return true
        }

        if let diff = calender.dateComponents([.day], from: lastRefreshDate, to: Date()).day,
            let currentHour =  calender.dateComponents([.hour], from: Date()).hour,
            diff >= 1, userPickedHour <= currentHour {
            return true
        } else {
            return false
        }
    }
    
//    private func isRefreshRequired(passingHour: Int) -> Bool{
//
//        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
//            return true
//        }
//
//        if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 1 {
//            return true
//        } else {
//            return false
//        }
//    }
    
    private func isRefreshRequired(passingMinute: Int) -> Bool{
        
        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
            return true
        }

        if let diff = calender.dateComponents([.minute], from: lastRefreshDate, to: Date()).minute, diff > passingMinute {
            return true
        } else {
            return false
        }
    }
}
