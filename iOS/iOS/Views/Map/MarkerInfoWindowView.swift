//
//  MarkerInfoWindowView.swift
//  iOS
//
//  Created by 이정동 on 2023/02/04.
//

import UIKit

class MarkerInfoWindowView: UIView {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var spending: UILabel!
    

    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            name.font = UIFont.fontSUITEBold(ofSize: 18)
            date.font = UIFont.fontSUITEBold(ofSize: 14)
            spending.font = UIFont.fontSUITEBold(ofSize: 14)
            
        }
    
}
