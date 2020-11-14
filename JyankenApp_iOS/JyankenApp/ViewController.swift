import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var enemy: UIImageView!
    
    let rock = UIImage(named:"rock")!
    let scissors = UIImage(named:"scissors")!
    let paper = UIImage(named:"paper")!
    var youhand: Hand!
    var timer: Timer!
    var dispImageNo = 0
    var count = 0
    var type = 0
    
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
    
    enum Result {
        case draw
        case win
        case lose
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
    }
    
    @IBAction func rockButton(_ sender: Any) {
        timerStart()
        type = 0
    }
    
    @IBAction func scissorsButton(_ sender: Any) {
        timerStart()
        type = 1
    }
    
    @IBAction func paperButton(_ sender: Any) {
        timerStart()
        type = 2
    }
    
    func timerStart(){
        timer = Timer.scheduledTimer(
        timeInterval: 0.3,
        target: self,
        selector:#selector(onTimer),
        userInfo: nil,
        repeats: true)
    }
    
    func displayImage() {
        
        if timer != nil && count == 4 {
            count = 0
            timer.invalidate()
            
            if(type == 0){
                jankenPlay(you: .rock)
            
            }else if(type == 1){
                jankenPlay(you: .scissors)
            
            }else if(type == 2){
                jankenPlay(you: .paper)
            }
            
        }else{
        
            if dispImageNo < 0 {
                dispImageNo = 2
            }
        
            if dispImageNo > 2 {
                dispImageNo = 0
            }
        
            let image = UIImage(named: enemyHand[dispImageNo])

            enemy.image = image
        }
    }
    
    func jankenPlay(you: Hand){
        
        let cp = Int.random(in: 0..<3)
        let ehand = UIImage(named: enemyHand[cp])
        let game = (you.rawValue, cp)
        var ans: Result
        
        print(cp)
        enemy.image = ehand
        
        switch game {
            case (let handId, let cpHand) where handId == cpHand: ans = Result.draw
            case (let handId, let cpHand) where (handId+1) % 3 == cpHand: ans = Result.win
            default:ans = Result.lose
        }
        
        switch ans {
            case .draw: result.text = "draw"
            case .win: result.text = "win!"
            case .lose: result.text = "lose..."
        }
    }
    
    @objc func onTimer() {
        
        dispImageNo += 1
        count += 1
        displayImage()
    }
}

