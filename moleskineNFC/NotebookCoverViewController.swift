//
//  NotebookCoverViewController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/21/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit
import PopupDialog

class NotebookCoverViewController : UIViewController {
    
    @IBOutlet weak var notebookTitleLabel: UILabel!
    @IBOutlet weak var notebookOwnerLabel: UILabel!
    @IBOutlet weak var notebookCreationInfoLabel: UILabel!
    
    override func viewDidLoad() {
        print("NotebookCoverViewController did load")
        super.viewDidLoad()
        notebookTitleLabel.text = ""
        notebookOwnerLabel.text = ""
        notebookCreationInfoLabel.text = ""
    }
    
    @IBAction func backButton(_ sender: Any) {
        NotificationCenter.default.post(name: MainViewController.onReturnToMainScreen, object: nil, userInfo: ["fromScreen": self])
    }
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifiedWebServiceResult(notification:)), name: MainViewController.onWebServiceResult, object: nil)
    }
    
    func dateHandler(fromJSON: String) -> String {
        let trimmedIsoString = fromJSON.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let fromStringToISOFormatter = ISO8601DateFormatter()
        let date = fromStringToISOFormatter.date(from: trimmedIsoString)
        let fromISOBackToStringFormatter = DateFormatter()
        fromISOBackToStringFormatter.dateFormat = "dd/MM/YYYY"
        return fromISOBackToStringFormatter.string(from: date!)
    }

    
    @objc func onNotifiedWebServiceResult(notification:Notification) {
        print(notification.userInfo!)
        if notification.userInfo!["error"] == nil {
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
            NotificationCenter.default.post(name: MainViewController.onWebServiceParse, object: nil, userInfo: ["pages":n?.pages ?? []])
        }else{
            print("404")
            let popup = PopupDialog(title: "There was a problem retrieving your notebook", message: notification.userInfo!["error"] as? String)
            let tryAgainButton = CancelButton(title: "Try Again") {
                    NotificationCenter.default.post(name: MainViewController.onReturnToMainScreen, object: nil, userInfo: ["fromScreen": self])
            }
            popup.addButtons([tryAgainButton])
            self.present(popup, animated: true, completion: nil)

        }
    }
    
    
}
