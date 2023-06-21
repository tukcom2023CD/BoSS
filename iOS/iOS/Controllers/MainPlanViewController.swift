//
//  MainPlanViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/01/29.
//

import UIKit

struct Section {
    var date: String
    var rows: [Place] = []
}

class MainPlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var tripTitle: UILabel!
    
    @IBOutlet weak var period: UILabel!

    @IBOutlet weak var outView: UIView!
    
    @IBOutlet weak var tableTopConstraints: NSLayoutConstraint!
    
    var schedule: Schedule!
    var places: [Place] = []
    
    var sections: [Section] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTopView()
        setupTableView()
        setupNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        NotificationCenter.default.addObserver(self, selector: #selector(updateScheduleData), name: NSNotification.Name("ScheduleUpdated"), object: nil)
        tableView.showsVerticalScrollIndicator = false
              tableView.showsHorizontalScrollIndicator = false
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestPlaceData()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    func setupTopView() {
        period.text = "\(schedule.start!) ~ \(schedule.stop!)"
        tripTitle.attributedText = NSAttributedString(
            string: schedule.title!,
            attributes: [
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -4.0
            ]
        )
    }
    
    func setupNavigationBar() {
        // "Edit" 버튼을 "수정"으로 변경
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(barButtonTapped))
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        // 네비게이션 바 버튼 색상 변경
        navigationController?.navigationBar.tintColor = .black

        // "Back" 버튼 숨기기
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftItemsSupplementBackButton = true
        

  
        
        //옵셔널 없애기

        if let tripTitleText = tripTitle.text?.components(separatedBy: " ").first,
           let periodText = period.text {
               let components = periodText.components(separatedBy: " ")
               if components.count == 3 {
                   let startDateComponents = components[0].components(separatedBy: ".")
                   let endDateComponents = components[2].components(separatedBy: ".")
                   
                   if startDateComponents.count == 3 && endDateComponents.count == 3 {
                       let startMonthDay = "\(startDateComponents[0]).\(startDateComponents[1]).\(startDateComponents[2])"
                       let endMonthDay = "\(endDateComponents[1]).\(endDateComponents[2])"
                       
                       let formattedPeriodText = "\(startMonthDay) ~ \(endMonthDay)"
                       navigationItem.title = "\(tripTitleText) \(formattedPeriodText)"
                   }
               }
           } else {
               navigationItem.title = ""
           }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0)]
       
    }
    
    func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        tableView.register(UINib(nibName: "MainPlanHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MainPlanHeaderView")
        tableView.register(UINib(nibName: "MainPlanTableViewCell", bundle: nil), forCellReuseIdentifier: "MainPlanTableViewCell")
        tableView.register(UINib(nibName: "MainPlanFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MainPlanFooterView")
    }
    
    // MARK: -  여행지 데이터 호출
    func requestPlaceData() {
        PlaceNetManager.shared.read(sid: schedule.sid!) { places in
            self.places = places
            
            self.extractScheduleDate(schedules: [self.schedule])
            self.setupSection()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: -  여행 날짜 추출
    /// - parameter schedules : 모든 일정 데이터
    func extractScheduleDate(schedules: [Schedule]) {
        sections.removeAll()
        for schedule in schedules {
            let start = CustomDateFormatter.format.date(from: schedule.start!)!
            let stop = CustomDateFormatter.format.date(from: schedule.stop!)!
            
            let interval = start.distance(to: stop) // 시작, 종료 날짜까지의 TimeInterval
            let days = Int(interval / 86400) // 시작, 종료 날짜까지의 Day
            
            for i in 0...days {
                let event = start.addingTimeInterval(TimeInterval(86400 * i))
                let eventStr = CustomDateFormatter.format.string(from: event)
                //eventDates.append(eventStr)
                
                sections.append(Section(date: eventStr))
            }
        }
        print(sections)
    }
    
    // MARK: -  섹션 설정
    func setupSection() {
        for place in places {
            for index in 0..<sections.count {
                if sections[index].date == place.visitDate! {
                    sections[index].rows.append(place)
                }
            }
        }
    }
    
    @objc func barButtonTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "scheduleEditVC") as! ScheduleEditViewController
        vc.schedule = schedule
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func updateScheduleData() {
        // 여행일정 업데이트 감지 시
        // 1. 여행일정 데이터 불러오기 (변경된 일정을 파악하기 위함)
        // 2. 기존 일정보다 줄었을 시 변경된 마지막 일정을 넘어선 여행지 데이터 모두 삭제
        // 3. 여행지 데이터 불러오기
    }
}

// MARK: - TableViewDataSource, Delegate
extension MainPlanViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate,UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          if scrollView == tableView {
              let offsetY = scrollView.contentOffset.y
              
              // 테이블의 top부분 계산
              let maxTopSpacing: CGFloat = 130.0 // 초기 간격
              let minTopSpacing: CGFloat = 0.0 // 최소 간격
              let totalScrollDistance = maxTopSpacing - minTopSpacing
              let currentTopSpacing = max(maxTopSpacing - offsetY, minTopSpacing)
              
              // 업데이트 된 top
              tableTopConstraints.constant = currentTopSpacing
              
              // Calculate the alpha value for the upperView
              let maxAlpha: CGFloat = 1.0
              let minAlpha: CGFloat = 0.0
              let currentAlpha = max(minAlpha, maxAlpha - (offsetY / totalScrollDistance))
              
              // 업데이트된 upperView투명도
              upperView.alpha = currentAlpha
              
              //업데이트된 타이틀 투명도
              let titleAlpha = 1.0 - currentAlpha
              navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(titleAlpha)]
              
              // 서서히 애니메이션으로
              UIView.animate(withDuration: 0.2) {
                  self.view.layoutIfNeeded()
              }
          }
      }
  




    // 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 섹션 내 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    // 섹션 내 행
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainPlanTableViewCell", for: indexPath) as! MainPlanTableViewCell
        
        cell.placeName.text = sections[indexPath.section].rows[indexPath.row].name
        cell.totalSpending.text = "\(sections[indexPath.section].rows[indexPath.row].totalSpending!)원"
        
        return cell
    }
    
    // 섹션 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainPlanHeaderView") as! MainPlanHeaderView
        
        view.day.text = "Day \(section+1)"
        view.date.text = sections[section].date
        
        return view
    }
    
    // 섹션 푸터
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainPlanFooterView") as! MainPlanFooterView
        
        view.didSelectButton = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchPlaceVC") as! SearchPlaceViewController
            vc.visitDate = self.sections[section].date
            vc.scheduleId = self.schedule.sid!
            vc.localLabel = self.tripTitle.text?.components(separatedBy: " ").first
            print(vc.localLabel ?? "no")
           
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return view
    }
    
    // 섹션 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // 섹션 내 행 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 섹션 푸터 높이
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none // 선택 스타일 설정

        
        let vc = storyboard?.instantiateViewController(withIdentifier: "WritingPageViewController") as! WritingPageViewController
        vc.navigationItem.title = sections[indexPath.section].rows[indexPath.row].name
      
        
        let place = sections[indexPath.section].rows[indexPath.row]
        
        // 1. 다음 화면으로 place 데이터 전달
        vc.place = place
        // 2. 지출 내역, 사진 네트워킹 시작
        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
            
            vc.spendings = spendings
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        // 3. 두 네트워킹 종료 후 화면 이동
    }
    
    // 셀 스와이프
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { _, _, completion in
            
            let place = self.sections[indexPath.section].rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            PlaceNetManager.shared.delete(place.pid!) {
                completion(true)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var cell = sections[sourceIndexPath.section].rows[sourceIndexPath.row]
        cell.visitDate = sections[destinationIndexPath.section].date
        
        
        sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        sections[destinationIndexPath.section].rows.insert(cell, at: destinationIndexPath.row)
        
        
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        present(alert, animated: true)
        
        PlaceNetManager.shared.update(place: cell) {
            DispatchQueue.main.async {
                alert.dismiss(animated: true)
            }
        }
    }
}
