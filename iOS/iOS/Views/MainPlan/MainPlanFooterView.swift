//
//  MainPlanFooterView.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit

class MainPlanFooterView: UITableViewHeaderFooterView {

    var didSelectButton: (()->())? = nil
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        didSelectButton?()
    }
    
}
