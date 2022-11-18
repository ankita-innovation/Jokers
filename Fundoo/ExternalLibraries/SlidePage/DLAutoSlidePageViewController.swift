//
//  DLAutoSlidePageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

public class DLAutoSlidePageViewController: UIPageViewController,UIScrollViewDelegate {

  private(set) var pages: [UIViewController] = []
  
  fileprivate var currentPageIndex: Int = 0
  fileprivate var nextPageIndex: Int = 0
  fileprivate var timeInterval: TimeInterval = 0.0
  fileprivate var transitionInProgress: Bool = false
  fileprivate var scrollView = UIScrollView()
    var type = String()
    var pageChanged: ((_ index:Int) -> Void)?

  public var pageControl: UIPageControl? {
    return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
  }
  
  // MARK: - Lifecycle
    
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil);
  }
    
  override public func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    dataSource = self
    setupObservers()
  }
    public override func viewDidLayoutSubviews() {
        self.view.frame = CGRect.init(x: 0, y: 0, width: FULL_WIDTH, height: FULL_HEIGHT)
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
                scrollView = subView as! UIScrollView
                scrollView.delegate = self
            } else if subView is UIPageControl {
                subView.isHidden = true
            }
           
        }
    }
  
    public convenience init(pages: [UIViewController], timeInterval ti: TimeInterval = 0.0, transitionStyle: UIPageViewController.TransitionStyle, interPageSpacing: Float = 0.0,type:String) {
            self.init(transitionStyle: transitionStyle,
                      navigationOrientation: .horizontal,
                      options: [UIPageViewController.OptionsKey.interPageSpacing: interPageSpacing])
    self.pages = pages
    self.timeInterval = ti
    setupPageView(type: type)
        self.type = type
  }
  

  // MARK: - Private
  
  fileprivate func setupObservers() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(movedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
  }
  
    fileprivate func setupPageView(type:String) {
        if type == "first" || type == "live"{
            guard let firstPage = pages.first else { return }
            currentPageIndex = 0
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }else{
            guard let firstPage = pages.last else { return }
            currentPageIndex = 1
            setViewControllers([firstPage], direction: .reverse, animated: true, completion: nil)
        }
  }
  
 
  
  fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController {
    guard index < pages.count else { return UIViewController() }
    currentPageIndex = index
    return pages[index]
  }
  

 
  
  // MARK: - Selectors
  @objc fileprivate func movedToForeground() {
    transitionInProgress = false
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if UserModel.shared.pageScroll()! {
        if currentPageIndex == 0 && scrollView.contentOffset.x<FULL_WIDTH {
            self.scrollView.isScrollEnabled =  false
        }else if currentPageIndex == 1 && scrollView.contentOffset.x>FULL_WIDTH{
            self.scrollView.isScrollEnabled =  false
        }else{
            self.scrollView.isScrollEnabled =  true
        }
    }else{
        self.scrollView.isScrollEnabled =  false
    }

    }
}
    




// MARK: - UIPageViewControllerDelegate

extension DLAutoSlidePageViewController: UIPageViewControllerDelegate {
  
  public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    guard let viewController = pendingViewControllers.first as UIViewController?, let index = pages.index(of: viewController) as Int? else {
      return
    }
    nextPageIndex = index
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

    if completed {
      currentPageIndex = nextPageIndex
    }
    if self.type != "live"{
        self.pageChanged!(currentPageIndex)
    }
    nextPageIndex = 0
  }
  
}

// MARK: - UIPageViewControllerDataSource

extension DLAutoSlidePageViewController: UIPageViewControllerDataSource {
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard var currentIndex = pages.index(of: viewController) as Int? else { return nil }
    
    if UserModel.shared.pageScroll()! {
        scrollView.isScrollEnabled = true

//        if self.type != "live"{
//            self.pageChanged!(currentIndex)
//        }
        if currentIndex > 0 {
            currentIndex = (currentIndex - 1) % pages.count
            return pages[currentIndex]
        } else {
            return nil
        }
    }else{
        scrollView.isScrollEnabled = false
        return nil
    }
  }
  
  public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard var currentIndex = pages.index(of: viewController) as Int? else { return nil }
    
    if UserModel.shared.pageScroll()! {
        scrollView.isScrollEnabled = true

//        if self.type != "live"{
//            self.pageChanged!(currentIndex)
//        }
        if currentIndex < pages.count - 1 {
            currentIndex = (currentIndex + 1) % pages.count
            return pages[currentIndex]
        } else {
            return nil
        }
    }else{
        scrollView.isScrollEnabled = false
        return nil
    }

  }
  
  public func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return currentPageIndex
  }

}
