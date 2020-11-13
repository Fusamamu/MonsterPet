import Foundation
import SpriteKit

class UIElementBuilder{
    
    public var currentSKScene       : SKScene!
    public var baseUIManager        : BaseUIManager!
    
    private(set) var defaultUi_Scale      : CGFloat = 0.18
    private(set) var defaultUi_Zposition  : CGFloat = 10
    
    private(set) var iconScale          : CGFloat = 0.13
    private(set) var iconZPosition      : CGFloat = 21
    
    private(set) var buttonScale        : CGFloat = 0.18
    private(set) var buttonZPosition    : CGFloat = 20
    
    
    enum UiButtons{
        case menuButton
        case inMenuButton
        case petInfoButton
        case backButton
        case buyHeartButton
        case giftButton
        case cameraButton
        case nextPageLeftButton
        case nextPageRightButton
        case sliderButton
        case placeItemButton
        case buyItemButton
        case makeItemButton
    }
    
    //    enum UiPanels{
    //        case mainMenuPanel
    //        case alphaBlack
    //    }
    
    enum UiIcons {
        case heart
        case coin
        case petInfoTitleIcon
        case foodTitleIcon
        case equipmentTitleIcon
        case scenarioTitleIcon
        case gameSettingIcon
    }
    
    enum UiElements{
        case bar
        case bottomBar
        case pageCountBar
        case dialogueBox
        case inventoryBackground
        case gridBackground
        case verticalPageSliderBar
    }
    
//    enum SceneSelectionPanels: CaseIterable {
//        case publicPark
//        case comingSoon
//        static var count: Int { return SceneSelectionPanels.comingSoon.hashValue + 1}
//    }
    
//    enum PetInfoUI{
//        case petInfoPanel
//    }
    
    init(currentSKScene: SKScene, baseUIManager: BaseUIManager){
        self.currentSKScene = currentSKScene
        self.baseUIManager = baseUIManager
    }
    
    public func Build(selectedButton: UiButtons) -> Button{
        
        switch selectedButton {
        case .menuButton:
            let menuButton = Button(DefaultImage: "HomeButtonYellow")
            menuButton.setScale(buttonScale)
            menuButton.zPosition = buttonZPosition
            
            menuButton.position = baseUIManager.upperRightPosition
            menuButton.position.x -= 50
            menuButton.position.y -= 50
            
            return menuButton
            
        case .inMenuButton:
            let inMenuButton = Button(DefaultImage: "InMenuButton")
            inMenuButton.setScale(1.0)
            inMenuButton.zPosition = buttonZPosition
            return inMenuButton
            
        case .petInfoButton:
            let petInfoButton = Button(DefaultImage: "PetInfoButton")
            petInfoButton.setScale(buttonScale)
            petInfoButton.zPosition = buttonZPosition
            
            petInfoButton.position = baseUIManager.upperRightPosition
            petInfoButton.position.x -= 100
            petInfoButton.position.y -= 50
            
            return petInfoButton
            
        case .backButton:
            let backButton = Button(DefaultImage: "BackButton")
            backButton.setScale(buttonScale)
            backButton.zPosition = buttonZPosition
            
            backButton.position = baseUIManager.upperRightPosition
            backButton.position.x -= 100
            backButton.position.y -= 50
            
            return backButton
            
        case .buyHeartButton:
            let buyHeartButton = Button(DefaultImage: "BuyHeartButtonWhite")
            buyHeartButton.setScale(buttonScale)
            buyHeartButton.zPosition = buttonZPosition
            
            buyHeartButton.position = baseUIManager.upperRightPosition
            buyHeartButton.position.x -= 100
            buyHeartButton.position.y -= 50
            
            return buyHeartButton
        case .giftButton:
            let giftButton = Button(DefaultImage: "GiftButton")
            giftButton.setScale(buttonScale)
            giftButton.zPosition = buttonZPosition
            
            giftButton.position = baseUIManager.upperRightPosition
            giftButton.position.x -= 100
            giftButton.position.y -= 50
            return giftButton
            
        case .cameraButton:
            let cameraButton = Button(DefaultImage: "CameraButton")
            cameraButton.setScale(buttonScale)
            cameraButton.zPosition = buttonZPosition
            cameraButton.position = baseUIManager.lowerLeftPosition
            cameraButton.position.x += 50
            cameraButton.position.y += 50
            return cameraButton
    
        case .nextPageLeftButton:
            let nextPageLeftButton = Button(DefaultImage: "NextPageLeftButtonGreen")
            nextPageLeftButton.setScale(0.12)
            nextPageLeftButton.zPosition = buttonZPosition
            nextPageLeftButton.position.x = baseUIManager.mid_X - 55
            nextPageLeftButton.position.y = 30
            return nextPageLeftButton
        
        case .nextPageRightButton:
            let nextPageRightButton = Button(DefaultImage: "NextPageRightButtonGreen")
            nextPageRightButton.setScale(0.12)
            nextPageRightButton.zPosition = buttonZPosition
            nextPageRightButton.position.x = baseUIManager.mid_X + 55
            nextPageRightButton.position.y = 30
            return nextPageRightButton
            
        case .sliderButton:
            let sliderButton = Button(DefaultImage: "sliderButton")
            sliderButton.setScale(0.15)
            sliderButton.zPosition = buttonZPosition
            sliderButton.position.x = baseUIManager.max_X - 50
            sliderButton.position.y = baseUIManager.mid_Y
            return sliderButton
        case .placeItemButton:
            let placeItemButton = Button(DefaultImage: "placeItemButton")
            placeItemButton.setScale(0.13)
            placeItemButton.zPosition = defaultUi_Zposition + 1
            placeItemButton.position = baseUIManager.lowerRightPosition
            placeItemButton.position.x -= 50
            placeItemButton.position.y += 38
            return placeItemButton
        case .buyItemButton:
            let buyItemButton = Button(DefaultImage: "buyItemButton")
            buyItemButton.setScale(0.13)
            buyItemButton.zPosition = defaultUi_Zposition + 1
            buyItemButton.position = baseUIManager.lowerLeftPosition
            buyItemButton.position.x += 50
            buyItemButton.position.y += 38
            return buyItemButton
        case .makeItemButton:
            let makeItemButton = Button(DefaultImage: "makeItemButton")
            makeItemButton.setScale(0.13)
            makeItemButton.zPosition = defaultUi_Zposition + 1
            makeItemButton.position = baseUIManager.lowerLeftPosition
            makeItemButton.position.x += 115
            makeItemButton.position.y += 38
            return makeItemButton
        }
        
    }
    
