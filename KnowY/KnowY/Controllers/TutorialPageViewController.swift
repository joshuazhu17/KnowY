//
//  TutorialPageViewController.swift
//  KnowY
//
//  Created by Joshua Zhu on 8/2/18.
//  Copyright © 2018 joshuazhu. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "page1"),
            self.getViewController(withIdentifier: "page2"),
            self.getViewController(withIdentifier: "page3"),
            self.getViewController(withIdentifier: "page4"),
            self.getViewController(withIdentifier: "page5")
        ]
    }()
    
    func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "FirstTutorial", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate   = self
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
