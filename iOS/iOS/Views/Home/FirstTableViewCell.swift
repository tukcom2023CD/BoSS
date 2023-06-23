//
//  FirstTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit
import Lottie
class FirstTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var planView: UIView!
    
    @IBOutlet weak var indexLabel: UILabel!
    
    var didSelectItem: ((_ schedule: Schedule)->())? = nil
    
    var schedules: [Schedule]?
    var scheduleImageDict : [Int : [String]] = [:] // 스케줄 이미지 딕셔너리
    func configure(){
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 사진 불러오기
        requestScheduleIamge()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //collectionCell register
        collectionView.register(UINib(nibName:"FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "FirstCollectionViewCell")
        collectionView.register(UINib(nibName: "BlankCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BlankCollectionViewCell")
        
        // Lottie 애니메이션 뷰 생성
        let animationView = LottieAnimationView(name: "paperplane")
        
        // 애니메이션 뷰 크기 및 위치 설정
        animationView.frame = CGRect(x: 00, y: 0, width: 75, height: 75) // 원하는 크기로 설정
        animationView.center = planView.center
        animationView.loopMode = .loop
        // 애니메이션 재생
        animationView.play()
        
        // 애니메이션 뷰를 planView의 서브뷰로 추가
        planView.addSubview(animationView)
        collectionView.reloadData()
        
            }
            
            
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
    func updateIndexLabel() {
        if let selectedIndexPath = collectionView.indexPathsForVisibleItems.last {
            let currentItem = selectedIndexPath.item + 1
            if let count = schedules?.count {
                if currentItem != count {
                    indexLabel.text = "\(currentItem)/\(count)"
                } else {
                    indexLabel.text = "\(count)/\(count)"
                }
            }
        } else {
            indexLabel.text = "진행중인 여행정보가 없습니다."
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          if scrollView == collectionView {
              updateIndexLabel()
          }
      }
 
        
    // 여행 진행 상태 계산 (진행 or 예정)
    func calcTripState(startDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let now = formatter.string(from: Date())
        
        if now >= startDate {
            return "🔴 여행 중"
        } else {
            return "🟢 예정"
        }
    }
    
}


extension FirstTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules?.isEmpty == true ? 1 : schedules?.count ?? 0
        
        // return schedules?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if schedules?.isEmpty == true {
            let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlankCollectionViewCell", for: indexPath) as! BlankCollectionViewCell
            blankCell.textLabel.text = "등록된 여행정보가 없습니다"
            return blankCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
            
            guard let schedule = schedules?[indexPath.item] else { return UICollectionViewCell() }
            
            cell.tripDate.text = "\(schedule.start!) ~ \(schedule.stop!)"
            cell.tripState.text = calcTripState(startDate: schedule.start!)
            cell.tripTitle.text = schedule.title
            
                           PlaceNetManager.shared.read(sid: schedule.sid ?? 0) { places in
                               DispatchQueue.main.async {
                                   
                                   
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
        return CGSize(width: collectionView.frame.width , height: 120)
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
        
        
        //        let schedule = schedules![indexPath.item]
        //
        //        // 여행 일정 클릭 시 상세 일정 페이지로 이동
        //        didSelectItem?(schedule)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let visibleIndexPaths = collectionView.indexPathsForVisibleItems.first {
            if let count = schedules?.count {
                indexLabel.text = "\(visibleIndexPaths.item + 1)/\(count)"
            }
        } else {
            indexLabel.text = "진행중인 여행정보가 없습니다."
        }
    }
}
