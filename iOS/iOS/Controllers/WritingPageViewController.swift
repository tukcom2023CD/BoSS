//
//  WritingPageViewController.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/01.
//

import UIKit



class WritingPageViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var placeData: [Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName:"ImageTableViewCell", bundle: nil), forCellReuseIdentifier:"ImageTableViewCell")
        tableview.register(UINib(nibName:"ExplainTableViewCell", bundle: nil), forCellReuseIdentifier:"ExplainTableViewCell")
        tableview.register(UINib(nibName:"CostTableViewCell", bundle: nil), forCellReuseIdentifier:"CostTableViewCell")
       
        tableview.rowHeight = UITableView.automaticDimension
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
            
            return cell
            
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: "ExplainTableViewCell", for: indexPath) as! ExplainTableViewCell
            cell.selectionStyle = .none
            return cell
            
        case 2:
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
