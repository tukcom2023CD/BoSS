//
//  EditTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/02/17.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    var amount:Int!
    var price:Int!
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        deleteButton.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
