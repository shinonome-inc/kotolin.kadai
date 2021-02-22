import UIKit

class ViewController: UIViewController{
    
    var customView: CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showCustomViewButtonTapped(_ sender: Any) {
        
        customView = UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? CustomView
        
        customView.frame = view.frame
        
        customView.delegate = self
        
        view.addSubview(customView)
    }
    
}

extension ViewController: CustomDelegate {
    func closeCustomView() {
        customView.removeFromSuperview()
    }
    
}

