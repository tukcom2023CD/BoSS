//
//  WritingPageViewController.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/01.
//

import UIKit



class WritingPageViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    private var isExpanded = false
    
    var placeData: [Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName:"TitleTableViewCell", bundle: nil), forCellReuseIdentifier:"TitleTableViewCell")
        tableview.register(UINib(nibName:"ImageTableViewCell", bundle: nil), forCellReuseIdentifier:"ImageTableViewCell")
        tableview.register(UINib(nibName:"ExplainTableViewCell", bundle: nil), forCellReuseIdentifier:"ExplainTableViewCell")
        tableview.register(UINib(nibName:"CostTableViewCell", bundle: nil), forCellReuseIdentifier:"CostTableViewCell")
       
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = UITableView.automaticDimension
      
        // Do any additional setup after loading the view.
    }
    func toggleView(cell: ExplainTableViewCell) {
        isExpanded = !isExpanded
        cell.bottomView.isHidden = !cell.bottomView.isHidden
        tableview.beginUpdates()
        tableview.endUpdates()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension WritingPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            cell.selectionStyle = .none
           
            
            return cell
            
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableview.dequeueReusableCell(withIdentifier: "ExplainTableViewCell", for: indexPath) as! ExplainTableViewCell
            cell.selectionStyle = .none
            
            
            return cell
            
        case 3:
            let cell = tableview.dequeueReusableCell(withIdentifier: "CostTableViewCell", for: indexPath) as! CostTableViewCell
            cell.selectionStyle = .none
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 1 {
//            if isExpanded{
//                return UITableView.automaticDimension
//            } else if indexPath.row == 2 {
//                return UITableView.automaticDimension
//            }
//            else {
//                return 0
//            }
//        }
//        return UITableView.automaticDimension
        let interval:CGFloat = 3
        let width: CGFloat = ( UIScreen.main.bounds.width - interval * 3 ) / 2

        switch indexPath.row {
        case 0:
            return 75
        case 1:
            return 300
        case 2:
            return 300
        case 3:
            return 400

            //            return (width + 40 + 3) * 5 + 40
        default:
            return 0
        }
    }
}
