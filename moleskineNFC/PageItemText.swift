//
//  PageItemImage.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/23/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

class PageItemText: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numberOfLines = 0
        initializeLabel()
    }
    
    func initializeLabel() {
        self.textAlignment = .left
        self.font = UIFont(name: "Halvetica", size: 17)
        self.textColor = UIColor.black
        
    }
}
