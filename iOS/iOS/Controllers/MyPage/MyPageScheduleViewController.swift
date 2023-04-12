//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

class MyPageScheduleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var hasSchedule : Bool = false // 스케줄 존재 여부
    var currentCellSid : Int? // 현재 셀 sid
    var scheduleCount = 0 // 스케줄 개수
    var scheduleArray : [Schedule] = [] // 스케줄 배열
    var scheduleStausArray : [String] = [] // 스케줄 상태 배열
    let exampleScheduleImage = #imageLiteral(resourceName: "여행사진 1") // 예시 스케줄 사진
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스케줄 업데이트 신호를 받아 컬렉션 뷰 셀 리로드
        NotificationCenter.default.addObserver(self, selector: #selector(requestScheduleData), name: NSNotification.Name("ScheduleUpdated"), object: nil)
        
        // 스크롤 방향 설정
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        // 시트 설정
        if #available(iOS 15.0, *) {
            if let sheetPresentationController = sheetPresentationController {
                sheetPresentationController.detents = [.medium()]
                sheetPresentationController.preferredCornerRadius = 20
                sheetPresentationController.prefersGrabberVisible = true
            }
        } else {
            // Fallback on earlier versions
        }
        requestScheduleData()
    }
    
    // 여행 일정 불러오기
    @objc func requestScheduleData() {
        print("일정 불러옴")
        let user = UserDefaults.standard.getLoginUser()!
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            self.scheduleStausArray = []
            self.scheduleCount = schedules.count // 스케줄 개수 저장
            if schedules.count > 0 { // 스케줄 개수가 0보다 크면
                self.hasSchedule = true
            }
            self.scheduleArray = schedules // 스케줄 저장
            self.discriminationScheduleData(schedules: self.scheduleArray) // 일정 상태 구분
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // DB 일정 삭제 함수
    func deleteScheduleFromDB() {
        ScheduleNetManager.shared.delete(sid : self.currentCellSid!) {
        }
    }
    
    func reloadAfterDeleteSchedule() {
        self.scheduleCount -= 1
        if self.scheduleCount == 0 {
            self.hasSchedule = false
        }
        let index = self.scheduleArray.firstIndex(where: {$0.sid == currentCellSid})
        self.scheduleArray.remove(at: index!)
        self.scheduleStausArray.remove(at: index!)
        self.collectionView.reloadData()
    }
    
    // 스케줄 상태(완료, 진행중, 예정) 구분
    func discriminationScheduleData(schedules: [Schedule]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let currentDate = formatter.string(from: Date())
        for schedule in schedules {
            if currentDate > schedule.stop! {
                self.scheduleStausArray.append("완료")
            } else if (currentDate >= schedule.start! && currentDate <= schedule.stop!) {
                self.scheduleStausArray.append("진행중")
            } else {
                self.scheduleStausArray.append("예정")
            }
        }
    }
    
    // cell UI 설정함수
    func setUpCellUI(cell : CustomScheduleCollecionCell) {
        
        // cell 자체 설정
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 20 // 둥근 모서리
        cell.layer.masksToBounds = false
        
        // cell 그림자 설정
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        
        // cell 내부 이미지 설정
        cell.scheduleImage.image = self.exampleScheduleImage
        cell.scheduleImage.contentMode = .scaleAspectFill
        cell.scheduleImage.layer.cornerRadius = 15 // 둥근 모서리
        cell.scheduleImage.layer.masksToBounds = true // 둥근 모서리에 맞게 자름
        
        // 셀 설정 버튼 설정
        cell.cellSettingButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
    
    func setColor(text : String) -> UIColor {
        if text == "완료" {
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        } else if text == "진행중" {
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
    }
    
    // 금액에 콤마를 포함하여 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 총 지출 내역 불러오기
    func loadSpendingData(sid : Int, spendingLabel : UILabel) {
        var scheduleTotalSpending = 0
        PlaceNetManager.shared.read(sid: sid) { places in
            for place in places {
                SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                    for spending in spendings {
                        scheduleTotalSpending += Int(spending.price!)
                    }
                    DispatchQueue.main.async {
                        spendingLabel.text = self.numberFormatter(number: scheduleTotalSpending)
                    }
                }
            }
        }
        if scheduleTotalSpending == 0 {
            DispatchQueue.main.async {
                spendingLabel.text = self.numberFormatter(number: scheduleTotalSpending)
            }
        }
    }
}

extension MyPageScheduleViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    // 컬렉션 뷰 cell 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.hasSchedule == false {
            return 1
        } else {
            return self.scheduleCount
        }
    }

    // 컬렉션 뷰 cell 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.hasSchedule == false {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell_2", for: indexPath) as?
                    CustomScheduleCollecionCell_2 else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell", for: indexPath) as?
                    CustomScheduleCollecionCell else {
                return UICollectionViewCell()
            }
            
            self.setUpCellUI(cell: cell) // 셀 UI 설정

            // cell 내용 설정
            cell.sid = scheduleArray[indexPath.row].sid
            cell.scheduleTitle.text = scheduleArray[indexPath.row].title
            cell.regionLabel.text = scheduleArray[indexPath.row].region
            cell.startLabel.text = scheduleArray[indexPath.row].start
            cell.stopLabel.text = scheduleArray[indexPath.row].stop
            cell.statusLabel.text = scheduleStausArray[indexPath.row]
            
            // 스케줄 상태표시 라벨 설정
            cell.statusLabel.textColor = setColor(text: cell.statusLabel.text!)
            cell.statusImage.tintColor = setColor(text: cell.statusLabel.text!)
            
            // 금액 표시
            self.loadSpendingData(sid : scheduleArray[indexPath.row].sid!, spendingLabel : cell.totalSpending)
        
            // 메뉴 설정
            let menuItems : [UIAction] = [
                UIAction(title: "일정 편집", image: UIImage(systemName: "square.and.pencil")){ _ in
                self.currentCellSid = cell.sid
                self.moveEditScehduleScreen()
            }, UIAction(title: "일정 삭제", image: UIImage(systemName: "trash"), attributes: .destructive){ _ in
                self.currentCellSid = cell.sid
                self.arletDeleteSchedule()
            }] // 메뉴 아이템 생성
            let UIMenu = UIMenu(title : "일정 설정 메뉴", children : menuItems) // 메뉴 생성
            cell.cellSettingButton.menu = UIMenu // 버튼에 메뉴 등록
            cell.cellSettingButton.showsMenuAsPrimaryAction = true // 클릭시 즉시 메뉴 표시
            
            return cell
        }
    }
    
    // 일정 삭제 선택시 알림
    @objc func arletDeleteSchedule() {
        // 로그아웃에 대한 알림
        let alertController = UIAlertController(title: "일정 삭제", message: "일정에 대한 모든 데이터가 삭제됩니다.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            print("취소")
            alertController.dismiss(animated: true, completion: nil)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            print("삭제")
            self.reloadAfterDeleteSchedule() // 스케줄 삭제후 화면 다시 표시
            self.deleteScheduleFromDB() // 스케줄 DB에서 삭제
            alertController.dismiss(animated: true){}
        }
        alertController.addAction(cancelAction) // 액션 추가
        alertController.addAction(deleteAction) // 액션 추가
        present(alertController, animated: true, completion: nil)
    }

    // 일정 편집 화면으로 이동하는 함수
    func moveEditScehduleScreen() {
        guard let scheduleEditVC = self.storyboard?.instantiateViewController(identifier: "scheduleEditVC") as? ScheduleEditViewController else {return}
        scheduleEditVC.modalPresentationStyle = .fullScreen
        scheduleEditVC.modalTransitionStyle = .coverVertical
        
        if let index = self.scheduleArray.firstIndex(where: {$0.sid == currentCellSid})  {
            if let sid = self.scheduleArray[index].sid  {
                scheduleEditVC.scheduleSID = sid
            }
            if let title = self.scheduleArray[index].title  {
                scheduleEditVC.scheduletTitle = title
            }
            if let start = self.scheduleArray[index].start  {
                scheduleEditVC.scheduletStart = start
            }
            if let stop = self.scheduleArray[index].stop  {
                scheduleEditVC.scheduletStop = stop
            }
            if let region = self.scheduleArray[index].region  {
                scheduleEditVC.regionTitle = region
            }
        }
        self.present(scheduleEditVC, animated: true)
    }
}

// 셀 설정
class CustomScheduleCollecionCell : UICollectionViewCell {
    var sid : Int? // sid
    @IBOutlet weak var scheduleTitle: UILabel! // 스케줄 이름
    @IBOutlet weak var scheduleImage: UIImageView! // 스케줄 이미지
    @IBOutlet weak var regionLabel: UILabel! // 스케줄 지역
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var startLabel: UILabel! // 스케줄 시작 날짜
    @IBOutlet weak var stopLabel: UILabel! // 스케줄 종료 날짜
    @IBOutlet weak var statusLabel: UILabel! // 스케줄 상태
    @IBOutlet weak var totalSpending: UILabel! // 지출 금액
    @IBOutlet weak var cellSettingButton: UIButton! // 설정 버튼
}


class CustomScheduleCollecionCell_2 : UICollectionViewCell {
}