    public func Build(seletedUiIcon: UiIcons) -> SKSpriteNode{
        switch seletedUiIcon {
        case .heart:
            let heart = SKSpriteNode(imageNamed: "Heart")
            heart.setScale(iconScale)
            heart.zPosition = iconZPosition
            heart.position = baseUIManager.upperLeftPosition
            heart.position.x += 50
            heart.position.y -= 30
            return heart
        case .coin:
            let coin = SKSpriteNode(imageNamed: "currencyIcon")
            coin.setScale(iconScale)
            coin.zPosition = iconZPosition
            coin.position = baseUIManager.upperLeftPosition
            coin.position.x += 50
            coin.position.y -= 73
            return coin
        case.petInfoTitleIcon:
            let petInfoTitleIcon = SKSpriteNode(imageNamed: "petInfoIcon")
            petInfoTitleIcon.setScale(0.092)
            petInfoTitleIcon.zPosition = defaultUi_Zposition
            petInfoTitleIcon.position = baseUIManager.upperLeftPosition
            petInfoTitleIcon.position.x += 60
            petInfoTitleIcon.position.y -= 45
            return petInfoTitleIcon
        case .foodTitleIcon:
            let foodTitleIcon = SKSpriteNode(imageNamed: "FoodIcon")
            foodTitleIcon.setScale(0.092)
            foodTitleIcon.zPosition = defaultUi_Zposition
            foodTitleIcon.position = baseUIManager.upperLeftPosition
            foodTitleIcon.position.x += 60
            foodTitleIcon.position.y -= 45
            return foodTitleIcon
        case .equipmentTitleIcon:
            let equipmentTitleIcon = SKSpriteNode(imageNamed: "EquipmentIcon")
            equipmentTitleIcon.setScale(0.092)
            equipmentTitleIcon.zPosition = defaultUi_Zposition
            equipmentTitleIcon.position = baseUIManager.upperLeftPosition
            equipmentTitleIcon.position.x += 60
            equipmentTitleIcon.position.y -= 45
            return equipmentTitleIcon
        case .scenarioTitleIcon:
            let scenarioTitleIcon = SKSpriteNode(imageNamed: "ScenarioIcon")
            scenarioTitleIcon.setScale(0.092)
            scenarioTitleIcon.zPosition = defaultUi_Zposition
            scenarioTitleIcon.position = baseUIManager.upperLeftPosition
            scenarioTitleIcon.position.x += 60
            scenarioTitleIcon.position.y -= 45
            return scenarioTitleIcon
        case .gameSettingIcon:
            let gameSettingIcon = SKSpriteNode(imageNamed: "GameSettingIcon")
            gameSettingIcon.setScale(0.092)
            gameSettingIcon.zPosition = defaultUi_Zposition
            gameSettingIcon.position = baseUIManager.upperLeftPosition
            gameSettingIcon.position.x += 60
            gameSettingIcon.position.y -= 45
            return gameSettingIcon
        
            
        }
    }
    
