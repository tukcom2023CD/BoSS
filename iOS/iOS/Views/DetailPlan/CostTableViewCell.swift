//
//  CostTableViewCell.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/02.
//

import UIKit



class CostTableViewCell: UITableViewCell {
    var data = [(name: String, quantity: Int, price: Int)]()
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var costTableView: UITableView!
    @IBOutlet weak var viewStateImage: UIImageView!
    @IBOutlet weak var bottomView: UIStackView!
    var isExpanded = false
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topViewTapped))
        topView.addGestureRecognizer(tapGestureRecognizer)
        bottomView.isHidden = true
        
        costTableView.delegate = self
        costTableView.dataSource = self
        costTableView.register(UINib(nibName:"CostCell", bundle: nil), forCellReuseIdentifier:"CostCell")
    }

    @IBAction func addBtn(_ sender: Any) {
        data.append((name:"품명", quantity: 1, price: 0))
        let indexPath = IndexPath(row: data.count - 1, section: 0)
        costTableView.beginUpdates()
        costTableView.insertRows(at: [indexPath], with: .automatic)
        costTableView.endUpdates()
        
    }
    
    @objc func topViewTapped() {
        isExpanded = !isExpanded
        bottomView.isHidden = !isExpanded
        bottomViewHeightConstraint?.constant = isExpanded ? 400 : 100
        UIView.animate(withDuration: 0.3){
            self.layoutIfNeeded()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension CostTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        costTableView.register(CostCell.self, forCellReuseIdentifier: "CostCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostCell", for: indexPath) as? CostCell
        let item = data[indexPath.row]
        cell?.nameLabel?.text = item.name
        cell?.textLabel?.text = "\(item.quantity)"
        cell?.textLabel?.text = "\(item.price) ￦"

        return cell!
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Show an alert to allow editing of the selected item
//        let item = data[indexPath.row]
//        let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
//        alert.addTextField { textField in
//            textField.placeholder = "Name"
//            textField.text = item.name
//        }
//        alert.addTextField { textField in
//            textField.placeholder = "Quantity"
//            textField.text = "\(item.quantity)"
//            textField.keyboardType = .numberPad
//        }
//        alert.addTextField { textField in
//            textField.placeholder = "Price"
//            textField.text = "\(item.price)"
//            textField.keyboardType = .decimalPad
//        }
//        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
//            guard let name = alert.textFields?[0].text, !name.isEmpty,
//                  let quantityText = alert.textFields?[1].text, let quantity = Int(quantityText),
//                  let priceText = alert.textFields?[2].text, let price = Int(priceText) else {
//                return
//            }
//            self.data[indexPath.row] = (name: name, quantity: quantity, price: price)
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alert.addAction(saveAction)
//    }
//
    
    
    
    
    
    
    
    //눌리는 행이 0 그외는 모두 눌려서 생긴 셀
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CostCell", for: indexPath) as? CostCell
//
//
//            return cell!
//
//    }
    
   
}
