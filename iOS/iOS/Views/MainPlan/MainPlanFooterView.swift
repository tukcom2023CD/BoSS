//
//  MainPlanFooterView.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit

class MainPlanFooterView: UITableViewHeaderFooterView {

    
    @IBOutlet weak var addButton: UIButton!
    
    var didSelectButton: (()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        addButton.layer.cornerRadius = 5
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        didSelectButton?()
        
    }
    
}
