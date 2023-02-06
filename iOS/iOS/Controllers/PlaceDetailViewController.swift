//
//  PlaceDetailViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/06.
//

import UIKit
import GooglePlaces

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var place: GMSPlace!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonTapped))
    
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName:"PlaceInfoTableViewCell", bundle: nil), forCellReuseIdentifier:"PlaceInfoTableViewCell")
        tableView.register(UINib(nibName:"PlaceLocationMapTableViewCell", bundle: nil), forCellReuseIdentifier:"PlaceLocationMapTableViewCell")
        tableView.register(UINib(nibName:"PlacePhotosTableViewCell", bundle: nil), forCellReuseIdentifier:"PlacePhotosTableViewCell")
    }
    
    @objc func barButtonTapped() {
        
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
            return 100
        case 1:
            return 300
        case 2:
            return 300
        default:
            return 0
        }
    }


}
