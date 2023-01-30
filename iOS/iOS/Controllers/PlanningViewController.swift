//
//  PlanningViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/01/28.
//

import UIKit

import UIKit
import CalendarDateRangePicker

struct SlideViewConstant {
    static let slideViewHeight: CGFloat = 350
    static let cornerRadiusOfSlideView: CGFloat = 20
    static let animationTime: CGFloat = 0.3
    
}

class PlanningViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    var regionDataArray: [Region] = []
    @IBOutlet weak var slideUpView: UIView!
    
    
    @IBOutlet weak var placeNameCheck: UILabel!
    @IBOutlet weak var selectCheckButton: UIButton!//날짜 선택하기
    @IBOutlet weak var dateLabel: UILabel! //날짜 표시되는 라벨
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    var startDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    var endDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
    
    
    //Slide up view에 사용할 변수들
    let blackView = UIView()//슬라이드 뷰
    let animationTime = SlideViewConstant.animationTime
    var originalCenterOfslideUpView = CGFloat()
    var totalDistance = CGFloat()
    
    
    
    var regionDataManager = RegionDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SearchPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchPlaceTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        slideUpView.isHidden = true
        
        setupView()
        setupDatas()
        nextButton.isHidden = true
        nextButton.layer.cornerRadius = 10
        
    }
    
    //alertviewController -> push segue형태로 넣으려고 PlanningVC와 MainPlanVC 간접 segue 만든후 코드 연결
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "여행 계획을 세우시겠습니까?", message:
                                        nil, preferredStyle: .alert)

        let ok = UIAlertAction(title: "확인", style: .default) { action in
            self.tabBarController?.tabBar.isHidden = false
            
            let schedule = Schedule(region: self.placeNameCheck.text, start: "\(self.startDate!)", stop: "\(self.endDate!)")
            
            let index = self.navigationController!.viewControllers.count - 2
            let rootVC = self.navigationController?.viewControllers[index] as! HomeViewController
            
            rootVC.schedules.append(schedule)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        

//
//
//        let action = UIAlertAction(title: "네", style: .default, handler:  {(action) in
//                                   let vc = self.storyboard!.instantiateViewController(
//                                    withIdentifier: "MainPlanViewController") as! MainPlanViewController
//                                   self.present(vc, animated: true, completion: nil)
//
//                                   })
//        let cancel = UIAlertAction(title: "다시 정하기", style: .cancel, handler: nil)
//        alert.addAction(cancel)
//        alert.addAction(action)
//        //alert.modalTransitionStyle = UIModalTransitionStyle.partialCurl
//
//
//       // self.navigationController?.pushViewController(MainPlanViewController, animated: true)
//        present(alert, animated: true, completion: nil)
//
        
        
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
    
    //tableviewcell에 장소 데이터 넣기
    func setupDatas() {
        regionDataManager.makeRegionData()
        regionDataArray = regionDataManager.getRegionData()
    }
    
//slideupView 보이기
    func setupSlideView(){
        slideUpView.isHidden = false
        dateLabel.isHidden = true
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
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: TimeInterval(animationTime)) {
            self.blackView.alpha = 0
            self.slideUpView.layer.cornerRadius = 0
            self.slideUpView.backgroundColor = .clear
        }
        slideUpView.slideDownHide(animationTime)
        slideUpView.isHidden = false
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    //선택완료 버튼클릭 -> datepicker 보이기
    @IBAction func selectButtonCheck(_ sender: UIButton) {
        
        //datepicker 보이기
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        dateRangePickerViewController.minimumDate = Date()
        dateRangePickerViewController.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        dateRangePickerViewController.selectedStartDate = self.startDate
        dateRangePickerViewController.selectedEndDate = self.endDate
        dateRangePickerViewController.selectedColor = UIColor.systemBlue
        dateRangePickerViewController.titleText = "날짜를 선택해주세요!"
         

        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    
}
//tableview datasource랑 delegate 확장자
extension PlanningViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return regionDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPlaceTableViewCell", for: indexPath) as! SearchPlaceTableViewCell
        
        cell.tripImg.image = regionDataArray[indexPath.row].placeImage
        cell.title.text =  regionDataArray[indexPath.row].placeName
        cell.subtitle.text =  regionDataArray[indexPath.row].placeSubtitle
        cell.selectionStyle = .none
       
        return cell
    }
}
extension PlanningViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupSlideView()
        placeNameCheck.text = regionDataArray[indexPath.row].placeName
        // 세그웨이를 실행 -> 사용 예정
      //  performSegue(withIdentifier: "toPlanMain", sender: indexPath)
    }
}




extension PlanningViewController : CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        self.startDate = startDate
        self.endDate = endDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM d일 EEEE"
        
        
        dateLabel.text = "출발 : " + dateFormatter.string(from: startDate) + " \n" + "도착 : " + dateFormatter.string(from: endDate)
        self.navigationController?.dismiss(animated: true, completion: nil)
        dateLabel.isHidden = false
        nextButton.isHidden = false
        selectCheckButton.setTitle("날짜 재설정", for: .normal)
     
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


