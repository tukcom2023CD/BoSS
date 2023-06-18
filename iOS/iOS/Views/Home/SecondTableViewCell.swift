//
//  SecondTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indexLabel: UILabel!

    var schedules: [Schedule]?
    
    var didSelectItem: ((_ schedule: Schedule)->())? = nil
    
    func configure(){
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        collectionView.register(UINib(nibName:"SecondCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "SecondCollectionViewCell")
        collectionView.register(UINib(nibName: "BlankCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BlankCollectionViewCell")

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
extension SecondTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (schedules?.isEmpty) == true {
            indexLabel.text = "0/0"
        }
        else{
            if let count = schedules?.count {
                indexLabel.text = "▹ \(count)번의 여행기록이 있습니다."
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
