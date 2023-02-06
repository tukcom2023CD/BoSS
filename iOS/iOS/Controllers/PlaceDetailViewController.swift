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
        case 1:
            return UITableViewCell()
        case 2:
            return UITableViewCell()
        case 3:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }


}
