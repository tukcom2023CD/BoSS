//
//  PlaceLocationMapTableViewCell.swift
//  iOS
//
//  Created by 이정동 on 2023/02/07.
//

import UIKit
import GoogleMaps

class PlaceLocationMapTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    
    var mapView: GMSMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let camera = GMSCameraPosition(latitude: 36, longitude: 127.5, zoom: 7)
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: 393, height: self.frame.size.height), camera: camera)
        
        addSubview(mapView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
