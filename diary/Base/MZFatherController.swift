//
//  MZFatherController.swift
//  diary
//
//  Created by 曾龙 on 2018/6/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import UIKit

class MZFatherController: UIViewController {

    var bgImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImageView = UIImageView.init(frame: self.view.bounds);
        self.view.addSubview(self.bgImageView);
        self.view.backgroundColor = UIColor.white;
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //3.重写无参数初始化方法，自动调用xib文件
    
    convenience init() {
        let nibNameOrNil = String(describing: type(of: self))
        //考虑到xib文件可能不存在或被删，故加入判断
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "nib") != nil {
            self.init(nibName: nibNameOrNil, bundle: nil)
        }else{
            self.init(nibName: nil, bundle: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
