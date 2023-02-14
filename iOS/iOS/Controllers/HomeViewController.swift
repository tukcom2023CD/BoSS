//
//  HomeViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/17.
//

import UIKit
import CalendarDateRangePicker


class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var upcomingSchedules: [Schedule] = []
    var previousSchedules: [Schedule] = []
    var eventDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Travelog"
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        requestScheduleData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // 여행 일정 불러오기
    /// - parameter uid : 로그인 유저 ID
    func requestScheduleData() {
        let user = UserDefaults.standard.getLoginUser()!
        
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            self.upcomingSchedules = schedules
            self.extractScheduleDate(schedules: schedules) // 여행 날짜 추출
            self.divideScheduleData(schedules: self.upcomingSchedules) // 지난, 다가오는 여행(진행중 포함) 분리
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // 다녀온 여행, 다가올 여행 분리
    /// - parameter schedules : 서버로부터 받은 여행 일정 데이터
    func divideScheduleData(schedules: [Schedule]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let currentDate = formatter.string(from: Date())
        
        for schedule in schedules {
            if currentDate <= schedule.stop! {
                break
            }
            self.previousSchedules.insert(schedule, at: 0)
            self.upcomingSchedules.removeFirst()
        }
    }
    
    // 여행 날짜 추출
    /// - parameter schedules : 모든 일정 데이터
    func extractScheduleDate(schedules: [Schedule]) {
        for schedule in schedules {
            let start = CustomDateFormatter.format.date(from: schedule.start!)!
            let stop = CustomDateFormatter.format.date(from: schedule.stop!)!
            
            let interval = start.distance(to: stop) // 시작, 종료 날짜까지의 TimeInterval
            let days = Int(interval / 86400) // 시작, 종료 날짜까지의 Day
            
            for i in 0...days {
                let event = start.addingTimeInterval(TimeInterval(86400 * i))
                let eventStr = CustomDateFormatter.format.string(from: event)
                eventDates.append(eventStr)
            }
        }
    }
    
    // 테이블 뷰 세팅
    func setupTableView() {
        //register TableViewCell
        tableView.register(UINib(nibName:"FirstTableViewCell", bundle: nil), forCellReuseIdentifier:"FirstTableViewCell")
        tableView.register(UINib(nibName:"CalendarTableViewCell", bundle: nil), forCellReuseIdentifier:"CalendarTableViewCell")
        
        tableView.register(UINib(nibName:"SecondTableViewCell", bundle: nil), forCellReuseIdentifier:"SecondTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    @IBAction func createScheduleBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let planningVC = storyboard?.instantiateViewController(withIdentifier: "PlanningVC") as! PlanningViewController
        
        navigationController?.pushViewController(planningVC, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func testSearchPlaceButtonTapped(_ sender: UIBarButtonItem) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchPlaceVC") as! SearchPlaceViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
            cell.configure()
            cell.selectionStyle = .none
            cell.schedules = self.upcomingSchedules
            
            // 여행일정 셀 클릭 시 동작할 기능 정의
            cell.didSelectItem = { schedule in
                let mainPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPlanViewController") as! MainPlanViewController
                
                mainPlanVC.schedule = schedule
                
                self.navigationController?.pushViewController(mainPlanVC, animated: true)
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
            
            cell.selectionStyle = .none
            cell.eventDates = self.eventDates
            cell.calendar.reloadData()
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell", for: indexPath) as! SecondTableViewCell
            cell.selectionStyle = .none
            cell.schedules = self.previousSchedules
            
            cell.didSelectItem = { schedule in
                let mainPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPlanViewController") as! MainPlanViewController
                
                mainPlanVC.schedule = schedule
                
                self.navigationController?.pushViewController(mainPlanVC, animated: true)
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let interval:CGFloat = 3
        //let width: CGFloat = ( UIScreen.main.bounds.width - interval * 3 ) / 2
        
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 400
        case 2:
            return 300
            
            //            return (width + 40 + 3) * 5 + 40
        default:
            return 0
        }
        
    }
}
