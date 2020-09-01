import Foundation
import SpriteKit


protocol Observer{
    var id: Int { get }
    func Update()
}

protocol Observable{
    
    var observers: [Observer] { get set }
    
    func AddObserver(observer: Observer)
    func RemoveObserver(observer: Observer)
    func NotifyAllObservers()
}

class CurrencyManager: Observable{
  
    static let sharedInstance = CurrencyManager()
    
    var observers: [Observer] = []
    
    public var HeartCounts: Int {
        get{
            return heartCounts
        }
        set(value){
            if value >= 1000{
                heartCounts = 999
            }else{
                heartCounts = value
            }
        }
    }

    
    public var CoinCounts : Int{
        get {
            return coinCounts
        }
        
        set(value) {
            if value >= 1000{
                coinCounts = 999
            }else{
                coinCounts = value
            }
        }
    }
    
    private var heartCounts: Int = 300{
        didSet{
            NotifyAllObservers()
        }
    }
    
    private var coinCounts: Int = 100{
        didSet{
            NotifyAllObservers()
        }
    }
    
    private init(){
      
    }
    
    func AddObserver(observer: Observer) {
        observers.append(observer)
    }
    
    func RemoveObserver(observer: Observer) {
        observers = observers.filter({$0.id != observer.id})
    }

    func NotifyAllObservers() {
        for observer in observers{
            observer.Update()
        }
    }
}
