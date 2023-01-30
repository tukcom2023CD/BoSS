//
//  MainPlanViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/01/29.
//

// 앞에서 지역명 날짜 가져와야함

import UIKit

class Section {
    let title: String
    let options: [String]
    var isOpend: Bool = false
    
    init(title: String,
         options: [String],
         isOpend: Bool = false){
        
        self.title = title
        self.options = options
        self.isOpend = isOpend
    }
}

class MainPlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UINib(nibName:"MainPlanTableViewCell", bundle: nil), forCellReuseIdentifier:"MainPlanTableViewCell")
        
        tableView.register(UINib(nibName:"MainPlanDetailTableViewCell", bundle: nil), forCellReuseIdentifier:"MainPlanDetailTableViewCell")
        sections = [
            Section(title: "Day 1", options: [1, 2, 3].compactMap({ return "Cell \($0)" })), //$0으로 일일이 0 1 2 3 안씀
            Section(title: "Day 2", options: [1, 2, 3].compactMap({ return "Cell \($0)" })),
            Section(title: "Day 3", options: [1, 2, 3].compactMap({ return "Cell \($0)" })),
            Section(title: "Day 4", options: [1, 2, 3].compactMap({ return "Cell \($0)" })),
        ]
        
       
    }
    

   

}
extension MainPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpend {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    //눌리는 행이 0 그외는 모두 눌려서 생긴 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainPlanTableViewCell", for: indexPath) as? MainPlanTableViewCell
            cell?.titleLabel.text = sections[indexPath.section].title
            
            return cell!
        } else {
            let cellDetail = tableView.dequeueReusableCell(withIdentifier: "MainPlanDetailTableViewCell", for: indexPath) as? MainPlanDetailTableViewCell
            cellDetail?.titleLabel.text = sections[indexPath.section].options[indexPath.row - 1]
            return cellDetail!
        }
    }
    
    //셀 클릭시 디테일 셀들이 나온다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
        sections[indexPath.section].isOpend = !sections[indexPath.section].isOpend
        tableView.reloadSections([indexPath.section], with: .none)
        } else {
            //세부셀 온터치
        }
    }
    
}
