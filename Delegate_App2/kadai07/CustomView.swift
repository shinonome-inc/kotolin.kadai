import UIKit

class CustomView: UIView {
    
    var delegate: CustomDelegate?
    
    @IBAction func dismissCustomViewButtonTapped(_ sender: Any) {
        
        self.delegate?.closeCustomView()
    }
}
