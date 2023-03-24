//
//  UIImage+Extension.swift
//  diary
//
//  Created by 曾龙 on 2018/7/20.
//  Copyright © 2018年 mz. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func createImage(frame: CGRect,startColor:UIColor,endColor:UIColor,startPoint:CGPoint,endPoint:CGPoint) -> UIImage {
        let gradient = CAGradientLayer.init();
        gradient.startPoint = startPoint;
        gradient.endPoint = endPoint;
        gradient.frame = frame;
        gradient.colors = [startColor.cgColor,endColor.cgColor];
        
        UIGraphicsBeginImageContext(frame.size);
        let context = UIGraphicsGetCurrentContext();
        
        let path = CGMutablePath.init();
        path.move(to: CGPoint.init(x: 0, y: 0));
        path.addLine(to: CGPoint.init(x: frame.width, y: 0));
        path.addLine(to: CGPoint.init(x: frame.width, y: frame.height));
        path.addLine(to: CGPoint.init(x: 0, y: frame.height));
        path.closeSubpath();
        
        self.drawLinearGradient(content: context!, path: path, startColor: startColor.cgColor, endColor: endColor.cgColor, startPoint: startPoint, endPoint: endPoint);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image!;
    }
    
    static func drawLinearGradient(content:CGContext,path:CGPath,startColor:CGColor,endColor:CGColor,startPoint:CGPoint,endPoint:CGPoint) -> Void {
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let locations:[CGFloat] = [0.0,1.0];
        let colors = [startColor,endColor];
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations);
        let pathRect = path.boundingBox;
        
        let sPoint =  CGPoint.init(x: pathRect.size.width*startPoint.x, y: pathRect.size.height*startPoint.y);
        let ePoint = CGPoint.init(x: pathRect.size.width*endPoint.x, y: pathRect.size.height*endPoint.y)
        
        content.saveGState();
        content.addPath(path);
        content.clip();
        content.drawLinearGradient(gradient!, start: sPoint, end: ePoint, options: CGGradientDrawingOptions.drawsAfterEndLocation);
        content.restoreGState();
    }
}
