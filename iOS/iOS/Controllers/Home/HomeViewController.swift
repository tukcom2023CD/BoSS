//
//  HomeViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/17.
//

import UIKit
import CalendarDateRangePicker
import CollectionViewPagingLayout

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentCellIndex = 0
  
  //  var isExpanded = false
    
    var upcomingSchedules: [Schedule] = []
    var previousSchedules: [Schedule] = []
    var eventDates: [String] = []
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Travelog"
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = 5//linkImages.count
        collectionView.register(UINib(nibName:"ExtensionHomeTravelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "ExtensionHomeTravelCollectionViewCell")
        collectionView.register(UINib(nibName:"NoExHomeTravelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "NoExHomeTravelCollectionViewCell")
   
        setupTableView()
        requestScheduleData()
        startTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    @objc func moveToNextIndex(){
        if currentCellIndex < 4 {
            currentCellIndex += 1
        }else {
            currentCellIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
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
    
}
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionView = scrollView as! UICollectionView
        let visibleCells = collectionView.visibleCells
        let visibleWidth = collectionView.bounds.width - 100
        
        for cell in visibleCells {
            let x = cell.frame.origin.x - collectionView.contentOffset.x
            let distance = abs(x - visibleWidth / 5)
            let scale = max(0, 1 - distance / visibleWidth)
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtensionHomeTravelCollectionViewCell", for: indexPath) as! ExtensionHomeTravelCollectionViewCell
        cell.labelText.text = String(currentCellIndex)
        return cell
        //        if isExpanded {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtensionHomeTravelCollectionViewCell", for: indexPath) as! ExtensionHomeTravelCollectionViewCell
        //            cell.labelText.text = String(currentCellIndex)
        //
        //
        //
        //            // 확장된 셀
        //            return cell
        //        } else {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoExHomeTravelCollectionViewCell", for: indexPath) as! NoExHomeTravelCollectionViewCell
        //            cell.images.image = UIImage(named: linkImages[indexPath.row])
        //            // 기본 셀
        //            return cell
        //        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 각 셀의 크기를 지정
        var cgSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height-20)
        return cgSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if isExpanded == true {
        //            isExpanded = false
        //        }else{
        //            isExpanded = true}
        
        //  collectionView.reloadData()
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
            return 200
        case 1:
            return 400
        case 2:
            return 400
            
            //            return (width + 40 + 3) * 5 + 40
        default:
            return 0
        }
        
    }
}
