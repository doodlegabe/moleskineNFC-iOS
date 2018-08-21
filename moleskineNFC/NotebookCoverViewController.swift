//
//  NotebookCoverViewController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/21/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

class NotebookCoverViewController : UIViewController {
    
    @IBOutlet weak var notebookTitleLabel: UILabel!
    @IBOutlet weak var notebookOwnerLabel: UILabel!
    @IBOutlet weak var notebookCreationInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notebookTitleLabel.text = ""
        notebookOwnerLabel.text = ""
        notebookCreationInfoLabel.text = ""
    }
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MainViewController.notebookNotifier, object: nil)
    }
    
    func dateHandler(fromJSON: String) -> String {
        let trimmedIsoString = fromJSON.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let fromStringToISOFormatter = ISO8601DateFormatter()
        let date = fromStringToISOFormatter.date(from: trimmedIsoString)
        let fromISOBackToStringFormatter = DateFormatter()
        fromISOBackToStringFormatter.dateFormat = "dd/MM/YYYY"
        return fromISOBackToStringFormatter.string(from: date!)
    }

    
    @objc func onNotification(notification:Notification) {
        print("notebook cover notified")
        let n = notification.userInfo!["notebook"] as? MoleskineNotebook
        notebookTitleLabel.text = n?.title
        let name = (n?.owner.firstName)! + " " + (n?.owner.lastName)!
        notebookOwnerLabel.text = "created by \(name)"
        let createdDateString = n?.createdAt
        let updatedDateString = n?.updatedAt
        let createdFormattedDateString = dateHandler(fromJSON: createdDateString!)
        let updatedFormattedDateString = dateHandler(fromJSON: updatedDateString!)
        notebookCreationInfoLabel.text = """
        Last Updated: \(updatedFormattedDateString)
        Created: \(createdFormattedDateString)
        """
    }
    
    
}
