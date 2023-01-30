//
//  UIView+Ext.swift
//  iOS
//
//  Created by 박다미 on 2023/01/29.
//

import Foundation
import UIKit

extension UIView {
    
    func addDropShadow(scale: Bool = true, cornerRadius: CGFloat ) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 1.5
        
        //layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    
    func slideUpShow(_ duration: CGFloat){
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()}, completion: nil)
        self.isHidden = false
    }
    
    func slideDownHide(_ duration: CGFloat){
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()},  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })

    }

}
