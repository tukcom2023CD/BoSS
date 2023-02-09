//
//  MyPageScheduleViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit

class MyPageScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 여행 일정 제목, 사진
    let titleArray = ["서울 여행", "부산 여행", "강원도 여행", "인천 여행"]
    let imageArray = [#imageLiteral(resourceName: "seoul"), #imageLiteral(resourceName: "busan"), #imageLiteral(resourceName: "gangwondo"), #imageLiteral(resourceName: "incheon")]
    
    // 컬렉션 뷰 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell", for: indexPath) as?
                CustomScheduleCollecionCell else {
                return UICollectionViewCell()
            }
        
        // cell 설정
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
        cell.layer.shadowOpacity = 0.3 // alpha값
        
        // cell 내용 설정
        cell.ScheduleTitle.text = titleArray[indexPath.row]
        cell.ScheduleImage.image = imageArray[indexPath.row]
        cell.ScheduleImage.layer.cornerRadius = 25
        cell.ScheduleImage.clipsToBounds = true
        
        return cell
    }
    
    // 상단바 표현
    @IBOutlet weak var horizontal_bar: UILabel!
    
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
    @IBOutlet weak var ScheduleTitle: UILabel!
    @IBOutlet weak var ScheduleImage: UIImageView!
}
