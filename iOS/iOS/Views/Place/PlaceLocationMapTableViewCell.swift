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
    var coordinate: CLLocationCoordinate2D?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let camera = GMSCameraPosition(latitude: 0, longitude: 0, zoom: 15)
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height), camera: camera)
        
        addSubview(mapView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let coordinate = coordinate else { return }
        
        let camera = GMSCameraUpdate.setTarget(coordinate)
        mapView.animate(with: camera)

        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        
        // Configure the view for the selected state
    }
    
}
