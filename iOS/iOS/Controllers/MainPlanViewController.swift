//
//  MainPlanViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/01/29.
//

import UIKit

class MainPlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tripTitle: UILabel!
    
    @IBOutlet weak var period: UILabel!
    
    var schedule: Schedule!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        
        period.text = "\(schedule.start!) ~ \(schedule.stop!)"
        
        tripTitle.attributedText = NSAttributedString(
            string: schedule.title!,
            attributes: [
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -3.0
            ]
        )
    }
    

}
