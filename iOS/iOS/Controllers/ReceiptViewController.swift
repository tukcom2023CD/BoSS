//
//  ReceiptViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/17.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var stringArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addButton.layer.cornerRadius = 5
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let txt = textInput.text{
            if textInput.text != ""{
                self.stringArr.insert(txt, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                textInput.text = nil
                tableView.endUpdates()
            }
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
