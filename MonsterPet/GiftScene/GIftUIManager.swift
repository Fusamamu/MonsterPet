//
//  GIftUIManager.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 3/10/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class GiftUIManager: BaseUIManager{
    
    private var sceneBuilder        : SceneBuilder!
    private var uiElementBuilder    : UIElementBuilder!
    private var labelBuilder        : LabelBuilder!
    private var layerManager        : LayerManager = .sharedInstance
    
    var homeButton          : Button!
    var backButton          : Button!


    
    var titleIcon           : SKSpriteNode!
    var pageCountBar        : SKSpriteNode!


    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        
        sceneBuilder        = SceneBuilder(currentSKScene: skScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()

        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        backButton          = uiElementBuilder.Build(selectedButton: .backButton)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(backButton)
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if backButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .petInfoScene))
        }
    }
}
