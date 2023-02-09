//
//  MainPlanDetailTableViewCell.swift
//  iOS
//
//  Created by 박다미 on 2023/01/30.
//

import UIKit


class MainPlanDetailTableViewCell: UITableViewCell,sendIndexRow {
 
    
   // @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberCheckView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addPlaceButton: UIButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var numberLabelText : Int!
    var numberLabelTextString : String! = ""
    
    //인덱스 번호 받기
    func pass(text: Int) {
        self.numberLabelText = text
        print("답:\(text )")
      // print("\(numberLabelText ?? 1000)")
    }
    
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀 자신 전달)
    var plusButtonPressed: (MainPlanDetailTableViewCell) -> Void = { (sender) in }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        numberCheckView .layer.cornerRadius =  numberCheckView.frame.height / 2
        numberCheckView.clipsToBounds = true
        //numberLabelTextString = "\(numberLabelText)"
        print("\(numberLabelText ?? 1000)")
        
        
        numberLabel.text = "\(numberLabelText ?? 0)"
        
        // print("\(numberLabelText ?? 3)")
        //numberLabel.text = "2"
        //"\(numberLabelText ?? 1)"
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
       
        plusButtonPressed(self)    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
