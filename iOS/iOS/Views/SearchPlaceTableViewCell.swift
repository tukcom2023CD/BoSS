//
//  SearchPlaceTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/28.
//


import UIKit

class SearchPlaceTableViewCell: UITableViewCell {


    @IBOutlet weak var tripImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var subtitle: UILabel!
    var placeData: SearchPlace!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        tripImg.layer.borderWidth = 1.0
        tripImg.layer.masksToBounds = false
        tripImg.layer.borderColor = UIColor.gray.cgColor
        tripImg.layer.cornerRadius = tripImg.frame.size.width / 2
        tripImg.clipsToBounds = true
       
          }
          public func configure() { //이미지랑 여행지이름만 넣음
              tripImg.image =
              placeData.placeImage
              title.text = placeData.placeName
              subtitle.text = placeData.placeSubtitle
          
         }
    
    
}
