//
//  CostCell.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/02.
//

import UIKit

class CostCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(with item: (name: String, quantity: Int, price: Int)) {
        nameLabel.text = item.name
        quantityLabel.text = "\(item.quantity)"
        priceLabel.text = "$\(item.price)"
    }
    
}
