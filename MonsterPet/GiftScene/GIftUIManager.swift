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

    
    public var dialogueLabel: BMGlyphLabel!

    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        
        sceneBuilder        = SceneBuilder(currentSKScene: skScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()

        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        backButton          = uiElementBuilder.Build(selectedButton: .backButton)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(backButton)
        
        AddTitleIcon()
        AddDialogue()
        AddDialogueLabel()
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
        
        if backButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .petInfoScene))
        }
    }
    
    private func AddTitleIcon(){
        let titleIcon = uiElementBuilder.Build(seletedUiIcon: .giftIcon)
        currentSKScene.addChild(titleIcon)
        //need to link with iconBuilder!!!! see example in other UIscene
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("GIFT")
        titleLabel.zPosition = 20
        titleLabel.setScale(0.8)
        titleLabel.position = titleIcon.position
        titleLabel.position.x += 40
        titleLabel.position.y -= 30
        currentSKScene.addChild(titleLabel)
    }
    
    private func AddDialogue(){
        let _dialogue = SKSpriteNode(imageNamed: "giftDialogue")
        _dialogue.zPosition = 50
        _dialogue.setScale(0.17)
        _dialogue.position = centerPosition
        _dialogue.position.y -= 200
        currentSKScene.addChild(_dialogue)
    }
    
    private func AddDialogueLabel(){
        dialogueLabel = BMGlyphLabel(txt: "Collected gifts from all pets.", fnt: BMGlyphFont(name: "hd"))
        dialogueLabel.setHorizontalAlignment(.centered)
        dialogueLabel.position = centerPosition
        dialogueLabel.position.y -= 190
        dialogueLabel.zPosition = 200
        dialogueLabel.setScale(0.7)
        currentSKScene.addChild(dialogueLabel)
    }
}
