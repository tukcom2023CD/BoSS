//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

class MyPageScheduleViewController: UIViewController {
    
    // 여행 일정 예시 데이터
    var schedule_1 : Schedule = Schedule(sid: 1, title: "서울 여행", region: "서울", start: "2023-01-05", stop: "2023-01-09", uid: 1)
    
    var schedule_2 : Schedule = Schedule(sid: 2, title: "부산 여행", region: "부산", start: "2023-01-10", stop: "2023-01-15", uid: 1)
    
    var schedule_3 : Schedule = Schedule(sid: 3, title: "경주 여행", region: "경주", start: "2023-01-20", stop: "2023-01-25", uid: 1)
    
    var schedule_4 : Schedule = Schedule(sid: 4, title: "인천 여행", region: "인천", start: "2023-02-13", stop: "2023-02-30", uid: 1)
    
    // 예시 데이터 배열
    lazy var scheduleData : [Schedule] = [schedule_1, schedule_2, schedule_3, schedule_4]
    
    // 여행상태 에시 데이터 배열
    var status = ["완료", "완료", "완료", "진행중"]
    
    // 여행 사진 예시 데이터
    let imageArray = [#imageLiteral(resourceName: "seoul"), #imageLiteral(resourceName: "busan"), #imageLiteral(resourceName: "gangwondo"), #imageLiteral(resourceName: "incheon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MyPageScheduleViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    // 컬렉션 뷰 cell 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleData.count
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
        cell.scheduleTitle.text = scheduleData[indexPath.row].title
        cell.regionLabel.text = scheduleData[indexPath.row].region
        cell.startLabel.text = scheduleData[indexPath.row].start
        cell.stopLabel.text = scheduleData[indexPath.row].stop
        cell.scheduleImage.image = imageArray[indexPath.row]
        cell.statusLabel.text = status[indexPath.row]
        cell.statusLabel.layer.cornerRadius = 30
        cell.statusLabel.layer.borderWidth = 2
        
        if cell.statusLabel.text == "완료" {
            cell.statusLabel.textColor = UIColor.lightGray
            cell.statusLabel.layer.borderColor = UIColor.lightGray.cgColor
        } else if cell.statusLabel.text == "진행중" {
            cell.statusLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.statusLabel.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
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
