//
//  UIView+Extension.swift
//  diary
//
//  Created by 曾龙 on 2019/4/30.
//  Copyright © 2019年 mz. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setRounded(corners:UIRectCorner,radii:CGSize) -> Void {
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radii);
        
        let shapeLayer = CAShapeLayer.init();
        shapeLayer.path = path.cgPath;
        shapeLayer.frame = self.bounds;
        
        let borderLayer = CAShapeLayer.init();
        borderLayer.path = path.cgPath;
        borderLayer.fillColor = UIColor.clear.cgColor;
        borderLayer.strokeColor = self.layer.borderColor;
        borderLayer.lineWidth = self.layer.borderWidth;
        borderLayer.frame = self.bounds;
        self.layer.mask = shapeLayer;
        self.layer.addSublayer(borderLayer);
    }
}
