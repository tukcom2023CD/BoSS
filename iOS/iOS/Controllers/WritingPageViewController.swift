//
//  WritingPageViewController.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/01.
//

import UIKit

class DetailSection {
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

class WritingPageViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    private var sections = [DetailSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.backgroundColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName:"TitleTableViewCell", bundle: nil), forCellReuseIdentifier:"TitleTableViewCell")
        tableview.register(UINib(nibName:"ImageTableViewCell", bundle: nil), forCellReuseIdentifier:"ImageTableViewCell")
        tableview.register(UINib(nibName:"ExplainTableViewCell", bundle: nil), forCellReuseIdentifier:"ExplainTableViewCell")
        tableview.register(UINib(nibName:"ExpainDetailCell", bundle: nil), forCellReuseIdentifier:"ExpainDetailCell")
        tableview.register(UINib(nibName:"CostTableViewCell", bundle: nil), forCellReuseIdentifier:"CostTableViewCell")
        tableview.register(UINib(nibName:"CostDetailViewCell", bundle: nil), forCellReuseIdentifier:"CostDetailViewCell")
        sections = [
            DetailSection(title: "", options: [].compactMap({ return "Cell \($0)" })), //$0으로 일일이 0 1 2 3 안씀
            DetailSection(title: "Day 2", options: [].compactMap({ return "Cell \($0)" })),
            DetailSection(title: "내용", options: [1].compactMap({ return "Cell \($0)" })),
            DetailSection(title: "비용", options: [1].compactMap({ return "Cell \($0)" }))
        ]
        
        tableview.reloadData()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
}

extension WritingPageViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            cell.selectionStyle = .none
           
            
            return cell
            
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.selectionStyle = .none
            return cell
            
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExplainTableViewCell", for: indexPath) as? ExplainTableViewCell
                cell?.titleLabel?.text = sections[indexPath.section].title
                
                return cell!
            } else {
                let cellDetail = tableView.dequeueReusableCell(withIdentifier: "ExpainDetailCell", for: indexPath) as? ExpainDetailCell
                
                return cellDetail!
            }
            
            
           
            
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CostTableViewCell", for: indexPath) as? CostTableViewCell
                cell?.titleLabel?.text = sections[indexPath.section].title
                
                return cell!
            } else {
                let cellDetail = tableView.dequeueReusableCell(withIdentifier: "CostDetailViewCell", for: indexPath) as? CostDetailViewCell
                
                return cellDetail!
            }
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sections[indexPath.section].isOpend = !sections[indexPath.section].isOpend
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            //세부셀 온터치
            //            performSegue(withIdentifier: "toDetailPage", sender: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let interval:CGFloat = 3
        let width: CGFloat = ( UIScreen.main.bounds.width - interval * 3 ) / 2

        switch indexPath.section {
        case 0:
            return 75
        case 1:
            return 250
        case 2:
            return 50
        case 3:
            return 50
        default:
            return 0
        }
    }
}
