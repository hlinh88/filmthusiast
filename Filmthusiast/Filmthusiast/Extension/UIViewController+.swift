//
//  UIViewController+.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 31/3/2024.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    func showAlert(title: String, message: String, btnString: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: btnString, style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in self?.dismiss(animated: true)}))

            self?.present(alert, animated: true, completion: nil)
        }
    }
}

