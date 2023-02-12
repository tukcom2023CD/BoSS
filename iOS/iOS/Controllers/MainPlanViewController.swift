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
        setupTableView()
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
    
    func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MainPlanHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MainPlanHeaderView")
        tableView.register(UINib(nibName: "MainPlanTableViewCell", bundle: nil), forCellReuseIdentifier: "MainPlanTableViewCell")
        tableView.register(UINib(nibName: "MainPlanFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "MainPlanFooterView")
        
        
    }
}

extension MainPlanViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // 섹션 내 행 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainPlanTableViewCell", for: indexPath) as! MainPlanTableViewCell
        
        return cell
    }
    
    // 섹션 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainPlanHeaderView") as! MainPlanHeaderView
        
        view.day.text = "\(section)"
        
        return view
    }
    
    // 섹션 푸터
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainPlanFooterView") as! MainPlanFooterView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
