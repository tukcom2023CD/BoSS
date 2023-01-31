//
//  CalendarTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit
import FSCalendar

class CalendarTableViewCell: UITableViewCell {
    
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    @IBOutlet weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
       
        
        setCalendarUI()
       
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        calendar.reloadData()
        // Configure the view for the selected state
    }
}
    //MARK: -
extension CalendarTableViewCell: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    //주간 월간 크기 조절
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    //날짜 선택시
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let string = formatter.string(from: date)
        print("\(string) Select")
    }
   //선택된 날짜 선택시
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let string = formatter.string(from: date)
        print("\(string) Deselect")
    }

    
    
    func setCalendarUI(){
        let dates = [
            self.gregorian.date(byAdding: .day, value: -1, to: Date()),
            Date(),
            self.gregorian.date(byAdding: .day, value: 1, to: Date())
        ]
        dates.forEach { (date) in
            self.calendar.select(date, scrollToDate: false)
        }
        self.calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.delegate = self
        calendar.dataSource = self
        self.calendar.locale = Locale(identifier: "ko_KR")
        // 달력 헤더 yyyy년 dd월 로 설정
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.headerHeight = 50
        // 날짜 테두리 둥글게
       // calendar.appearance.borderRadius = 0.5
        // 현재 월의 일만 표시
        calendar.placeholderType = .none
//        calendar.appearance.titleDefaultColor  요일 날짜 색
//        calendar.appearance.subtitleOffset = CGPoint(x: 30, y: 30)
        // 주말 텍스트 색
        calendar.appearance.titleWeekendColor = .red
//        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = .blue
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        // 선택 여러개 가능
        calendar.allowsMultipleSelection = true
        //
        
    }
    // 요일 테두리 선 지정
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.black
//
//    }
    
    //MARK: - private
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! CalendarCell)
        // Custom today circle
        diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var eventType = EventType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        eventType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        eventType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        eventType = .leftBorder
                    }
                    else {
                        eventType = .single
                    }
                }
            }
            else {
                eventType = .none
            }
            if eventType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = eventType
            
        } else {
            diyCell.circleImageView?.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
}

