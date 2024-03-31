//
//  UIViewController+.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, btnString: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: btnString, style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
}
