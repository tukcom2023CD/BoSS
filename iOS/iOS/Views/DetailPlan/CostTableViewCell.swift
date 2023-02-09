//
//  CostTableViewCell.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/02.
//

import UIKit



class CostTableViewCell: UITableViewCell {
    var data = [(name: String, quantity: Int, price: Int)]()
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

