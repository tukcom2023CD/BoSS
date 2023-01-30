//
//  FirstTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class FirstTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = [String]()
    
    var schedules: [Schedule]?
    
    func configure(){
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        //collectionCell register
        collectionView.register(UINib(nibName:"FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier : "FirstCollectionViewCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension FirstTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"FirstCollectionViewCell", for: indexPath) as! FirstCollectionViewCell
        
        let index = indexPath.item
        
        guard let schedule = schedules?[indexPath.item] else { return UICollectionViewCell() }
        
        //cell.configure()
        cell.tripDate.text = "\(schedule.start!) ~ \(schedule.stop!)"
        cell.tripState.text = "-"
        cell.tripTitle.text = "\(schedule.region!) 여행"
        cell.tripImage.image = UIImage(named: "tripimg")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: 120)
    }
    
  
}
