//
//  PlaceDetailViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/06.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceLocationMapTableViewCell", for: indexPath) as! PlaceLocationMapTableViewCell
            return cell
        case 2:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150
        case 1:
            return 300
        case 2:
            return 300
        default:
            return 0
        }
    }


}
