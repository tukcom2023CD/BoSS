//
//  MyPageSpendingViewController.swift
//  iOS
//
//  Created by JunHee on 2023/02/09.
//

import UIKit


class MyPageSpendingViewController: UIViewController {

    @IBOutlet weak var horizontal_bar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        horizontal_bar.clipsToBounds = true
        horizontal_bar.layer.cornerRadius = 5
    }
}







