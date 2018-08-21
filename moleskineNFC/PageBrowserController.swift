//
//  PageBrowserController.swift
//  moleskineNFC
//
//  Created by Gabriel Walsh on 8/20/18.
//  Copyright © 2018 Gabriel Walsh. All rights reserved.
//

import UIKit

class PageBrowserController: UIPageViewController, UIPageViewControllerDelegate {
        
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newMoleskineCoverController(), self.newMoleskinePageController()]
    }()
    
    private func newMoleskineCoverController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "NotebookCoverViewController")
    }
    
    private func newMoleskinePageController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "PageDetailViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
}

extension PageBrowserController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}
