//
//  ReceiptViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/17.
//

import UIKit
protocol TotalProtocol: AnyObject {
    func sendData(totalPriceData: String, priceData: [String])
}

class ReceiptViewController: UIViewController {
    var delegate: TotalProtocol?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textInput1: UITextField!
    @IBOutlet weak var textInput2: UITextField!
    @IBOutlet weak var textInput3: UITextField!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    var totalPrice : Int! = 0
    var newTotalPrice : Int! = 0
    @IBOutlet weak var tableView: UITableView!
    var stackLabel : String!
    var stringArr = [String]()
    
    var stringArr1 = [Int]() //삭제시 사용할 그 행의 총 가격
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addButton.layer.cornerRadius = 5
        
        textInput2.delegate = self
        textInput3.delegate = self
        
        
    }
    //사라질때 넘기기
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.sendData(totalPriceData: "\(totalPrice ?? 0)", priceData: stringArr)
        
    }
    
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let txt1 = textInput1.text , let txt2 = textInput2.text , let txt3 = textInput3.text{
            if textInput1.text != "" && textInput2.text != "" && textInput3.text != ""{
                //column나눌까
                let txtString : String = "\(txt1)  |    \(txt2)  |   \(txt3) "
                
                
                let input1:Int! = Int(textInput2.text!)
                let input2:Int! = Int(textInput3.text!)
                newTotalPrice = input1 * input2
                totalPrice += newTotalPrice
                
                totalPriceLabel.text = String(totalPrice)
                
                self.stringArr.insert(txtString, at: 0)
                self.stringArr1.insert(newTotalPrice, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                textInput1.text = nil
                textInput2.text = nil
                textInput3.text = nil
                tableView.endUpdates()
            }
        }
    }
    
    
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        totalPrice -= stringArr1[indexpath.row]
        stringArr.remove(at: indexpath.row)
        stringArr1.remove(at: indexpath.row)
        totalPriceLabel.text = String(totalPrice)
        
        //cell.price
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


extension ReceiptViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        
        //숫자만
        if Int(string) != nil || string == "" {
            if Int(string) ?? 0 < 1000000{
                return true
            }
        }
        return false
    }
}
