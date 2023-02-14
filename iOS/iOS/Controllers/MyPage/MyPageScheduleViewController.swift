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

// cell
class CustomScheduleCollecionCell : UICollectionViewCell {
    @IBOutlet weak var scheduleTitle: UILabel!
    @IBOutlet weak var scheduleImage: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
}
