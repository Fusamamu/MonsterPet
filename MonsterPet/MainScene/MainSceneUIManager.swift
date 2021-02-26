import Foundation
import SpriteKit

class MainSceneUIManager : BaseUIManager{
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    
    enum MainSceneUIState {
        case allClosed
        case menuPanelOpened
    }
    
    public var uiState : MainSceneUIState = .allClosed

    var heartIcon       : SKSpriteNode!
    var currencyIcon    : SKSpriteNode!
    
    var bar_1           : SKSpriteNode!
    var bar_2           : SKSpriteNode!
    let barScale:CGFloat = 0.3
    

    var menuButton          : Button!
    var petInfoButton       : Button!
    var cameraButton        : Button!
    
    var buyFoodButton       : Button!
    var buyEquipmentButton  : Button!
    var buyNewSceneButton   : Button!
    var gameSettingButton   : Button!
    
    var menuPanel           : MainMenuPanel!
    var alphaBlack          : MainMenuPanel!
    
    var getBonusButton      : BonusPanel!
    

    override init(skScene: SKScene) {
        
        super.init(skScene: skScene)
        uiElementBuilder    = UIElementBuilder  (currentSKScene: skScene, baseUIManager: self)
        sceneBuilder        = SceneBuilder      (currentSKScene: skScene)
        
        heartIcon       = uiElementBuilder.Build(seletedUiIcon: .heart)
        currencyIcon    = uiElementBuilder.Build(seletedUiIcon: .coin)
        
        bar_1           = uiElementBuilder.Build(seletedUiElement: .bar)
        bar_2           = uiElementBuilder.Build(seletedUiElement: .bar)
        bar_2.position.y -= 45
        
        bar_1.addChild(heartIcon)
        bar_2.addChild(currencyIcon)
        
        menuButton      = uiElementBuilder.Build(selectedButton: .menuButton)
        petInfoButton   = uiElementBuilder.Build(selectedButton: .petInfoButton)
        cameraButton    = uiElementBuilder.Build(selectedButton: .cameraButton)
        

                currentSKScene.addChild(bar_1)
                currentSKScene.addChild(bar_2)
                currentSKScene.addChild(menuButton)
                currentSKScene.addChild(petInfoButton)
                currentSKScene.addChild(cameraButton)
       
        
        
        menuPanel = MainMenuPanel(panelImage: "MenuPanel", skScene: currentSKScene)
        menuPanel.setScale(0.15)
        menuPanel.zPosition = 50
        
                        alphaBlack = MainMenuPanel(panelImage: "AlphaBlack", skScene: currentSKScene)
                        alphaBlack.color = .black
                        alphaBlack.size = alphaBlack.texture!.size()
                        alphaBlack.setScale(1.5)
                        alphaBlack.zPosition = 49
                        alphaBlack.alpha = 0.3
        
        
        buyFoodButton       = uiElementBuilder.Build(selectedButton: .inMenuButton)
        buyEquipmentButton  = uiElementBuilder.Build(selectedButton: .inMenuButton)
        buyNewSceneButton   = uiElementBuilder.Build(selectedButton: .inMenuButton)
        gameSettingButton   = uiElementBuilder.Build(selectedButton: .inMenuButton)
        
        
        
        let buttons = [buyFoodButton, buyEquipmentButton, buyNewSceneButton, gameSettingButton]
        let padding:CGFloat = 80
        let offset_Y:CGFloat = 70
        
        for i in 0...buttons.count - 1{
            
            buttons[i]?.setScale(1.05)
            
            if i <= 1{
                let width = buttons[i]!.size.width
                buttons[i]!.position.x = CGFloat(i) * (width + padding) - (width + padding)/2
                buttons[i]!.position.y += buttons[i]!.size.height/2 - offset_Y
            }
            if i >= 2{
                let width = buttons[i]!.size.width
                buttons[i]!.position.x = CGFloat(i-2) * (width + padding) - (width + padding)/2
                buttons[i]!.position.y -= buttons[i]!.size.height/2 + padding + offset_Y
            }
        }
       
        menuPanel.addChild(buyFoodButton)
        menuPanel.addChild(buyEquipmentButton)
        menuPanel.addChild(buyNewSceneButton)
        menuPanel.addChild(gameSettingButton)
        
        let menuTitle = BMGlyphLabel(txt: "MENU", fnt: BMGlyphFont(name: "TitleText"))
        menuTitle.setScale(6)
        menuTitle.zPosition = 9
        menuTitle.position.y += 780
        menuPanel.addChild(menuTitle)
        
        let foodTitleLabel = BMGlyphLabel(txt: "FOOD", fnt: BMGlyphFont(name: "TitleText"))
        foodTitleLabel.setScale(4)
        foodTitleLabel.zPosition = 2000
        foodTitleLabel.position = buyFoodButton.position
        foodTitleLabel.position.y -= 150
        menuPanel.addChild(foodTitleLabel)
        
        let ToolTitleLabel = BMGlyphLabel(txt: "TOOL", fnt: BMGlyphFont(name: "TitleText"))
        ToolTitleLabel.setScale(4)
        ToolTitleLabel.zPosition = 2000
        ToolTitleLabel.position = buyEquipmentButton.position
        ToolTitleLabel.position.y -= 150
        menuPanel.addChild(ToolTitleLabel)
        
        let ScenarioTitelLabel = BMGlyphLabel(txt: "SCENE", fnt: BMGlyphFont(name: "TitleText"))
        ScenarioTitelLabel.setScale(4)
        ScenarioTitelLabel.zPosition = 2000
        ScenarioTitelLabel.position = buyNewSceneButton.position
        ScenarioTitelLabel.position.y -= 150
        menuPanel.addChild(ScenarioTitelLabel)
        
        let GameSettingLabel = BMGlyphLabel(txt: "SETTING", fnt: BMGlyphFont(name: "TitleText"))
        GameSettingLabel.setScale(4)
        GameSettingLabel.zPosition = 2000
        GameSettingLabel.position = gameSettingButton.position
        GameSettingLabel.position.y -= 150
        menuPanel.addChild(GameSettingLabel)
        
        
        //Shoudl refac?
        menuButton.SubscribeButton(target: menuPanel)
        menuButton.SubscribeButton(target: alphaBlack)

        SetInMenuButtons()
        SetUILayers()
        
        
        getBonusButton = BonusPanel(panelImage: "getBonusPanel", skScene: currentSKScene)
        menuButton.SubscribeButton(target: getBonusButton)
      
        
        
        
    }
    
