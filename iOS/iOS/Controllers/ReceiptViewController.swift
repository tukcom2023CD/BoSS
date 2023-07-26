//
//  ReceiptViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/17.
//

import UIKit

protocol SendProtocol: AnyObject {
    func sendData(receiptData: [Spending])
}

class ReceiptViewController: UIViewController {
    
    //MARK: - Properties
    var delegate: SendProtocol?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textInput1: UITextField!
    @IBOutlet weak var textInput2: UITextField!
    @IBOutlet weak var textInput3: UITextField!
    @IBOutlet weak var totalPriceLabel: UILabel!
    var totalPrice : Int! = 0
    var newTotalPrice : Int! = 0
    @IBOutlet weak var tableView: UITableView!
    
    var subPriceData: [Int] = [] //삭제시 사용할 그 행의 총 가격
    var spendings: [Spending]=[]
    var place: Place!
    
    override func viewWillAppear(_ animated: Bool) {
        totalPrice = 0
        subPriceData = []
        
        if (spendings.count != 0){
            for i in 0...spendings.count-1{
                totalPrice += (spendings[i].quantity ?? 1) * (spendings[i].price ?? 0)
                subPriceData.insert((spendings[i].quantity ?? 1) * (spendings[i].price ?? 0), at: 0)
            }
            subPriceData.reverse()
            totalPriceLabel.text = String(totalPrice)
            
        }
    }
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addButton.layer.cornerRadius = 5
        
        textInput2.delegate = self
        textInput3.delegate = self
        
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK: - viewWillDisappear   화면 사라질때 데이터 넘기기
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.sendData(receiptData: spendings)
    }
    
    
    //MARK: - addButtonTapped
    @IBAction func addButtonTapped(_ sender: Any) {
        if let txt1 = textInput1.text , let txt2 = textInput2.text , let txt3 = textInput3.text{
            if textInput1.text != "" && textInput3.text != ""{
                
                let txtString = Spending(name: txt1, quantity: Int(txt2), price: Int(txt3),pid: self.place.pid!)
  
                //새로 생긴 행의 새 수량*가격
                newTotalPrice = (txtString.quantity ?? 1) * txtString.price!
                totalPrice += newTotalPrice
                totalPriceLabel.text = NumberFormatter.numberFormatter(number: totalPrice)//"\(totalPrice!)"
                
                
                self.spendings.insert(txtString, at: 0)
                self.subPriceData.insert(newTotalPrice, at: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)

                
                textInput1.text = nil
                textInput2.text = nil
                textInput3.text = nil
                tableView.endUpdates()
            
            }
        }
    }
    
    //MARK: - deleteButtonTapped
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        print("delete")
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        
        totalPrice -= subPriceData[indexpath.row]
        
        spendings.remove(at: indexpath.row)
        subPriceData.remove(at: indexpath.row)
        totalPriceLabel.text = NumberFormatter.numberFormatter(number:totalPrice)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
        tableView.endUpdates()
        
        
    }
    
}
//MARK: - extension ReceiptViewController
extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditTableViewCell", for: indexPath) as? EditTableViewCell else {return UITableViewCell()}
        cell.itemLabel.text = spendings[indexPath.row].name!//stringArr[indexPath.row].itemData
        
        cell.amountLabel.text = "\(spendings[indexPath.row].quantity ?? 1)"
        cell.priceLabel.text = NumberFormatter.numberFormatter(number:spendings[indexPath.row].price ?? 0)//"\(String(describing: spendings[indexPath.row].price!))"
        return cell
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
