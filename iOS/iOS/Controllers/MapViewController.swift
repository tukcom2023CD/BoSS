//
//  MapViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/25.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CalendarDateRangePicker

class MapViewController: UIViewController {
    
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var subView: UIView!
    
    var viewBlurEffect: UIVisualEffectView!
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
        map = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), camera: camera)
        view.addSubview(map)
        
        view.bringSubviewToFront(calendarButton)
    }
    
    // 여행지 데이터 호출 및 지도에 마커 표시
    func requestPlaceData() {
        PlaceNetManager.shared.read { places in
            self.places = places
            
            DispatchQueue.main.async {
                for place in places {
                    let position = CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!)
                    let marker = GMSMarker(position: position)
                    marker.map = self.map
                }
            }
        }
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {

        let dateRangePickerVC = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerVC.delegate = self
        let navigationController = UINavigationController(rootViewController: dateRangePickerVC)
        
        
        present(navigationController, animated: true)
        
    }

}

extension MapViewController: CalendarDateRangePickerViewControllerDelegate {
    func didCancelPickingDateRange() {
        
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        
    }
    
    func didSelectStartDate(startDate: Date!) {
        
    }
    
    func didSelectEndDate(endDate: Date!) {
        
    }
    
    
}
