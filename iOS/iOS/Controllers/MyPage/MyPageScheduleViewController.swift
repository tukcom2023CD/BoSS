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
    var scheduleArray : [Schedule] = [] // 스케줄 배열
    var scheduleStausArray : [String] = [] // 스케줄 상태 배열
    let exampleScheduleImage = #imageLiteral(resourceName: "tripimg") // 예시 스케줄 사진
    
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
        cell.layer.cornerRadius = 20 // 둥근 모서리
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
        cell.layer.shadowOpacity = 0.3 // alpha값
        
        // 스케줄 상태표시 라벨 설정
        cell.statusLabel.layer.cornerRadius = 30
        cell.statusLabel.layer.borderWidth = 2
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
        cell.statusLabel.textColor = setColor(text: cell.statusLabel.text!)
        cell.statusLabel.layer.borderColor = setColor(text: cell.statusLabel.text!).cgColor
        
        // cell 내부 이미지 설정
        cell.scheduleImage.image = self.exampleScheduleImage
        cell.scheduleImage.layer.cornerRadius = 30
        cell.scheduleImage.clipsToBounds = true
        
        return cell
    }
}

// cell
class CustomScheduleCollecionCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitle: UILabel! // 스케줄 이름
    @IBOutlet weak var scheduleImage: UIImageView! // 스케줄 이미지
    @IBOutlet weak var regionLabel: UILabel! // 스케줄 지역
    @IBOutlet weak var startLabel: UILabel! // 스케줄 시작 날짜
    @IBOutlet weak var stopLabel: UILabel! // 스케줄 종료 날짜
    @IBOutlet weak var statusLabel: UILabel! // 스케줄 상태
}
