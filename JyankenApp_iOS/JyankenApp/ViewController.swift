import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var enemy: UIImageView!

    var youhand: Hand!
    var timer: Timer!
    var dispImageNo = 0
    var count = 0
    var type = 0
    var flag = 0
    
    let enemyHand = [
    "rock",
    "scissors",
    "paper",
    ]
    
    enum Hand: Int{
        case rock = 0
        case scissors = 1
        case paper = 2
    }
    
    enum Result: String {
        case draw = "draw"
        case win = "win!"
        case lose = "lose..."
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
    }
    
    @IBAction func rockButton(_ sender: Any) {
        if(flag == 0){
            timerStart()
            type = Hand.rock.rawValue
        }
    }
    
    @IBAction func scissorsButton(_ sender: Any) {
        if(flag == 0){
            timerStart()
            type = Hand.scissors.rawValue
        }
    }
    
    @IBAction func paperButton(_ sender: Any) {
        if(flag == 0){
            timerStart()
            type = Hand.paper.rawValue
        }
    }
    
    func timerStart(){
        flag = 1
        
        timer = Timer.scheduledTimer(
        timeInterval: 0.3,
        target: self,
        selector:#selector(onTimer),
        userInfo: nil,
        repeats: true)
    }
    
    func displayImage() {
        
        if timer != nil && count == 4 {
            timer.invalidate()
            flag = 0
            count = 0
            
            if(type == Hand.rock.rawValue){
                jankenPlay(you: .rock)
            
            }else if(type == Hand.scissors.rawValue){
                jankenPlay(you: .scissors)
            
            }else if(type == Hand.paper.rawValue){
                jankenPlay(you: .paper)
            }
            
        }else{
        
            if dispImageNo < Hand.rock.rawValue {
                dispImageNo = Hand.paper.rawValue
            }
        
            if dispImageNo > Hand.paper.rawValue {
                dispImageNo = Hand.rock.rawValue
            }
            
            enemy.image = UIImage(named: enemyHand[dispImageNo])
        }
    }
    
    func jankenPlay(you: Hand){
        
        let cp = Int.random(in: Hand.rock.rawValue..<3)
        let game = (you.rawValue, cp)
        
        print(cp)
        enemy.image = UIImage(named: enemyHand[cp])
        
        switch game {
        case (let handId, let cpHand) where handId == cpHand: result.text = Result.draw.rawValue
        case (let handId, let cpHand) where (handId+1) % 3 == cpHand: result.text = Result.win.rawValue
        default:result.text = Result.lose.rawValue
        }
    }
    
    @objc func onTimer() {
        
        dispImageNo += 1
        count += 1
        displayImage()
    }
}
