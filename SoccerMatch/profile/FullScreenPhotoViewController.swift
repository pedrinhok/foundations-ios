//
//  FullScreenPhotoViewController.swift
//  SoccerMatch
//
//  Created by Hercílio Martins Ortiz on 10/07/2018.
//  Copyright © 2018 Pedro Kayser. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    var photoFull: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photo.image = photoFull
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
