//
//  CalendarTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var calendarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarImg.layer.cornerRadius = 5//숫자 클수록 둥글게
        calendarImg.layer.masksToBounds = true
        calendarImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
