//
//  PlaceDetailViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/06.
//

import UIKit
import GooglePlaces
import SnapKit
class PlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var place: GMSPlace!
    var visitDate: String!
    var scheduleId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setNavi()
        
    }
    private func setNavi(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonTapped))
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName:"PlaceInfoTableViewCell", bundle: nil), forCellReuseIdentifier:"PlaceInfoTableViewCell")
        tableView.register(UINib(nibName:"PlaceLocationMapTableViewCell", bundle: nil), forCellReuseIdentifier:"PlaceLocationMapTableViewCell")
        tableView.register(UINib(nibName:"PlacePhotosTableViewCell", bundle: nil), forCellReuseIdentifier:"PlacePhotosTableViewCell")
    }
    
    @objc func barButtonTapped() {
        guard let user = UserDefaults.standard.getLoginUser() else {
            print(#function)
            return
        }
        
        let placeData = Place(name: place.name!, address: place.formattedAddress!, latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, visitDate: visitDate, sid: scheduleId, uid: user.uid!)
        
        PlaceNetManager.shared.create(place: placeData) {
            DispatchQueue.main.async {
                guard let vcStack =
                        self.navigationController?.viewControllers else { return }
                for vc in vcStack {
                    if let view = vc as? MainPlanViewController {
                        //view.requestPlaceData()
                        self.navigationController?.popToViewController(view, animated: true)
                    }
                }
            }
        }
    }
    
}

extension PlaceDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceInfoTableViewCell", for: indexPath) as! PlaceInfoTableViewCell
            
            cell.name.text = place.name
            cell.address.text = place.formattedAddress
            
            if let url = place.iconImageURL {
                cell.icon.load(url: url)
                cell.icon.backgroundColor = place.iconBackgroundColor
               
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceLocationMapTableViewCell", for: indexPath) as! PlaceLocationMapTableViewCell
            
            cell.coordinate = place.coordinate
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlacePhotosTableViewCell", for: indexPath) as! PlacePhotosTableViewCell
            
            cell.photoMetadata = place.photos
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return tableView.bounds.width * 0.25
        case 1:
            return tableView.bounds.width * 0.8
            
        case 2:
            return tableView.bounds.width * 0.8
        default:
            return 0
        }
    }
    
}
