//
//  PageBrowserController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/20/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

class PageBrowserController: UIPageViewController {
    
    weak var pageBrowserDelegate: PageBrowserControllerDelegate?
        
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newMoleskineCoverController()]
    }()
    
    private func newMoleskineCoverController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "NotebookCoverViewController")
    }
    
    private func newMoleskinePageController() -> PageDetailViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "PageDetailViewController") as! PageDetailViewController
    }
    
     override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifiedWebServiceResult(notification:)), name: MainViewController.onWebServiceResult, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifiedWebServiceParse(notification:)), name: MainViewController.onWebServiceParse, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifiedNFCScan(notification:)), name: MainViewController.onNFCScan, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifiedReturnToMainScreen(notification:)), name: MainViewController.onReturnToMainScreen, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        pageBrowserDelegate?.PageBrowserController(pageBrowserController: self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    @objc func onNotifiedWebServiceResult(notification:Notification) {
        print("PageBrowserController onNotifiedWebServiceResult")
  
    }
    @objc func onNotifiedWebServiceParse(notification:Notification) {
        print("PageBrowserController onNotifiedWebServiceParse")
        let n = notification.userInfo!["pages"] as! [Page]
        let nAmount = n.count as Int
        
        for index in 1...nAmount {
            let aDetailPage = self.newMoleskinePageController()
            aDetailPage.getPageData(page: n[index-1])
            orderedViewControllers.append(aDetailPage)
        }
    }
    @objc func onNotifiedNFCScan(notification:Notification) {
        print("PageBrowserController onNotifiedNFCScan")
    }
    
    @objc func onNotifiedReturnToMainScreen(notification:Notification) {
        print("PageBrowserController onNotifiedReturnToMainScreen")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of:firstViewController){
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToAViewController(viewController: nextViewController, direction: direction)
        }
    }

    private func scrollToAViewController(viewController: UIViewController,
                                        direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in self.notifypageBrowserlDelegateOfNewIndex()
        })
    }
    
    private func notifypageBrowserlDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of:firstViewController) {
            pageBrowserDelegate?.PageBrowserController(pageBrowserController: self, didUpdatePageIndex: index)
        }
    }
    
    private func pagesCheck() -> Bool {
        if orderedViewControllers.count > 1 {
          return true
        }
        return false
    }

}

extension PageBrowserController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.index(of: self) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard pagesCheck() else {
            return nil
        }
        
        guard let viewControllerIndex = orderedViewControllers.index(of:viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        guard orderedViewControllers.count >= 1 else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
    
}


extension PageBrowserController: UIPageViewControllerDelegate {
    
    func pageBrowserController(pageBrowserController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifypageBrowserlDelegateOfNewIndex()
    }
    
}

protocol PageBrowserControllerDelegate: class {
    
    func PageBrowserController(pageBrowserController: PageBrowserController, didUpdatePageCount count: Int)
    
    func PageBrowserController(pageBrowserController: PageBrowserController, didUpdatePageIndex index: Int)
    
}