    public func Build(seletedUiElement: UiElements) -> SKSpriteNode{
        switch seletedUiElement {
        case .bar:
            let bar = SKSpriteNode(imageNamed: "bar")
            bar.anchorPoint = CGPoint(x: 0, y: 0)
            bar.setScale(0.3)
            bar.zPosition = defaultUi_Zposition
            bar.position = baseUIManager.upperLeftPosition
            bar.position.x += 22
            bar.position.y -= 60
            return bar
        case .bottomBar:
            let bottomBar = SKSpriteNode(imageNamed: "bottomBar")
            bottomBar.setScale(0.15)
            bottomBar.zPosition = defaultUi_Zposition
            bottomBar.position = baseUIManager.centerPosition
            bottomBar.position.y -= 300
            return bottomBar
        case .pageCountBar:
            let pageCountBar = SKSpriteNode(imageNamed: "pageBar1")
            pageCountBar.setScale(0.15)
            pageCountBar.zPosition = defaultUi_Zposition
            pageCountBar.position.x = baseUIManager.mid_X
            pageCountBar.position.y += 29
            return pageCountBar
        case .dialogueBox:
            let dialogueBox = SKSpriteNode(imageNamed: "DialogueBox")
            dialogueBox.setScale(0.15)
            dialogueBox.zPosition = defaultUi_Zposition
            dialogueBox.position = baseUIManager.centerPosition
            dialogueBox.position.y -= 200
            return dialogueBox
        case .inventoryBackground:
            let inventoryBackground = SKSpriteNode(imageNamed: "inventoryBackgroundBlownWithPattern")
            inventoryBackground.setScale(0.16)
            inventoryBackground.zPosition = defaultUi_Zposition
            inventoryBackground.position = baseUIManager.centerPosition
            inventoryBackground.position.y += 140
            return inventoryBackground
        case .gridBackground:
            let gridBackground = SKSpriteNode(imageNamed: "GridBackgroundGreenTheme")
            gridBackground.setScale(0.15)
            gridBackground.zPosition = defaultUi_Zposition + 1
            gridBackground.position = baseUIManager.centerPosition
            gridBackground.position.y += 86
            return gridBackground
        case .verticalPageSliderBar:
            let verticalPageSliderBar = SKSpriteNode(imageNamed: "sliderBar")
            verticalPageSliderBar.setScale(0.15)
            verticalPageSliderBar.zPosition = defaultUi_Zposition
            verticalPageSliderBar.position.x = baseUIManager.max_X - 50
            verticalPageSliderBar.position.y = baseUIManager.mid_Y
            return verticalPageSliderBar
        }
    }
    
    
//    public func Build(selectedSceneSelectionPanel: SceneSelectionPanels) -> ScenarioSlot{
//        switch selectedSceneSelectionPanel {
//        case .publicPark:
//            let publicParkPanel = ScenarioSlot(slotImageNamed: "publicPark")
//            publicParkPanel.setScale(0.15)
//            publicParkPanel.zPosition = defaultUi_Zposition
//            return publicParkPanel
//        case .comingSoon:
//            let comingSoonPanel = ScenarioSlot(slotImageNamed: "comingSoon")
//            comingSoonPanel.setScale(0.15)
//            comingSoonPanel.zPosition = defaultUi_Zposition
//            return comingSoonPanel
//
//        }
//    }
//    public func Build(selectedPetInfoUI: PetInfoUI) -> SKSpriteNode{
//        switch selectedPetInfoUI {
//        case .petInfoPanel:
//            let petInfoPanel = SKSpriteNode(imageNamed: "petInfoPanel")
//            petInfoPanel.setScale(0.15)
//            petInfoPanel.zPosition = defaultUi_Zposition
//            return petInfoPanel
//        }
//    }
}
