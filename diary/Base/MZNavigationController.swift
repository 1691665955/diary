//
//  MZNavigationController.swift
//  diary
//
//  Created by 曾龙 on 2018/7/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit

@objc
protocol MZNavigationControllerDelegate:NSObjectProtocol {
    @objc optional func navigationBackHandle()->Void
    @objc optional func navigationHiddenBackBtn()->Bool
}

class MZNavigationController: UINavigationController,UINavigationControllerDelegate {
    var viewController: UIViewController?
    weak var mzDelegate :MZNavigationControllerDelegate? {
        didSet {
            if (mzDelegate != nil) {
                self.mzDelegateArray.append(mzDelegate!);
            }
        }
    }
    var backBtn: UIButton!
    lazy var mzDelegateArray:Array = { () -> [AnyObject] in
        let mzDelegateArray = Array<AnyObject>()
        return mzDelegateArray;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBar = UINavigationBar.appearance();
        navigationBar.isTranslucent = false;
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white];
        navigationBar.setBackgroundImage(UIImage.from(color: RGB(r: 0, g: 212, b: 71)), for: UIBarMetrics.default);
        
        self.delegate = self;
        
        let btn = UIButton.init(type: UIButtonType.custom);
        btn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 44);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0);
        btn.setImage(UIImage.init(named: "返回"), for: UIControlState.normal);
        btn.addTarget(self, action: #selector(leftBarItemClicked), for: UIControlEvents.touchUpInside);
        
        self.backBtn = btn;
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if (self.mzDelegateArray.contains(where: { (ele) -> Bool in
            if (ele as! NSObject == viewController) {
                return true;
            } else {
                return false;
            }
        })) {
            self.mzDelegate = viewController as? MZNavigationControllerDelegate;
        } else {
            self.mzDelegate = nil;
        }
        
        if navigationController.viewControllers.count > 1 || (navigationController.presentingViewController != nil) {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "   ", style: UIBarButtonItemStyle.plain, target: nil, action: nil);
            navigationController.navigationBar.addSubview(self.backBtn);
            if ((self.mzDelegate != nil) && (self.mzDelegate?.responds(to: #selector(MZNavigationControllerDelegate.navigationHiddenBackBtn)))!) {
                if (self.mzDelegate?.navigationHiddenBackBtn!())! {
                    self.backBtn.removeFromSuperview();
                }
            }
            if navigationController.viewControllers.count > 1 {
                viewController.hidesBottomBarWhenPushed = true;
                self.viewController = viewController;
            }
        } else {
            self.backBtn.removeFromSuperview();
        }
    }
    
    @objc func leftBarItemClicked() -> Void {
        if ((self.mzDelegate != nil) && (self.mzDelegate?.responds(to: #selector(MZNavigationControllerDelegate.navigationBackHandle)))!) {
            self.mzDelegate?.navigationBackHandle!();
            return;
        }
        
        if self.viewControllers.count > 1 {
            if self.viewControllers[self.viewControllers.count-1] == self.viewController {
                //如果是push过来的
                if self.viewControllers.count == 2 {
                    self.backBtn.removeFromSuperview();
                }
                self.popViewController(animated: true);
             }
        } else {
            //如果是present过来的
            self.dismiss(animated: true, completion: nil);
        }
    }
}
