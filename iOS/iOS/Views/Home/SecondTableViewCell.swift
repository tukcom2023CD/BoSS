//
//  SecondTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit
import Lottie
class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var recordView: UIView!
    var schedules: [Schedule]?
    @IBOutlet weak var label: UILabel!
    var didSelectItem: ((_ schedule: Schedule)->())? = nil
    var scheduleImageDict : [Int : [String]] = [:] // 스케줄 이미지 딕셔너리
    
    func configure(){
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.font = UIFont.fontSUITEBold(ofSize: 20)
        indexLabel.font = UIFont.fontSUITEBold(ofSize: 12)
        
        // 사진 불러오기
        requestScheduleIamge()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        collectionView.register(UINib(nibName:"SecondCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "SecondCollectionViewCell")
        collectionView.register(UINib(nibName: "BlankCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BlankCollectionViewCell")
        
        let animationView = LottieAnimationView(name: "record")
        
        
        animationView.frame = CGRect(x: 0, y: 0, width: 60, height: 60) // 원하는 크기로 설정
        animationView.center = recordView.center
        animationView.loopMode = .loop
        // 애니메이션 재생
        animationView.play()
        
        // 애니메이션 뷰를 planView의 서브뷰로 추가
        recordView.addSubview(animationView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
  
// MARK: - 금액 3자리수 마다 , 붙이기
func numberFormatter(number: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value: number))!
}
    // 일정에 대한 사진 불러오는 함수
    func requestScheduleIamge() {
        self.scheduleImageDict = [:] // Dict 초기화
        let user = UserDefaults.standard.getLoginUser()!
        let group = DispatchGroup() // 비동기 함수 그룹 생성
        group.enter()
        ScheduleNetManager.shared.read(uid: user.uid!) { schedules in
            for schedule in schedules {
                let urlArray : [String] = [] // 사진 URL 배열
                self.scheduleImageDict[schedule.sid!] = urlArray // 딕셔너리 값추가
                group.enter()
                PlaceNetManager.shared.read(sid: schedule.sid!) { places in
                    if let firstPlace = places.first { // 첫 번째 장소만 사용
                        group.enter()
                        PhotoNetManager.shared.read(uid: user.uid!, pid: firstPlace.pid!) { photos in
                            if let firstPhoto = photos.first { // 첫 번째 사진만 사용
                                self.scheduleImageDict[schedule.sid!]!.append(firstPhoto.imageUrl)
                            }
                            group.leave()
                        }
                    }
                    group.leave()
                }
            }
            group.leave()
        }
        group.notify(queue: .main) {
            //self.loadedImage = true
            self.collectionView.reloadData()
        }
    }
    
}
extension SecondTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (schedules?.isEmpty) == true {
            indexLabel.text = "완료된 여행정보가 없습니다."
        }
        else{
            if let count = schedules?.count {
                indexLabel.text = "▹ \(count)번의 여행기록이 있습니다"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if schedules?.isEmpty == true {
                    return 1
                } else {
                    return schedules?.count ?? 0
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if schedules?.isEmpty == true {
            let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCollectionViewCell", for: indexPath) as! BlankCollectionViewCell
            blankCell.textLabel.text = "완료된 여행정보가 없습니다"
            return blankCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
            
            guard let schedule = schedules?[indexPath.item] else { return UICollectionViewCell() }
            
            cell.tripTitle.text = schedule.title
            cell.tripDate.text = "\(schedule.start!) ~ \(schedule.stop!)"
            //places : read(sid:completion:) 함수에서 받아온 여행지 데이터 배열
    
                   PlaceNetManager.shared.read(sid: schedule.sid ?? 0) { places in
                       let totalSpending = places.reduce(0) { $0 + ($1.totalSpending ?? 0) }
                       DispatchQueue.main.async {
                           cell.tripCost.text = "\(self.numberFormatter(number: totalSpending)) 원"
                           
                           if let imageUrl = self.scheduleImageDict[schedule.sid!]?.first {
                               DispatchQueue.global().async {
                                   let cacheKey = NSString(string: imageUrl)
                                   if let cachedImage = AlbumImageCacheManager.shared.object(forKey: cacheKey) {
                                       DispatchQueue.main.async {
                                           cell.tripImage.image = cachedImage
                                       }
                                   } else {
                                       if let imageURL = URL(string: imageUrl),
                                          let data = try? Data(contentsOf: imageURL),
                                          let image = UIImage(data: data) {
                                           AlbumImageCacheManager.shared.setObject(image, forKey: cacheKey)
                                           DispatchQueue.main.async {
                                               cell.tripImage.image = image
                                           }
                                       }
                                   }
                               }
                           } else {
                               cell.tripImage.image = #imageLiteral(resourceName: "noImage")
                           }
                       }
                   }
            
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if schedules?.isEmpty == true {
            return CGSize(width: collectionView.frame.width , height: 200)
        }
        return CGSize(width: collectionView.frame.width/2-6 , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if schedules?.isEmpty == true {
            // BlankCollectionViewCell인 경우에는 아무 동작도 수행하지 않음
            return
        }
        
        guard let schedule = schedules?[indexPath.item] else {
            // schedules 배열의 인덱스에 접근할 수 없는 경우
            return
        }
        
        didSelectItem?(schedule)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           if schedules?.isEmpty == true {
               // BlankCollectionViewCell을 정 가운데
               let collectionViewWidth = collectionView.bounds.width
               let collectionViewHeight = collectionView.bounds.height
               let blankCellSize = CGSize(width: collectionViewWidth, height: 200)
               
               let topInset = (collectionViewHeight - blankCellSize.height) / 2
               let bottomInset = topInset
               
               return UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
           } else {
               // FirstCollectionViewCell에는 인셋없이
               return .zero
           }
       }
}
