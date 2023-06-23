//
//  HomeViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/17.
//

import UIKit
import CalendarDateRangePicker
//import CollectionViewPagingLayout



class HomeViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stickyView: UIView!
    var initialStickyViewYPosition: CGFloat = 330
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentCellIndex = 0
    
    @IBOutlet weak var smallLogo: UIImageView!
    
    @IBOutlet weak var smallLogoText: UIImageView!
    
    @IBOutlet weak var upperView: UIView!
    
    //  var isExpanded = false
    
    var upcomingSchedules: [Schedule] = []
    var previousSchedules: [Schedule] = []
    var eventDates: [String] = []
    var timer : Timer?
    
    //웹사이트나열  --> 다음화면에 넘겨주기 (현재화면이랑, 배열전체)
    //외국 감성 물씬 나는 국내 여행지 BEST7,
    var websites = [
        "ktourtop10.kr", "expedia.co.kr", "kr.trip.com", "korean.visitkorea.or.kr","verygoodtour.com"]
    
    var websitesImages = [
        UIImage(named: "테마10선"),UIImage(named: "익스피디아"),UIImage(named: "트릿닷컴"),UIImage(named: "대한민국구석구석"),UIImage(named: "참좋은여행")]
    
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = false
        hideNavigation()
        navigationController?.isToolbarHidden = true
        
        requestScheduleData() // 데이터 다시 불러오기
        tableView.reloadData() // 테이블 뷰 갱신
        collectionView.reloadData()
            
            for section in 0..<tableView.numberOfSections {
                for row in 0..<tableView.numberOfRows(inSection: section) {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: IndexPath(row: row, section: section)) as? FirstTableViewCell {
                        cell.requestScheduleIamge() // 각 셀의 이미지 갱신 요청
                    }
                }
            }
        }
      








    override func viewDidLoad() {
        super.viewDidLoad()
            smallLogo.alpha = 0.0
        smallLogoText.alpha = 0.0
        //title = "Travelog"
        scrollView.delegate = self
        stickyView.frame.origin.y = initialStickyViewYPosition
        
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = 5 //linkImages.count
        collectionView.register(UINib(nibName:"ExtensionHomeTravelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "ExtensionHomeTravelCollectionViewCell")
        collectionView.register(UINib(nibName:"NoExHomeTravelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "NoExHomeTravelCollectionViewCell")
        
        setupTableView()
        requestScheduleData()
        startTimer()
        
        
    }
    @IBAction func addTripButtonTapped(_ sender: UIButton) {
        let planningVC = storyboard?.instantiateViewController(withIdentifier: "PlanningVC") as! PlanningViewController
        
        navigationController?.pushViewController(planningVC, animated: true)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    
    func hideNavigation(){
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        // self.navigationItem.rightBarButtonItem?.tintColor = .clear
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //스크롤 위치
        let yOffset = scrollView.contentOffset.y + 80
        
        // 현재위치 :스크롤위치와 스티키 뷰의 초기 위치인 y중 더 큰값
        let newStickyViewYPosition = max(yOffset, initialStickyViewYPosition)
        let positionDifference = newStickyViewYPosition - initialStickyViewYPosition
        // 스티키 뷰를 더 큰값으로 갱신
        if stickyView.frame.origin.y != newStickyViewYPosition {
            stickyView.frame.origin.y = newStickyViewYPosition
            
            // 배경색 및 투명도 변경
            UIView.animate(withDuration: 0.1) {
                if positionDifference >= 0 {
                    self.upperView.backgroundColor = UIColor.white // 완전히 흰색으로 설정
                    self.smallLogo.alpha = 1.0 // 완전히 보이도록 설정
                    self.smallLogoText.alpha = 1.0
                } else {
                    self.upperView.backgroundColor = UIColor.clear // 투명하게 설정
                    self.smallLogo.alpha = 0.0 // 완전히 투명하게 설정
                    self.smallLogoText.alpha = 0.0
                }
                
                let alphaValue = max(0, min(positionDifference / 100, 1.0))
                
                self.stickyView.layer.shadowColor = UIColor.gray.cgColor
                self.stickyView.layer.shadowOpacity = Float(alphaValue)
                self.stickyView.layer.shadowRadius = alphaValue * 5
            }
        } else {
            // 스티키 뷰가 내려가서 고정되지 않을 때 투명하게 만들기
            UIView.animate(withDuration: 0.3) {
                self.upperView.backgroundColor = UIColor.clear // 투명하게 설정
                self.smallLogo.alpha = 0.0 // 완전히 투명하게 설정
                self.smallLogoText.alpha = 0.0
            }
        }
        
        
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
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExtensionHomeTravelCollectionViewCell", for: indexPath) as! ExtensionHomeTravelCollectionViewCell
        //  cell.labelText.text = String(currentCellIndex)
        cell.images.image = websitesImages[indexPath.row]
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 각 셀의 크기를 지정
        var cgSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return cgSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebsiteViewController") as! WebsiteViewController
        vc.websites = websites
        vc.currentWebsite = indexPath.row
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
            cell.collectionView.reloadData()
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
            cell.collectionView.reloadData()
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
