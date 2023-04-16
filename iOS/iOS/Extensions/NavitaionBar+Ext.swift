//
//  NavitaionBar+Ext.swift
//  iOS
//
//  Created by 박다미 on 2023/04/16.
//

import Foundation
import UIKit
class CustomNavigationBar: UINavigationBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 32)
    }
}

