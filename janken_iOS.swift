enum HandType: Int {
    case rock = 0
    case scisser = 1
    case paper = 2
}

func janken(you: HandType) {
    let cp = Int.random(in: 0..<3)
    
    let result = (HandType.rock.rawValue, cp)
    var ans:Result
    
    enum Result {
        case draw
        case win
        case lose
    }
    
    switch result {
        
        case (let handid, let cphand) where handid == cphand: ans = Result.draw
        case (let handid, let cphand) where (handid+1)%3 == cphand: ans = Result.win
        default:ans = Result.lose
    }
    
    switch ans {
        case .draw: print("draw")
        case .win: print("win!")
        case .lose: print("lose...")
    }
    
}

janken(you: .rock)