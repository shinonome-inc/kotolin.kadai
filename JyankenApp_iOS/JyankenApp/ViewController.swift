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
    
    let enemyHand = [
    "rock",
    "scissors",
    "paper",
    ]
    
    @IBAction func rockButton(_ sender: Any) {
        jyankenPlay(you: .rock)
    }
    
    @IBAction func scissorsButton(_ sender: Any) {
        jyankenPlay(you: .scissors)
    }
    
    @IBAction func paperButton(_ sender: Any) {
        jyankenPlay(you: .paper)
    }
    
    func displayImage() {
        
        if dispImageNo < 0 {
            dispImageNo = 2
        }
        
        if dispImageNo > 2 {
            dispImageNo = 0
        }
        
        let hand = enemyHand[dispImageNo]
        let image = UIImage(named: hand)

        enemy.image = image
    }
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector:#selector(onTimer),
            userInfo: nil,
            repeats: true)
    }
    
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
    
    func jyankenPlay(you: Hand){
        
        let cp = Int.random(in: 0..<3)
        let ehand = UIImage(named: enemyHand[cp])
        let game = (you.rawValue, cp)
        var ans: Result
        
        
        if timer != nil{
            timer.invalidate()
        }
        
        print(cp)
        enemy.image = ehand
        
        switch game {
            case (let handid, let cphand) where handid == cphand: ans = Result.draw
            case (let handid, let cphand) where (handid+1) % 3 == cp: ans = Result.win
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
        displayImage()
    }
}

