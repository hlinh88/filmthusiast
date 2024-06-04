//
//  BaseVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 4/4/2024.
//

import Foundation
import UIKit
import Reusable
import Network
import Kingfisher
import SwiftyGif
import SkeletonView

class BaseVC: UIViewController {
    @objc @IBAction open func btnBackClick(_ sender: UIButton) {
        if (self.navigationController?.viewControllers.count == 1),
           nil != self.navigationController?.presentingViewController {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
