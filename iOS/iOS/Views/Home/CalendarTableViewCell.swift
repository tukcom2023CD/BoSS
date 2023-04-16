//
//  CalendarTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit
import FSCalendar

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var eventDates: [String] = []
    var schedules: [Schedule]?
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCalendar()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        
        calendar.scope = .month // 월간 모드
        calendar.locale = Locale(identifier: "ko_KR") // 언어 변경
        calendar.scrollEnabled = true // 스크롤 가능
        calendar.scrollDirection = .horizontal // 스크롤 방향
        calendar.appearance.headerDateFormat = "YYYY년 MM월" // 헤더 날짜 포멧
        calendar.appearance.headerMinimumDissolvedAlpha = 0.5 // 헤더 양 옆(이전, 이후 달) 글씨 투명도
        calendar.allowsMultipleSelection = false // 다중 선택 불가
        // 달력의 평일 날짜 색깔
        calendar.appearance.titleDefaultColor = .black
        
        // 달력의 토,일 날짜 색깔
        calendar.appearance.titleWeekendColor = .red
        
        // 달력의 맨 위의 년도, 월의 색깔
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont(name: "Marker Felt", size: 20)!
        calendar.appearance.weekdayFont = UIFont(name: "Marker Felt", size: 16)!
        
        
        // 달력의 요일 글자 색깔
        calendar.appearance.weekdayTextColor = .darkGray
        
        
        
    }
    
}

//MARK: - CalendarDelegate, DataSource, DelegateAppearance
extension CalendarTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // 날짜 선택 시
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        //print(eventDates)
//
//        let day = dateFormatter.string(from: date)// 선택한 날짜
//
//
//        // 캘린더의 표시된 날짜가 이벤트 날짜에 포함되지 않은 경우
//        if !eventDates.contains(day) { return  }
//        else {
//            //이곳에 해당 day를 가진 여행 schedules정보 바
//            print(day)
//
//        }
//
//    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = dateFormatter.string(from: date)
        

        if let matchingSchedule = schedules?.first(where: { schedule in
            if let startDateString = schedule.start, let startDate = dateFormatter.date(from: startDateString),
               let stopDateString = schedule.stop, let stopDate = dateFormatter.date(from: stopDateString) {
                return selectedDate >= dateFormatter.string(from: startDate) && selectedDate <= dateFormatter.string(from: stopDate)
            }
            return false
        }) {
            if let title = matchingSchedule.title {
                print("Selected date has a schedule titled: \(title)")
                            }
        }
    }
    // 날짜 선택 해제 시
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
    }
    
    // 날짜 밑에 문자열 표시
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return nil
    }
    
    // 특정 날짜에 이미지 표시
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        let day = dateFormatter.string(from: date)
        
        // 캘린더의 표시된 날짜가 이벤트 날짜에 포함되지 않은 경우
        if !eventDates.contains(day) { return nil }
        
        let now = dateFormatter.string(from: Date())
        
        if day < now {
            return UIImage(named: "RedCircle")
        } else if day == now {
            return UIImage(named: "GreenCircle")
        } else {
            return UIImage(named: "BlueCircle")
        }
        
        
    }
    
    
}



