enum HandType: Int {
    case rock = 0
    case scissors = 1
    case paper = 2
}

func janken(you: HandType) {
    let cp = Int.random(in: 0..<3)
    
    let result = (you.rawValue, cp)
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
    
    switch cp {
        case 0: print("cp:rock.")
        case 1: print("cp:scissors.")
        case 2: print("cp:paper.")
        default: print("error")
    }
    
    switch ans {
        case .draw: print("you draw")
        case .win: print("you win!")
        case .lose: print("you lose...")
    }
    
}

janken(you: .rock)
janken(you: .scissors)
janken(you: .paper)