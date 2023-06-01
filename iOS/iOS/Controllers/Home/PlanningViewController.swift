//
//  PlanningViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/01/28.
//

import UIKit
import CalendarDateRangePicker
import SwiftSoup

class PlanningViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slideUpView: UIView!
    
    @IBOutlet weak var placeNameCheck: UILabel!
    @IBOutlet weak var selectCheckButton: UIButton!//날짜 선택하기
    @IBOutlet weak var dateLabel: UILabel! //날짜 표시되는 라벨
    
    @IBOutlet weak var dateLabelBackView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var nodateLabel: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var startDate: String?
    var endDate: String?
    var localData = [String]()
    var filteredData: [String] = []
    //Slide up view에 사용할 변수들
    let blackView = UIView()//슬라이드 뷰
    let animationTime = SlideViewConstant.animationTime
    var originalCenterOfslideUpView = CGFloat()
    var totalDistance = CGFloat()
    let dateTextColor = UIColor(red: 100/255, green: 46/255, blue: 69/255, alpha: 1.0)
    let dateTextColorBefore = UIColor(red: 48/255, green: 38/255, blue: 145/255, alpha: 1.0)

    var regionDataManager = RegionDataManager()
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideUpView.isHidden = true
        selectCheckButton.setTitle("날짜 설정", for: .normal)
        selectCheckButton.setTitleColor(dateTextColor, for: .normal)
        selectCheckButton.tintColor = dateTextColor
        nextButton.isHidden = true
        setupView()
        setupTableView()
        nextButton.isHidden = true
        nextButton.layer.cornerRadius = 10
        seeNavigation()
        dateLabelSetting()
        localPasing()
        filteredData = localData
        searchBarSetting()
        searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
               tapGesture.cancelsTouchesInView = false // 테이블 뷰의 터치 이벤트와 키보드 내려가는 터치관련
        
               tableView.addGestureRecognizer(tapGesture)
       
    }
    // 테이블 뷰를 터치했을 때 키보드를 내리는 메서드
       @objc func handleTap() {
           searchBar.resignFirstResponder()
       }
    func searchBarSetting(){
        searchBar.searchBarStyle = .minimal // 선 제거
        searchBar.barTintColor = .white
        searchBar.placeholder = "여행장소를 빠르게 찾아보세요"
    }
    func seeNavigation(){
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    // 테이블 뷰 세팅
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
    }
    
    //alertviewController -> push segue형태로 넣으려고 PlanningVC와 MainPlanVC 간접 segue 만든후 코드 연결
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "생성하시겠습니까?", message:
                                        nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { action in
            
            let user = UserDefaults.standard.getLoginUser()!
            let schedule = Schedule(title: self.placeNameCheck.text! + " 여행", region: self.placeNameCheck.text, start: "\(self.startDate!)", stop: "\(self.endDate!)", uid: user.uid!)
            
            ScheduleNetManager.shared.create(schedule: schedule) {
                
                ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
                    DispatchQueue.main.async {
                        let index = self.navigationController!.viewControllers.count - 2
                        let rootVC = self.navigationController?.viewControllers[index] as! HomeViewController
                        
                        //rootVC.schedules.append(schedule)
                        rootVC.upcomingSchedules = schedules
                        rootVC.extractScheduleDate(schedules: schedules)
                        rootVC.divideScheduleData(schedules: schedules)
                        rootVC.tableView.reloadData()
                        //self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    private func setupView(){
        //slideUpView.isHidden = false
        slideUpView.frame =  CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: SlideViewConstant.slideViewHeight)
        slideUpView.layoutIfNeeded()
        slideUpView.addDropShadow(cornerRadius: SlideViewConstant.cornerRadiusOfSlideView)
        
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.frame = self.view.frame
        blackView.frame.size.height = self.view.frame.height
        blackView.alpha = 0
        self.view.insertSubview(blackView, belowSubview: slideUpView)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        let downPan = UIPanGestureRecognizer(target: self, action: #selector(dismissslideUpView(_:)))
        slideUpView.addGestureRecognizer(downPan)
        
    }
    
    //드래그해서 slideupView 끄는거 지정
    @objc func dismissslideUpView(_ gestureRecognizer:UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.slideUpView)
        switch gestureRecognizer.state{
        case .began, .changed:
            
            gestureRecognizer.view!.center = CGPoint(x: self.slideUpView.center.x, y: max(gestureRecognizer.view!.center.y + translation.y, originalCenterOfslideUpView))
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.slideUpView)
            totalDistance += translation.y
            break
        case .ended:
            //y축을 보고 많이 안내렸으면 handleDismiss()->안내려감. 그게 아니면 끄는 걸로
            if gestureRecognizer.velocity(in: slideUpView).y > 300 {
                handleDismiss()
            } else if totalDistance >= 0{
                UIView.animate(withDuration: TimeInterval(animationTime), delay: 0, options: [.curveEaseOut],
                               animations: {
                    self.slideUpView.center.y -= self.totalDistance
                    self.slideUpView.layoutIfNeeded()
                }, completion: nil)
            } else {
            }
            totalDistance = 0
            break
        case .failed:
            print("Failed ")
            break
        default:
            //default
            print("default")
            break
        }
        
    }
    
    
    
    //slideupView 보이기
    func setupSlideView(){
        slideUpView.isHidden = false
        dateLabel.isHidden = true
        nodateLabel.isHidden = false
        dateLabelBackView.isHidden = true
        totalDistance = 0
        slideUpView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: SlideViewConstant.slideViewHeight)
        UIView.animate(withDuration: TimeInterval(animationTime), animations: {
            self.blackView.alpha = 1
            self.slideUpView.backgroundColor = UIColor.white
            self.slideUpView.layer.cornerRadius = SlideViewConstant.cornerRadiusOfSlideView
            self.slideUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
        }, completion: nil)
        slideUpView.slideUpShow(animationTime)
        //self.tabBarController?.tabBar.isHidden = true
        originalCenterOfslideUpView = slideUpView.center.y
        selectCheckButton.setTitle("날짜 설정", for: .normal)
        selectCheckButton.setTitleColor(dateTextColor, for: .normal)
        selectCheckButton.tintColor = dateTextColor
        nextButton.isHidden = true
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: TimeInterval(animationTime)) {
            self.blackView.alpha = 0
            self.slideUpView.layer.cornerRadius = 0
            self.slideUpView.backgroundColor = .clear
        }
        slideUpView.slideDownHide(animationTime)
        slideUpView.isHidden = false
       
    }
    
    //선택완료 버튼클릭 -> datepicker 보이기
    @IBAction func selectButtonCheck(_ sender: UIButton) {
        
        //datepicker 보이기
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = Date()
        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateRangePickerViewController.selectedStartDate = nil
        dateRangePickerViewController.selectedEndDate = nil
        dateRangePickerViewController.selectedColor = UIColor.systemBlue
        dateRangePickerViewController.titleText = "날짜를 선택해주세요!"
        
        
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
        
    }
    
    //날짜 줄간격 설정
    func dateLabelSetting(){
        
        // 문자열에 줄 간격 설정하기
        let attributedString = NSMutableAttributedString(string: dateLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10 // 원하는 줄 간격으로 변경
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        // 라벨에 적용하기
        dateLabel.attributedText = attributedString
    }
    
    func localPasing(){
        guard let url = URL(string: "https://ko.wikipedia.org/wiki/%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD%EC%9D%98_%EC%9D%B8%EA%B5%AC%EC%88%9C_%EB%8F%84%EC%8B%9C_%EB%AA%A9%EB%A1%9D#%EA%B0%99%EC%9D%B4_%EB%B3%B4%EA%B8%B0") else {
            return
        }
        
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            
            let table: Element = try doc.select("table.wikitable").first()!
            let rows: Elements = try table.select("tr")
            
            let numRows = rows.count
            
            for (i, row) in rows.enumerated() {
                if i == numRows - 1 { // 맨 마지막 행에서는 반복문을 종료
                    break
                }
                let cols: Elements = try row.select("td:eq(1)")
                for col in cols {
                    let data = try col.text()
                    localData.append(data)
                    print(try col.text())
                }
            }
            
        } catch Exception.Error(let type, let message) {
            print("\(type) : \(message)")
        } catch {
            print("error")
        }
    }
 
}
extension PlanningViewController: UISearchBarDelegate{
    //검색어에 따라 필터링된 데이터를 저장한 후, 테이블 뷰를 업데이트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           // 검색어가 비어있는 경우 모든 데이터
           if searchText.isEmpty {
               filteredData = localData
           } else {
               // 검색어와 일치하는 데이터만 필터링저장
               filteredData = localData.filter { $0.lowercased().contains(searchText.lowercased()) }
           }

