//
//  ViewController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/14/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let helper = NFCHelper()
    static let onNFCScan = Notification.Name("notifyNFCScan")
    static let onWebServiceResult = Notification.Name("notifyWebServiceResult")
    static let onWebServiceParse = Notification.Name("notifyWebServiceParse")
    static let onReturnToMainScreen = Notification.Name("notifyReturnToMainScreen")
    
    @IBAction func scanButton(_ sender: UIButton) {
        didTapReadNFC()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func onNFCResult(success: Bool, msg: String) {
        print(success, msg)
    }
    
    @objc func didTapReadNFC() {
        helper.onNFCResult = onNFCResult(success:msg:)
        helper.restartSession()
        self.viewNotebook()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func viewNotebook(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PageBrowserController") as! PageBrowserController
        self.present(vc, animated: true, completion: nil)
    }
    
    func returnToScan() {
        print("return to scan")
        self.present(self, animated: true, completion: nil)
    }
    
}



