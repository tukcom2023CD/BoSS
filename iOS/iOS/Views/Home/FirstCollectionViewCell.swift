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
        tripImage.layer.borderWidth = 2
        tripImage.layer.borderColor = UIColor(red: 0.0, green: 0.5, blue: 0.8, alpha: 0.5).cgColor
    }
 
   
}

