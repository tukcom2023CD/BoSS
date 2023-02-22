//
//  MyPageSpendingViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit


class MyPageSpendingViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 지출내역 수
    var spendingCount = 0
    
    // 지출내역 구조체
    struct spendingData {
        var name : String?
        var quantiy : Int?
        var price : Int?
        var pid : Int?
    }
    
    let spendingImage = #imageLiteral(resourceName: "cash")
    // 각 지출내역에 대한 여행장소 배열
    var PlaceArray :[String] = []
    // 지출내역 구조체 배열
    var spendingArray : [Spending] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지출 내역 가져오기
        requestSpendingData()
    }
    
    // 그림자 설정 함수
    func setShadow(cell : UICollectionViewCell) {
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
        cell.layer.shadowOpacity = 0.25 // alpha 값
    }
    
    // 금액 콤마 표기 함수
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    // 지출내역 불러오기
    /// - parameter pid : 여행 장소 ID
    func requestSpendingData() {
        let user = UserDefaults.standard.getLoginUser()!
        
        // 유저의 모든 여행장소 정보 가져와 pid값 저장
        PlaceNetManager.shared.read(uid: user.uid!) { places in
            for place in places {
                
                SpendingNetManager.shared.read(pid: place.pid!) { spendings in
                    // 지출 내역 수
                    self.spendingCount += spendings.count
                    
                    // 지출내역 배열 저장
                    for x in 0...spendings.count - 1 {
                        self.spendingArray.append(spendings[x])
                        self.PlaceArray.append(place.name!)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            
        }
    }
}

extension MyPageSpendingViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    // cell 개수 지정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.spendingCount
    }
    
    // cell 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let spendingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "spendingCollectionViewCell", for: indexPath) as? spendingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // cell UI 설정
        spendingCell.layer.cornerRadius = 30 // 모서리
        setShadow(cell : spendingCell) // 그림자
        
        // cell 내용 설정
        spendingCell.spendingImage.image = self.spendingImage
        spendingCell.spendingName.text = spendingArray[indexPath.row].name
        spendingCell.spendingPlace.text = PlaceArray[indexPath.row]
        spendingCell.spendingPrice.text = numberFormatter(number:(spendingArray[indexPath.row].price!))
        
        return spendingCell
    }
}

class spendingCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var spendingImage: UIImageView!
    @IBOutlet weak var spendingName: UILabel!
    @IBOutlet weak var spendingPlace: UILabel!
    @IBOutlet weak var spendingPrice: UILabel!
}


