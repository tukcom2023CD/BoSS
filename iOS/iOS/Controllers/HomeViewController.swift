//
//  HomeViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/01/17.
//

import UIKit
import CalendarDateRangePicker


class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var schedules: [Schedule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Travelog"
        navigationController?.navigationBar.prefersLargeTitles = true
        //register TableViewCell
        tableView.register(UINib(nibName:"FirstTableViewCell", bundle: nil), forCellReuseIdentifier:"FirstTableViewCell")
        tableView.register(UINib(nibName:"CalendarTableViewCell", bundle: nil), forCellReuseIdentifier:"CalendarTableViewCell")
        
        tableView.register(UINib(nibName:"SecondTableViewCell", bundle: nil), forCellReuseIdentifier:"SecondTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func createScheduleBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let planningVC = storyboard?.instantiateViewController(withIdentifier: "PlanningVC") as! PlanningViewController
        
        navigationController?.pushViewController(planningVC, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as! FirstTableViewCell
            cell.configure()
            cell.selectionStyle = .none
            cell.schedules = self.schedules
            
            // 여행일정 셀 클릭 시 동작할 기능 정의
            cell.didSelectItem = { schedule in
                let mainPlanVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPlanViewController") as! MainPlanViewController
                self.navigationController?.pushViewController(mainPlanVC, animated: true)
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell", for: indexPath) as! SecondTableViewCell
            cell.selectionStyle = .none
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let interval:CGFloat = 3
        let width: CGFloat = ( UIScreen.main.bounds.width - interval * 3 ) / 2
        
        switch indexPath.row {
        case 0:
            return 130
        case 1:
            return 400
        case 2:
            return 300
            
            //            return (width + 40 + 3) * 5 + 40
        default:
            return 0
        }
        
    }
}
