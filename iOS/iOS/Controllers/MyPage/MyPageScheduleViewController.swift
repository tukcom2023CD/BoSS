//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

class MyPageScheduleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var scheduleCount = 0 // 스케줄 개수
    var sidArray : [Int] = [] // sid 배열
    var scheduleArray : [Schedule] = [] // 스케줄 배열
    var scheduleStausArray : [String] = [] // 스케줄 상태 배열
    let exampleScheduleImage = #imageLiteral(resourceName: "여행사진 1") // 예시 스케줄 사진
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestScheduleData()
    }
    
    // 여행 일정 불러오기
    func requestScheduleData() {
        let user = UserDefaults.standard.getLoginUser()!
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            self.scheduleCount = schedules.count // 스케줄 개수 저장
            self.scheduleArray = schedules // 스케줄 저장
            self.discriminationScheduleData(schedules: self.scheduleArray) // 일정 상태 구분
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
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
    }
    
    func setColor(text : String) -> UIColor {
        if text == "완료" {
            return #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        } else if text == "진행중" {
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
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
    
    
    // 화면 닫기
    @IBAction func closeButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}

extension MyPageScheduleViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    // 컬렉션 뷰 cell 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.scheduleCount
    }

    // 컬렉션 뷰 cell 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell", for: indexPath) as?
                CustomScheduleCollecionCell else {
                return UICollectionViewCell()
            }
        
        self.setUpCellUI(cell: cell) // 셀 UI 설정
        
        // cell 내용 설정
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
        
        return cell
    }
}

// 셀 설정
class CustomScheduleCollecionCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitle: UILabel! // 스케줄 이름
    @IBOutlet weak var scheduleImage: UIImageView! // 스케줄 이미지
    @IBOutlet weak var regionLabel: UILabel! // 스케줄 지역
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var startLabel: UILabel! // 스케줄 시작 날짜
    @IBOutlet weak var stopLabel: UILabel! // 스케줄 종료 날짜
    @IBOutlet weak var statusLabel: UILabel! // 스케줄 상태
    @IBOutlet weak var totalSpending: UILabel! // 지출 금액
}

// 구현할 기능 :
// 일정 삭제

