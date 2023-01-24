//
//  FirstCollectionViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tripImage: UIImageView!
    
    @IBOutlet weak var tripTitle: UILabel!
    
    @IBOutlet weak var tripDate: UILabel!
    
    @IBOutlet weak var tripState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        tripImage.layer.cornerRadius = tripImage.frame.height / 2
        tripImage.clipsToBounds = true
    }
    public func configure() { //이미지랑 여행지이름만 넣음
        tripImage.image = UIImage(named: "tripimg")
        tripTitle.text = " 경주여행 "
        tripDate.text = " 2023.01.10 ~2023.01.15 "
        tripState.text = " 🔵 여행중 "
    }
   
}

