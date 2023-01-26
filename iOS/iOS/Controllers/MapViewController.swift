//
//  MapViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/25.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!
    
    var map: GMSMapView!
    var places: [Place]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMapView()
        requestPlaceData()
    }
    
    // 맵 불러오기
    func loadMapView() {
        
        // 카메라 위치
        let camera = GMSCameraPosition(latitude: 36, longitude: 127.5, zoom: 7)
        map = GMSMapView(frame: CGRect(x: 0, y: 0, width: mapView.frame.size.width, height: mapView.frame.size.height), camera: camera)
        mapView.addSubview(map)
    }


    func requestPlaceData() {
        PlaceNetManager.shared.read { places in
            self.places = places
            dump(self.places)
        }
    }
}
