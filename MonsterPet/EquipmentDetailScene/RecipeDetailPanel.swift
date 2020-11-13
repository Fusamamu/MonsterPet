//
//  RecipeDetailPanel.swift
//  MonsterPet
//
//  Created by Sukum Duangpattra on 17/7/2563 BE.
//  Copyright © 2563 Sukum Duangpattra. All rights reserved.
//

import Foundation
import SpriteKit

class RecipeDetailPanel: Panel{
    
    public var currentEquipmentIndex: Int!
    
    public var closeButton: Button!
    
    private var coin: SKSpriteNode!
    
    public var coinRequirementLabel: BMGlyphLabel!
    public var ingredientLabels: [BMGlyphLabel] = []
    public var quantityLabels: [BMGlyphLabel] = []
      
    override func AddButtons(){
        closeButton = Button(DefaultImage: "CloseButton", PressedImage: "Button", skScene: currentSKscene)
        closeButton.setScale(1.7)
        closeButton.zPosition = 10
        closeButton.position = CGPoint(x: 1100, y: 1000)
        closeButton.SubscribeButton(target: self)
        self.addChild(closeButton)
        
        
    }
    
    override func AddLabels() {
        for _ in 0...3{
            let quantityLabel = LabelBuilder().Build(selectedLabel: .itemCountLabel)
            quantityLabel.position = CGPoint(x: 0, y: 0)
            quantityLabel.setScale(1.8)
            quantityLabel.zPosition = LayerManager.sharedInstance.layer_9
            quantityLabel.setGlyphText("x5")
            
            quantityLabels.append(quantityLabel)
            if quantityLabels.count <= 4{
                self.addChild(quantityLabel)
            }
            
            let ingredientLabel = LabelBuilder().Build(selectedLabel: .equipmentNameLabel)
            ingredientLabel.setScale(5)
            ingredientLabel.zPosition = LayerManager.sharedInstance.layer_9
            ingredientLabel.setGlyphText("Potato")
            
            ingredientLabels.append(ingredientLabel)
            if ingredientLabels.count <= 4{
                self.addChild(ingredientLabel)
            }
        }
            
        let x1: CGFloat = -650
        let x2: CGFloat = x1 + 1000
        let y1: CGFloat = 200
        let y2: CGFloat = y1 - 350
        
        quantityLabels[0].position = CGPoint(x: x1, y: y1)
        quantityLabels[1].position = CGPoint(x: x1, y: y2)
        quantityLabels[2].position = CGPoint(x: x2, y: y1)
        quantityLabels[3].position = CGPoint(x: x2, y: y2)
        
        
        for i in 0...3{
            ingredientLabels[i].position = quantityLabels[i].position
            ingredientLabels[i].position.x += 250
            ingredientLabels[i].position.y += 70
        }
        
        coinRequirementLabel = BMGlyphLabel(txt: "300", fnt: BMGlyphFont(name: "TitleText"))
        coinRequirementLabel.position = CGPoint(x: 640, y: -760)
        coinRequirementLabel.setScale(2)
        coinRequirementLabel.zPosition = LayerManager.sharedInstance.layer_9
        self.addChild(coinRequirementLabel)
    }
    
    override func AddImages() {
        coin = SKSpriteNode(imageNamed: "currencyIcon")
        coin.position = CGPoint(x: -820, y: -700)
        coin.setScale(0.75)
        coin.zPosition = LayerManager.sharedInstance.layer_9
        self.addChild(coin)
        
        for i in 0...3{
            let requiredItemImage = SKSpriteNode(imageNamed: "Potato")
            requiredItemImage.position = quantityLabels[i].position
            requiredItemImage.position.x -= 115
            requiredItemImage.position.y += 75
            requiredItemImage.setScale(0.4)
            requiredItemImage.zPosition = LayerManager.sharedInstance.layer_8
            self.addChild(requiredItemImage)
        }
    }
    
    
    override func UpdateLabels() {
        //have to update selected ingredient based on selected menu
        
        //current equipment?
        let Nabe                   = GetEquipmentDicData()["Nabe"] as! [String:Any]
        //current selected Ingredient?
        let IngredientRequirements = Nabe["IngredientRequirements"] as! [String:Any]
        let selectedRecipe         = IngredientRequirements["SalmonNabe"] as! [String:Any]
        
        let keys = ["quantity-1", "quantity-2", "quantity-3", "quantity-4"]
        
        for i in 0...keys.count - 1 {
            let quantity = selectedRecipe[keys[i]] as! Int
            quantityLabels[i].setGlyphText("x\(String(describing: quantity))")
        }
    
        let coinRequirement = selectedRecipe["coin"] as! Int
        coinRequirementLabel.setGlyphText("\(String(describing: coinRequirement))")
        
        //Ingregient label need to be updated
    }
    
    override func UpdateImages() {
        
    }
    
    override func Open(){
        self.position = CGPoint(x: currentSKscene.frame.midX, y: currentSKscene.frame.midY)
        
        AddButtons()
        AddLabels()
        AddImages()
        
        UpdateLabels()
        UpdateImages()
        
        currentSKscene.addChild(self)
        isOpened = true
        
        self.run(SKEase.scale(easeFunction: .curveTypeExpo, easeType: .easeTypeInOut, time: 0.68, from: 0.2, to: 0.13))
    }
    
    override func RemoveAllButtonReferences(){
        closeButton.removeFromParent()
        closeButton = nil
        
        coin.removeFromParent()
        coin = nil
        
        for i in 0...quantityLabels.count - 1{
            quantityLabels[i].removeFromParent()
        }
        
        quantityLabels.removeAll()
    }
    
    private func GetEquipmentDicData() -> [String:Any]{
        let path                = Bundle.main.path(forResource: "GameData", ofType: "plist")
        let dict:NSDictionary   = NSDictionary(contentsOfFile: path!)!
        let equipmentDict       = dict.object(forKey: "Equipments") as! [String:Any]
        return equipmentDict
    }
    


}
