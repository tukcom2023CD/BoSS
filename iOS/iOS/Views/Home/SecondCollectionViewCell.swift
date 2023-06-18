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
    
    @IBOutlet weak var outView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        
        
    }
    public func configure() {
        
        outView.backgroundColor = UIColor.white
        outView.layer.cornerRadius = 10
        outView.layer.borderWidth = 2
        outView.layer.borderColor = UIColor.gray.cgColor
        outView.alpha = 0.6
        tripImage.layer.cornerRadius = 5
        tripImage.layer.borderWidth = 3
        tripImage.layer.borderColor = UIColor(red: 0.0, green: 0.5, blue: 0.8, alpha: 0.5).cgColor


        //이미지랑 여행지이름만 넣음
        tripImage.image = UIImage(named: "tripimg2")
        tripTitle.text = "부산여행"
        tripDate.text = "2022.08.06 ~ 2022.08.12"
        tripCost.text = "경비:32000원"
       
    }

}
