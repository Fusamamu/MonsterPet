//
//  GiftPageManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 18/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class GiftPageManager{
    static let sharedInstance = GiftPageManager()
    let giftManager: GiftManager = .sharedInstance
    
    public var currentPage: GiftPage!
    
    public var  pages:[GiftPage] = []
    
    var page_1: GiftPage!
    
    private init(){
        
    }
    
    public func LoadGiftPage(){
        page_1 = GiftPage(pageIndex: 0, itemIndex: 0)
        page_1.name = "Page_NO.1"
        pages.append(contentsOf: [page_1])
        
        currentPage = pages[0]
    }
    
    public func UpdateItemCount(){
        for page in pages{
            for slot in page.slots{
                
            }
        }
    }
}
