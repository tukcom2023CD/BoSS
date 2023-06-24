//
//  Font+Ext.swift
//  iOS
//
//  Created by 박다미 on 2023/06/23.
//
import UIKit


//뷰컨트롤러 버튼전체폰트
extension UIViewController {
    func applySUITEBoldFont() {
        for subview in self.view.subviews {
            applySUITEBoldFontToSubviews(subview)
        }
    }
    
    private func applySUITEBoldFontToSubviews(_ view: UIView) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                        label.font = UIFont.fontSUITEBold(ofSize: label.font.pointSize)
                    }
            if let button = subview as? UIButton {
                button.titleLabel?.font = UIFont.fontSUITEBold(ofSize: button.titleLabel?.font.pointSize ?? 0)
            } else {
                applySUITEBoldFontToSubviews(subview)
            }
        }
    }
    
}
extension UIButton {
    func setSUITEBoldFont() {
        if let titleLabel = self.titleLabel {
            titleLabel.font = UIFont.fontSUITEBold(ofSize: titleLabel.font.pointSize)
        }
    }
}
extension UIFont {
    
    
        static func applyCustomFont(to label: UILabel, withName fontName: String) {
            let descriptor = label.font.fontDescriptor.withFamily(fontName)
            label.font = UIFont(descriptor: descriptor, size: label.font.pointSize)
        }
    
    class func fontSUITEBold(ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "SUITE-Bold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
    
    class func fontSUITESemiBold(ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "SUITE-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }

}
