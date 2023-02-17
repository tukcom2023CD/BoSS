//
//  ReceiptViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/17.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textInput1: UITextField!
    @IBOutlet weak var textInput2: UITextField!
    @IBOutlet weak var textInput3: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    var stackLabel : String!
    var stringArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addButton.layer.cornerRadius = 5
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let txt1 = textInput1.text , let txt2 = textInput2.text , let txt3 = textInput3.text{
            if textInput1.text != "" && textInput2.text != "" && textInput3.text != ""{
                let txtString : String = "\(txt1)       |        \(txt2)    |   \(txt3) "
                self.stringArr.insert(txtString, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                textInput1.text = nil
                textInput2.text = nil
                textInput3.text = nil
                tableView.endUpdates()
            }
        }
//        if let txt = textInput2.text{
//            if textInput2.text != ""{
//                self.stringArr.insert(txt, at: 0)
//                tableView.beginUpdates()
//                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
//                textInput2.text = nil
//                tableView.endUpdates()
//            }
//        }
//        if let txt = textInput3.text{
//            if textInput3.text != ""{
//                self.stringArr.insert(txt, at: 0)
//                tableView.beginUpdates()
//                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
//                textInput3.text = nil
//                tableView.endUpdates()
//            }
//        }
//
        
        
    }
    

    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        stringArr.remove(at: indexpath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        tableView.endUpdates()
    }
    
}
    
extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stringArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewCell", for: indexPath) as? EditTableViewCell else {return UITableViewCell()}
        cell.inputLabel.text = stringArr[indexPath.row]
//        cell.inputLabel2.text = stringArr[indexPath.row]
//        cell.inputLabel3.text = stringArr[indexPath.row]
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
