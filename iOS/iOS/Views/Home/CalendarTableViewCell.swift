//
//  CalendarTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit
import FSCalendar

class CalendarTableViewCell: UITableViewCell,FSCalendarDelegate {

    @IBOutlet weak var calendar: FSCalendar!
//    @IBOutlet weak var calendarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        calendarImg.layer.cornerRadius = 5//숫자 클수록 둥글게
//        calendarImg.layer.masksToBounds = true
//        calendarImg.clipsToBounds = true
//        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 30)   // 달력 글씨 크기
        
        calendar.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd EEEE"
        let string = formatter.string(from: date)
        print("\(string)")
    }
}
