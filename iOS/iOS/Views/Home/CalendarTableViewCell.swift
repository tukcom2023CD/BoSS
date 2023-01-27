//
//  CalendarTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit
import FSCalendar

class CalendarTableViewCell: UITableViewCell,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {

    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet weak var calendar: FSCalendar!
//    @IBOutlet weak var calendarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        calendarImg.layer.cornerRadius = 5//숫자 클수록 둥글게
//        calendarImg.layer.masksToBounds = true
//        calendarImg.clipsToBounds = true
//        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 30)   // 달력 글씨 크기
        
        
        setCalendarUI()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   //MARK: -
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd EEEE"
        let string = formatter.string(from: date)
        print("\(string)")
    }
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        if self.gregorian.isDateInToday(date) {
//            return "D-day"
//        }
//        return nil
//    }
    func setCalendarUI(){
        calendar.delegate = self
        calendar.dataSource = self
        self.calendar.locale = Locale(identifier: "ko_KR")
        // 달력 헤더 yyyy년 dd월 로 설정
        calendar.appearance.headerDateFormat = "YYY년 MM월"
        calendar.headerHeight = 50
        // 날짜 테두리 둥글게
        calendar.appearance.borderRadius = 0.5
        // 현재 월의 일만 표시
        calendar.placeholderType = .none
//        calendar.appearance.titleDefaultColor  요일 날짜 색
        calendar.appearance.subtitleOffset = CGPoint(x: 30, y: 30)
        // 주말 텍스트 색
        calendar.appearance.titleWeekendColor = .red
        calendar.appearance.todayColor = .orange
        calendar.appearance.todaySelectionColor = .orange
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
       
    }
    // 요일 테두리 선 지정
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.black
//
//    }
   
}
