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
    
    var map: GMSMapView!
    var places: [Place]!
    var startDate: String?
    var endDate: String?
    
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
        map.delegate = self
        
        view.addSubview(map)
        
        view.bringSubviewToFront(calendarButton)
    }
    
    // 여행지 데이터 호출 및 지도에 마커 표시
    func requestPlaceData() {
        let user = UserDefaults.standard.getLoginUser()!
        
        // 여행지 데이터 호출
        PlaceNetManager.shared.read(uid: user.uid!, startDate: startDate, endDate: endDate) { places in
            self.places = places
            
            // 마커 표시
            DispatchQueue.main.async {
                for place in places {
                    let position = CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!)
                    let marker = GMSMarker(position: position)
//                    marker.title =  place.name
//                    marker.snippet = place.visitDate
                    marker.userData = place
                    marker.map = self.map
                }
            }
        }
    }
    
    // 기간 설정 버튼 클릭
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        print(#function)
        let dateRangePickerVC = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerVC.delegate = self
        dateRangePickerVC.minimumDate = Date()
        dateRangePickerVC.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        
        dateRangePickerVC.selectedStartDate = nil
        dateRangePickerVC.selectedEndDate = nil
        dateRangePickerVC.selectedColor = .systemBlue
        
        let navigationController = UINavigationController(rootViewController: dateRangePickerVC)
        
        present(navigationController, animated: true)
        
    }

}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("클릭")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        let infoWindow = Bundle.main.loadNibNamed("MarkerInfoWindowView", owner: self, options: nil)![0] as! MarkerInfoWindowView
        //infoWindow.frame = CGRect(x: 0, y: 0, width: 175, height: 125)

        infoWindow.infoView.layer.cornerRadius = 10
        
        let place = marker.userData as! Place
        
        infoWindow.name.text = place.name
        infoWindow.date.text = place.visitDate
        infoWindow.spending.text = "\(place.totalSpending!)"
        
        return infoWindow
    }
}

// MARK: - CalendarDateRangePickerVCDelegate
extension MapViewController: CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        dismiss(animated: true)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.startDate = dateFormatter.string(from: startDate)
        self.endDate = dateFormatter.string(from: endDate)
        
        dismiss(animated: true) {
            self.map.clear()
            self.requestPlaceData()
        }
    }
    
    func didSelectStartDate(startDate: Date!) { }
    
    func didSelectEndDate(endDate: Date!) { }
    
}
