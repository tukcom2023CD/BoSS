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
    
    @IBOutlet weak var tripTitle: UILabel!
    
    @IBOutlet weak var period: UILabel!
    
    var schedule: Schedule!
    var places: [Place] = []
    
    var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestPlaceData()
    }
    
    func setupUI() {
        period.text = "\(schedule.start!) ~ \(schedule.stop!)"
        tripTitle.attributedText = NSAttributedString(
            string: schedule.title!,
            attributes: [
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -3.0
            ]
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(barButtonTapped))
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
}

// MARK: - TableViewDataSource, Delegate
extension MainPlanViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    
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
        cell.totalSpending.text = "\(sections[indexPath.section].rows[indexPath.row].totalSpending!)"
        
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "WritingPageViewController") as! WritingPageViewController
        //여기서 작업시작
        
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
