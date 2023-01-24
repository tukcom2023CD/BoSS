//
//  SecondCollectionViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/21.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var tripImage: UIImageView!
    
    @IBOutlet weak var tripTitle: UILabel!
    
    @IBOutlet weak var tripDate: UILabel!
    
    @IBOutlet weak var tripCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    public func configure() { //이미지랑 여행지이름만 넣음
        tripImage.image = UIImage(named: "tripimg2")
        tripTitle.text = "부산여행"
        tripDate.text = "2022.08.06 ~ 2022.08.12"
        tripCost.text = "경비:32000원"
       
    }

}
