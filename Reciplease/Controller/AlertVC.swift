import UIKit
import Foundation

extension UIViewController {
    func presentAlert(message: String) {
            let alertVC = UIAlertController(title: "Erreur", message: "\(message)", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
}