    func UpdateTouch(at location: CGPoint){
        
        switch uiState {
            
            case .allClosed:
                
                if menuButton != nil && menuButton.contains(location){
//                    currentSKScene.run(SoundManager.sharedInstanced.Play(by: .interfaceClick))
//
                    SoundManager.sharedInstanced.Play_SE(by: SoundName.interfaceClick.rawValue)
                    menuButton.OnClicked(at: location)
                    uiState = .menuPanelOpened
                }
            
                if petInfoButton != nil && petInfoButton.contains(location){
//                    currentSKScene.run(SoundManager.sharedInstanced.Play(by: .interfaceClick)){
//                        self.currentSKScene.view?.presentScene(self.sceneBuilder.Create(selectedScene: .petInfoScene))
//                    }
//                    
                    SoundManager.sharedInstanced.Play_SE(by: SoundName.interfaceClick.rawValue)
                    
                    self.currentSKScene.view?.presentScene(self.sceneBuilder.Create(selectedScene: .petInfoScene))
                }
                
                
            
            case .menuPanelOpened:
                
                if !(menuPanel.closeButton.buttonDelegates?.last is BonusPanel){
                    menuPanel.closeButton.SubscribeButton(target: getBonusButton)
                }
                
                let menuPanelLocation = currentSKScene.convert(location, to: menuPanel)
                
                if menuPanel.closeButton != nil && menuPanel.closeButton.contains(menuPanelLocation){
                    menuPanel.closeButton.SubscribeButton(target: alphaBlack)
                    menuPanel.closeButton.OnClicked(at: menuPanelLocation)
                    uiState = .allClosed
                }

                if buyFoodButton != nil && buyFoodButton.contains(menuPanelLocation){
                    currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .foodMenuScene))
                }
                
                if buyEquipmentButton != nil && buyEquipmentButton.contains(menuPanelLocation){
                    currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .equipmentScene))
                }
            
                if buyNewSceneButton != nil && buyNewSceneButton.contains(menuPanelLocation){
                    currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .scenarioShopScene))
                }
            
                if gameSettingButton != nil && gameSettingButton.contains(menuPanelLocation){
                    currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .gameSettingScene))
                }
                
                
        }
    }
    
    private func SetInMenuButtons(){
        let foodIcon            = SKSpriteNode(imageNamed: "FoodIcon")
        let equipmentIcon       = SKSpriteNode(imageNamed: "EquipmentIcon")
        let scenarioIcon        = SKSpriteNode(imageNamed: "ScenarioIcon")
        let gameSettingIcon     = SKSpriteNode(imageNamed: "GameSettingIcon")
        
        let iconScale: CGFloat = 0.55
        
        foodIcon.setScale(iconScale)
        equipmentIcon.setScale(iconScale)
        scenarioIcon.setScale(iconScale)
        gameSettingIcon.setScale(iconScale)
        
        foodIcon.zPosition = 200
        equipmentIcon.zPosition = 200
        scenarioIcon.zPosition = 200
        gameSettingIcon.zPosition = 200
        
        buyFoodButton.addChild(foodIcon)
        buyEquipmentButton.addChild(equipmentIcon)
        buyNewSceneButton.addChild(scenarioIcon)
        gameSettingButton.addChild(gameSettingIcon)
    }
    
    private func SetUILayers(){
        menuButton.zPosition = 8
        petInfoButton.zPosition = 8
    }
}


