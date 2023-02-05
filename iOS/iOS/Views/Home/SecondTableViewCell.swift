//
//  SecondTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
extension SecondTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
        //cell.configure()
        
        guard let schedule = schedules?[indexPath.item] else { return UICollectionViewCell() }
        
        cell.tripTitle.text = schedule.title
        cell.tripDate.text = "\(schedule.start!) ~ \(schedule.stop!)"
        
        //        cell.configure(with: model[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let schedule = schedules![indexPath.item]
        didSelectItem?(schedule)
    }
}
