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
import Lottie
class MapViewController: UIViewController {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewLabel: UILabel!
    @IBOutlet var topButton: [UIButton]!
    
    
    var map: GMSMapView!
    var startDate: String?
    var endDate: String?
    var minimumDate: String? = "2000.01.01"
    var maximumDate: String? = "2000.01.01"
    
    let dateRangePickerVC = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        loadMapView()
        requestPlaceData()
        setupTopView()
                applySUITEBoldFont()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
       
    }
    func applySUITEBoldFontToButtons() {
        for subview in self.view.subviews {
            applySUITEBoldFontToSubviews(subview)
        }
    }

    func applySUITEBoldFontToSubviews(_ view: UIView) {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.titleLabel?.font = UIFont.fontSUITEBold(ofSize: button.titleLabel?.font.pointSize ?? 0)
            } else {
                applySUITEBoldFontToSubviews(subview)
            }
        }
    }

    
    func setupTopView() {
        topView.layer.cornerRadius = 10
        topButton.forEach { $0.layer.cornerRadius = 10 }
    }
    
    // 맵 불러오기
    func loadMapView() {
        
        // 카메라 위치
        let camera = GMSCameraPosition(latitude: 36, longitude: 127.5, zoom: 7)
        map = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), camera: camera)
        map.delegate = self
        
        view.addSubview(map)
        
        view.bringSubviewToFront(topStackView)
    }
    
    // 여행지 데이터 호출 및 지도에 마커 표시
    func requestPlaceData() {
        let user = UserDefaults.standard.getLoginUser()!
        
        // 여행지 데이터 호출
        PlaceNetManager.shared.read(uid: user.uid!, startDate: startDate, endDate: endDate) { places in
            
            if self.startDate == nil {
                self.minimumDate = places.first?.visitDate
                self.maximumDate = places.last?.visitDate
            } else {
                self.startDate = nil
                self.endDate = nil
            }
            
            DispatchQueue.main.async {
                for place in places {
                    let position = CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!)
                    let marker = GMSMarker(position: position)
                    
                    //마커 로티
                    let animationView = LottieAnimationView(name: "mapmaker")
                    animationView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
                    animationView.contentMode = .scaleAspectFit
                    animationView.loopMode = .loop
                    animationView.animationSpeed = 1.8
                    
                    marker.iconView = animationView
                    
                   
                    animationView.play()
                    
                    marker.userData = place
                    marker.map = self.map
                }
            }
        }
    }
    
    // 기간 설정 버튼 클릭
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        print(#function)
    
        dateRangePickerVC.delegate = self
    
        dateRangePickerVC.minimumDate = CustomDateFormatter.format.date(from: minimumDate!)
        dateRangePickerVC.maximumDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())
        
        print(dateRangePickerVC.minimumDate)
        
        dateRangePickerVC.selectedStartDate = nil
        dateRangePickerVC.selectedEndDate = nil
        dateRangePickerVC.selectedColor = .systemBlue
        
        let navigationController = UINavigationController(rootViewController: dateRangePickerVC)
        
        present(navigationController, animated: true)
        
    }
    
    @IBAction func dateResetButtonTapped(_ sender: UIButton) {
        topViewLabel.text = "전체 기간"
        requestPlaceData()
    }
    

}

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WritingPageViewController") as! WritingPageViewController
        
       
    
        let place = marker.userData as! Place
        vc.place = place
        vc.navigationItem.title = place.name
        
        SpendingNetManager.shared.read(pid: place.pid!) { spendings in
            
            vc.spendings = spendings
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
              
            }
        }
        
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {

        let infoWindow = Bundle.main.loadNibNamed("MarkerInfoWindowView", owner: self, options: nil)![0] as! MarkerInfoWindowView
        
        // 라벨의 너비 자동 조정
        infoWindow.name.sizeToFit()

        // 최소 너비를 160으로 유지하고 너비 조정
        let infowindowWidth = max(160, infoWindow.name.frame.width + 30) // name 레이블에 맞게 설정
        let infowindowSize = CGSize(width: infowindowWidth, height: 120) // name 레이블에 맞게 설정
        infoWindow.frame = CGRect(origin: infoWindow.frame.origin, size: infowindowSize)


        infoWindow.infoView.layer.cornerRadius = 15
        infoWindow.infoView.layer.borderColor = CGColor(red: 0.23, green: 0.5, blue: 0.8, alpha: 0.8)
        infoWindow.infoView.layer.borderWidth = 3
        infoWindow.infoView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        let place = marker.userData as! Place
        
        infoWindow.name.text = place.name
        infoWindow.date.text = place.visitDate
        infoWindow.spending.text = "\(numberFormatter(number:place.totalSpending!)) 원"
        
        
        
        return infoWindow
    }
    // MARK: - 금액 3자리수 마다 , 붙이기
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

// MARK: - CalendarDateRangePickerVCDelegate
extension MapViewController: CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        dismiss(animated: true)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.startDate = CustomDateFormatter.format.string(from: startDate)
        self.endDate = CustomDateFormatter.format.string(from: endDate)
        
        topViewLabel.text = "\(self.startDate!) ~ \(self.endDate!)"
        
        dismiss(animated: true) {
            self.map.clear()
            self.requestPlaceData()
        }
    }
    
    func didSelectStartDate(startDate: Date!) { }
    func didSelectEndDate(endDate: Date!) { }
    
}
