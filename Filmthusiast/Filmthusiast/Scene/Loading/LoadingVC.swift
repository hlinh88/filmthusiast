//
//  LoadingVC.swift
//  Filmthusiast
//
//  Created by Hoang Linh Nguyen on 2/4/2024.
//

import UIKit

class LoadingVC: UIViewController {
    @IBOutlet weak var ivLoading: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
        // Do any additional setup after loading the view.
    }


    private func setupLoading() {
        do {
            let gif = try UIImage(gifName: "loading.gif")
            self.ivLoading.setGifImage(gif, loopCount: -1)
        } catch {
            print("Error loading gif:", error.localizedDescription)
        }
    }

}
