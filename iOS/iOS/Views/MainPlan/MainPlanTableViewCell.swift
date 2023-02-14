//
//  MainPlanTableViewCell.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit

class MainPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var placeName: UILabel!
    
    @IBOutlet weak var totalSpending: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
