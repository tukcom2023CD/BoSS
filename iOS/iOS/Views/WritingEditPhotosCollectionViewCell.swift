//
//  WritingEditPhotosCollectionViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/04/13.
//

import UIKit

class WritingEditPhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photos: UIImageView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           photos.contentMode = .scaleAspectFit
           photos.clipsToBounds = true
       }
    
}
