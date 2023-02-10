//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

class MyPageScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 상단바 표현
    @IBOutlet weak var horizontal_bar: UILabel!
    
    // 여행 일정 예시 데이터
    var schedule_1 : Schedule = Schedule(sid: 1, title: "서울 여행", region: "서울", start: "2023-01-05", stop: "2023-01-09", uid: 1)
    
    var schedule_2 : Schedule = Schedule(sid: 2, title: "부산 여행", region: "부산", start: "2023-01-05", stop: "2023-01-09", uid: 1)
    
    var schedule_3 : Schedule = Schedule(sid: 3, title: "경주 여행", region: "경주", start: "2023-01-05", stop: "2023-01-09", uid: 1)
    
    var schedule_4 : Schedule = Schedule(sid: 4, title: "인천 여행", region: "인천", start: "2023-01-05", stop: "2023-01-09", uid: 1)
    
    // 예시 데이터 배열
    lazy var scheduleData : [Schedule] = [schedule_1, schedule_2, schedule_3, schedule_4]
    
    // 여행 일정 제목, 사진 예시 데이터
    let imageArray = [#imageLiteral(resourceName: "seoul"), #imageLiteral(resourceName: "busan"), #imageLiteral(resourceName: "gangwondo"), #imageLiteral(resourceName: "incheon")]
    
    // 컬렉션 뷰 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleData.count // 셀 개수 설정
    }

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
        
        cell.scheduleImage.layer.cornerRadius = 25
        cell.scheduleImage.clipsToBounds = true
        
        return cell
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        horizontal_bar.clipsToBounds = true
        horizontal_bar.layer.cornerRadius = 5
    }
}

class CustomScheduleCollecionCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitle: UILabel!
    @IBOutlet weak var scheduleImage: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
}