           // 테이블 뷰를 업데이트
           tableView.reloadData()
       }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
          
       }
       
       // 화면의 다른 곳을 터치하면 키보드를 내림
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           searchBar.resignFirstResponder()
       }

}

//tableview datasource랑 delegate 확장자
extension PlanningViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension PlanningViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupSlideView()
        // 선택한 셀의 정보
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            // 셀 내부의 라벨 정보 가져오기
            if let textLabel = selectedCell.textLabel {
                placeNameCheck.text = textLabel.text
            }
        }
    }
}




extension PlanningViewController : CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.startDate = CustomDateFormatter.format.string(from: startDate)
        self.endDate = CustomDateFormatter.format.string(from: endDate)
        
        dateLabel.text = "출발 : " + self.startDate! + " \n" + "도착 : " + self.endDate!
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        dateLabel.isHidden = false
        nodateLabel.isHidden = true
        dateLabelBackView.isHidden = false
        nextButton.isHidden = false
        selectCheckButton.setTitle("날짜 재설정", for: .normal)
        selectCheckButton.setTitleColor(dateTextColorBefore, for: .normal)
        selectCheckButton.tintColor = dateTextColorBefore
    }
    
    @objc func didSelectStartDate(startDate: Date!){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM d일 EEEE"
        print(dateFormatter.string(from: startDate))
    }
    
    @objc func didSelectEndDate(endDate: Date!){
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM d일 EEEE"
        print(dateFormatter.string(from: endDate))
    }
}


