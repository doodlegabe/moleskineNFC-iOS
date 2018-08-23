//
//  PageDetailViewController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/20/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

class PageDetailViewController : UIViewController {
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitleLabel.text = "Page 1"
    }
    
    
}
