import Foundation
import SpriteKit

class GameSettingUIManager: BaseUIManager{
    
    private var layerManager: LayerManager = .sharedInstance
    
    private var uiElementBuilder    : UIElementBuilder!
    private var sceneBuilder        : SceneBuilder!
    private var labelBuilder        : LabelBuilder!
    
    public var homeButton: Button!
    public var languageButtons: [Button] = []
    
    public var BGM_slideButton          : Button!
    public var SE_slideButton           : Button!
    public var HOW_TO_PLAY_GUIDE_panel  : Button!
    
    private var titleIcon           : SKSpriteNode!
    public var gameSettingPanel    : SKSpriteNode!
    
    override init(skScene: SKScene) {
        super.init(skScene: skScene)
        sceneBuilder        = SceneBuilder(currentSKScene: currentSKScene)
        uiElementBuilder    = UIElementBuilder(currentSKScene: skScene, baseUIManager: self)
        labelBuilder        = LabelBuilder()
        
        homeButton          = uiElementBuilder.Build(selectedButton: .menuButton)
        
        BGM_slideButton     = Button(DefaultImage: "soundSlideButton")
        SE_slideButton      = Button(DefaultImage: "soundSlideButton")
                BGM_slideButton.setScale(0.75)
                BGM_slideButton.position = CGPoint(x: -90, y: 800)
                BGM_slideButton.zPosition = 200
                
                SE_slideButton.setScale(0.75)
                SE_slideButton.position = BGM_slideButton.position
                SE_slideButton.position.y -= 300
                SE_slideButton.zPosition = 200
        
        HOW_TO_PLAY_GUIDE_panel = Button(DefaultImage: "howtoplayButton")
                HOW_TO_PLAY_GUIDE_panel.setScale(1)
                HOW_TO_PLAY_GUIDE_panel.position.y -= 1100
                HOW_TO_PLAY_GUIDE_panel.zPosition = 200
        
        titleIcon           = uiElementBuilder.Build(seletedUiIcon: .gameSettingIcon)
        gameSettingPanel    = SKSpriteNode(imageNamed: "gameSettingPanel")
        gameSettingPanel.SetParameter(pos: centerPosition, scale: 0.15, layer: layerManager.layer_0, alpha: 1)
        
        gameSettingPanel.addChild(BGM_slideButton)
        gameSettingPanel.addChild(SE_slideButton)
        gameSettingPanel.addChild(HOW_TO_PLAY_GUIDE_panel)
        
        currentSKScene.addChild(homeButton)
        currentSKScene.addChild(titleIcon)
        currentSKScene.addChild(gameSettingPanel)
       // currentSKScene.addChild(HOW_TO_PLAY_GUIDE_panel)
        
        for i in 0...2{
            let languageSelectionButton = Button(DefaultImage: "languageSelectionButtonOff")
            languageSelectionButton.SetParameter(pos: centerPosition, scale: 0.13, layer: layerManager.layer_2)
            languageSelectionButton.position.y -= 45
            languageSelectionButton.position.y -= CGFloat(i) * 60
            
            currentSKScene.addChild(languageSelectionButton)
            languageButtons.append(languageSelectionButton)
        }
        
        InitializeLabels()
        
        let titleLabel = labelBuilder.Build(selectedLabel: .titleLabel)
        titleLabel.setGlyphText("SETTING")
        titleLabel.zPosition = layerManager.layer_9
        titleLabel.position = centerPosition
        titleLabel.position.y += 290
        currentSKScene.addChild(titleLabel)
        
        SetUILayers()
    }
    
    func UpdateTouch(at location: CGPoint){
        if homeButton.contains(location){
            currentSKScene.view?.presentScene(sceneBuilder.Create(selectedScene: .mainScene))
        }
    }
    
    private func InitializeLabels(){
        let font = BMGlyphFont(name: "hd")
        
        let gameSettingTitle = BMGlyphLabel(txt: "Game Setting", fnt: font)
        gameSettingTitle.SetParameter(pos: centerPosition, scale: 1.1, layer: layerManager.layer_5)
        gameSettingTitle.position.y += 200
        
        let BGMLabel = BMGlyphLabel(txt: "BGM", fnt: font)
        BGMLabel.SetParameter(pos: centerPosition, scale: 0.8, layer: layerManager.layer_5)
        BGMLabel.position.x -= 75
        BGMLabel.position.y += 125
        
        let SELabel = BMGlyphLabel(txt: "SE", fnt: font)
        SELabel.SetParameter(pos: BGMLabel.position, scale: 0.8, layer: layerManager.layer_5)
        SELabel.position.y -= 45
        
        let languageSelectionTitle = BMGlyphLabel(txt: "Language Selection", fnt: font)
        languageSelectionTitle.SetParameter(pos: centerPosition, scale: 0.8, layer: layerManager.layer_5, alpha: 0.85)
        languageSelectionTitle.position.y += 10
        
        let EnglishButtonLabel = BMGlyphLabel(txt: "English", fnt: font)
        EnglishButtonLabel.SetParameter(pos: languageButtons[0].position, scale: 0.8, layer: layerManager.layer_6, alpha: 0.7)
        EnglishButtonLabel.zPosition = 100
        
        let JapaneseButtonLabel = BMGlyphLabel(txt: "Japanese", fnt: font)
        JapaneseButtonLabel.SetParameter(pos: languageButtons[1].position, scale: 0.8, layer: layerManager.layer_6, alpha: 0.7)
        
        let ThaiButtonLabel = BMGlyphLabel(txt: "Thai", fnt: font)
        ThaiButtonLabel.SetParameter(pos: languageButtons[2].position, scale: 0.8, layer: layerManager.layer_6, alpha: 0.7)

        currentSKScene.addChild(gameSettingTitle)
        currentSKScene.addChild(BGMLabel)
        currentSKScene.addChild(SELabel)
        currentSKScene.addChild(languageSelectionTitle)
        currentSKScene.addChild(EnglishButtonLabel)
        currentSKScene.addChild(JapaneseButtonLabel)
        currentSKScene.addChild(ThaiButtonLabel)
    }
    
    private func SetUILayers(){
        homeButton.zPosition        = layerManager.layer_9
        for button in languageButtons{
            button.zPosition = layerManager.layer_8
        }
        
        titleIcon.zPosition         = layerManager.layer_8
        gameSettingPanel.zPosition  = layerManager.layer_2
        
    }
    
}

extension SKNode{
    func SetParameter(pos: CGPoint, scale: CGFloat, layer: CGFloat, alpha: CGFloat){
        self.position = pos
        self.setScale(scale)
        self.zPosition = layer
        self.alpha = alpha
    }
    
    func SetParameter(pos: CGPoint, scale: CGFloat, layer: CGFloat){
        self.position = pos
        self.setScale(scale)
        self.zPosition = layer
    }
}

