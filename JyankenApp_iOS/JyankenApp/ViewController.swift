import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var enemy: UIImageView!

    var youHandType: Hand!
    var timer: Timer!
    var dispImageNo = 0
    var count = 0
    var jankenPlayCheck = false
    
    let enemyHand = [
        "rock",
        "scissors",
        "paper",
    ]
    
    enum Hand: Int {
        case rock = 0
        case scissors = 1
        case paper = 2
        
        func getImage() -> UIImage {
            
            switch self {
            case .rock: return #imageLiteral(resourceName: "rock")
            case .scissors: return #imageLiteral(resourceName: "scissors")
            case .paper: return #imageLiteral(resourceName: "paper")
            }
        }
    }
    
    enum Result: String {
        case draw = "draw"
        case win = "win!"
        case lose = "lose..."
    }
    
    @IBAction func rockButton(_ sender: Any) {
        if(jankenPlayCheck == false){
            timerStart()
            youHandType = Hand.rock
        }
    }
    
    @IBAction func scissorsButton(_ sender: Any) {
        if(jankenPlayCheck == false){
            timerStart()
            youHandType = Hand.scissors
        }
    }
    
    @IBAction func paperButton(_ sender: Any) {
        if(jankenPlayCheck == false){
            timerStart()
            youHandType = Hand.paper
        }
    }
    
    func timerStart() {
        
        jankenPlayCheck = true
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector:#selector(onTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    func displayImage() {
        
        if (timer != nil && count == 30) {
            timer.invalidate()
            jankenPlayCheck = false  
            count = 0
            dispImageNo = 0
            
            jankenPlay(you: youHandType)
            
        }else{
            
            switch dispImageNo {
            case 0:
                enemy.image = Hand.rock.getImage()
                dispImageNo += 1
            case 1:
                enemy.image = Hand.scissors.getImage()
                dispImageNo += 1
            case 2:
                enemy.image = Hand.paper.getImage()
                dispImageNo += 1
            default:
                dispImageNo = 0
            }
        }
    }
    
    func jankenPlay(you: Hand) {
        
        let cp = Int.random(in: Hand.rock.rawValue...Hand.paper.rawValue)
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
        
        count += 1
        displayImage()
    }
}
