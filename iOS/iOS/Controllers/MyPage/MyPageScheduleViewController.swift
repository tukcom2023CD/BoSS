//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

class MyPageScheduleViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 일정 개수
    var scheduleCount = 0
    // db 에서 받아온 사용자 여행 일정
    var dbSchedules : [Schedule] = []
    // 여행 일정 완료 여부 배열
    var scheduleStausArray : [String] = []
    // 여행 사진 예시 데이터
    let scheduleImage = #imageLiteral(resourceName: "tripimg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestScheduleData() // 여행 일정 불러옴
    }
    
    // 여행 일정 불러오기
    /// - parameter uid : 로그인 유저 ID
    func requestScheduleData() {
        let user = UserDefaults.standard.getLoginUser()!
        
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            // 일정 수 저장
            self.scheduleCount = schedules.count
            
            // 일정 배열 저장
            self.dbSchedules = schedules
            
            // 일정 상태 구분
            self.discriminationScheduleData(schedules: self.dbSchedules)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // 완료, 진행, 미완료 일정 구분
    /// - parameter schedules : 서버로부터 받은 여행 일정 데이터
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
        
        // cell 설정
        cell.layer.cornerRadius = 20 // 둥근 모서리
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
        cell.layer.shadowOpacity = 0.3 // alpha값
        
        // cell 내용 설정
        cell.scheduleTitle.text = dbSchedules[indexPath.row].title
        cell.regionLabel.text = dbSchedules[indexPath.row].region
        cell.startLabel.text = dbSchedules[indexPath.row].start
        cell.stopLabel.text = dbSchedules[indexPath.row].stop
        cell.scheduleImage.image = self.scheduleImage
        cell.statusLabel.text = scheduleStausArray[indexPath.row]
        cell.statusLabel.layer.cornerRadius = 30
        cell.statusLabel.layer.borderWidth = 2
        
        if cell.statusLabel.text == "완료" {
            cell.statusLabel.textColor = UIColor.lightGray
            cell.statusLabel.layer.borderColor = UIColor.lightGray.cgColor
        } else if cell.statusLabel.text == "진행중" {
            cell.statusLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.statusLabel.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else {
            cell.statusLabel.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            cell.statusLabel.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }
                
        // cell 내부 이미지 설정
        cell.scheduleImage.layer.cornerRadius = 30
        cell.scheduleImage.clipsToBounds = true
        
        return cell
    }
}

// cell
class CustomScheduleCollecionCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitle: UILabel!
    @IBOutlet weak var scheduleImage: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
}
