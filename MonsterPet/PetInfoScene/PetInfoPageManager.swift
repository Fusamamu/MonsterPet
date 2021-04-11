//
//  PetInfoPageManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 8/11/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class PetInfoPageManager{
    static let sharedInstance = PetInfoPageManager();

    public var currentPage: PetInfoPage!
    public var pages: [PetInfoPage] = []
    
    var page_1: PetInfoPage!
    var page_2: PetInfoPage!
    var page_3: PetInfoPage!

    private init(){
       // LoadPetInfoPages()
    }

    public func LoadPetInfoPages(){
        page_1 = PetInfoPage(pageIndex: 0, itemIndex: 0)
        page_2 = PetInfoPage(pageIndex: 1, itemIndex: 3)
        page_3 = PetInfoPage(pageIndex: 2, itemIndex: 0)
        pages.append(contentsOf:[page_1, page_2, page_3])
        currentPage = pages[0]
    }
}
