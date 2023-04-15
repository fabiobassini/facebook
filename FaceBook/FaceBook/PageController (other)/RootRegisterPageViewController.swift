//
//  RootRegisterPageViewController.swift
//  FaceBook
//
//  Created by Fabio Bassini on 15/08/2020.
//  Copyright © 2020 Fabio Bassini. All rights reserved.
//

import UIKit

class RootRegisterPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    
    lazy var viewControllerList: [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "registerEmail")
        let vc2 = sb.instantiateViewController(withIdentifier: "registerName")
        let vc3 = sb.instantiateViewController(withIdentifier: "registerPassword")
        let vc4 = sb.instantiateViewController(withIdentifier: "registerBirthday")
        let vc5 = sb.instantiateViewController(withIdentifier: "registerGender")

        return [vc1, vc2,vc3, vc4, vc5]
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstViewcontroller = viewControllerList.first {
            self.setViewControllers([firstViewcontroller], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.white
            }
        }
    }
    
    
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return viewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex =  viewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex =  viewControllerList.firstIndex(of: viewController) else { return nil }

        let nextIndex = vcIndex + 1
        
        
        guard viewControllerList.count != nextIndex else {
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }

        
        return viewControllerList[nextIndex]
    }


}
