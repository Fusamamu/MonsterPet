import Foundation
import SpriteKit

class TimerManager{
    
    
    static let sharedInstance = TimerManager()
    
    var currentTime: CFTimeInterval = 0
    
    var timerCountTarget: CFTimeInterval = 100
    var timerCount: CFTimeInterval = 0;
    
    
    private init(){
       // currentTime = Date.timeIntervalSinceReferenceDate
        
//        let date = Date()
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
        
    }
    
    func UpdateTimer(countTarget: CFTimeInterval){
        
        timerCount += 1
        
        if timerCount > timerCountTarget{
            print("Timer Reset")
            currentTime = Date.timeIntervalSinceReferenceDate
            timerCount = 0
        }
        
    }
    
    func FixedUpdate(every countTarget: CFTimeInterval){
        
        
    }
    
    
    func SetCurrentTime(){
        
        currentTime = Date.timeIntervalSinceReferenceDate
    }
    
}
