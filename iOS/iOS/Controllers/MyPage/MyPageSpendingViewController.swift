//
//  MyPageSpendingViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit


class MyPageSpendingViewController: UIViewController {
    
    // 지출내역 수
    var spendingCount = 10
    
    // 지출내역 구조체
    struct spendingData {
        var name : String?
        var quantiy : Int?
        var price : Int?
        var pid : Int?
    }
    
    let spendingImage = #imageLiteral(resourceName: "cash")
    
    // 지출내역 구조체 배열
    var spendingDataArray : [spendingData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spendingDataArray = makeSpendingDataArray(Count: spendingCount)
    }

    // 지출 내역 구조체 배열 생성 함수
    func makeSpendingDataArray(Count : Int) -> [spendingData] {
        var arr : [spendingData] = []
        for _ in 1...Count {
            var spData = spendingData()
            spData.name = "지출내역" + String(Count)
            spData.quantiy = 1
            spData.price = 10000
            spData.pid = Int.random(in: 1...5)
            arr.append(spData)
        }
        return arr
    }
    
    // 그림자 설정 함수
    func setShadow(view : UIView) {
        view.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        view.layer.masksToBounds = false // 그림자 잘림 방지
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        view.layer.shadowRadius = 5 // 그림자 반경
        view.layer.shadowOpacity = 0.3 // alpha 값
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
        spendingCell.layer.cornerRadius = 30
        spendingCell.layer.borderColor = UIColor.lightGray.cgColor
        spendingCell.layer.borderWidth = 0.5
        setShadow(view : spendingCell.contentView)
        
        // cell 내용 설정
        spendingCell.spendingImage.image = self.spendingImage
        spendingCell.spendingName.text = spendingDataArray[indexPath.row].name
        spendingCell.spendingPlace.text = String(spendingDataArray[indexPath.row].pid!)
        spendingCell.spendingPrice.text = String(spendingDataArray[indexPath.row].price!)

        return spendingCell
    }
}

class spendingCollectionViewCell : UICollectionViewCell {
    
   
    @IBOutlet weak var spendingImage: UIImageView!
    @IBOutlet weak var spendingName: UILabel!
    @IBOutlet weak var spendingPlace: UILabel!
    @IBOutlet weak var spendingPrice: UILabel!
}


