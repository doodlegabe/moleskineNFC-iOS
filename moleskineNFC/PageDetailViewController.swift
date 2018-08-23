//
//  PageDetailViewController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/20/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

protocol GetsDataFromPage {
    var pageData: Page {get set}
    func getPageData(page: Page)
}

class PageDetailViewController : UIViewController, GetsDataFromPage {
    
    var pageData: Page = Page(id:0, number:0, notebookId:0, createdAt: "", updatedAt: "", pageItems: [PageItem(id: 0, createdAt: "", updatedAt: "", pageId:0, body:"", image:"")])
    
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageTitleLabel.text = "Page \(pageData.number)"
        var pageItemLabel: PageItemText
        let pageItems = pageData.pageItems as [PageItem]
        var counter = 1
        for aPageItem in pageItems {
            //FIXME : Responsive
            if !aPageItem.body.isEmpty {
                pageItemLabel = PageItemText(frame: CGRect(x: 10, y: (100*counter), width: 200, height: 100))
                pageItemLabel.text = aPageItem.body
                self.view.addSubview(pageItemLabel)
                counter += 1
            }
            if !aPageItem.image.isEmpty {
                // FIXME: load from url
                //let aUrl = URL(string:aPageItem.image)
                let anImageFile: UIImage = UIImage(named: "writing.png")!
                let anImage: UIImageView = UIImageView(image:anImageFile)
                anImage.contentMode = .scaleAspectFit
                anImage.frame = CGRect(x: 10, y: (100*counter), width: 200, height: 100)
                self.view.addSubview(anImage)
                counter += 1
            }
        }
    }
    
    func getPageData(page: Page) {
        pageData = page
    }
}


