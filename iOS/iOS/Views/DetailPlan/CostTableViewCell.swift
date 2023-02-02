//
//  CostTableViewCell.swift
//  iOS
//
//  Created by SeungHyun Lee on 2023/02/02.
//

import UIKit

class costData {
    let costName: String
    let costEach: Int
    let costPrice: Int
    
    
    init(costName: String,
         costEach: Int,
         costPrice: Int){
        
        self.costName = costName
        self.costEach = costEach
        self.costPrice = costPrice
    }
}

class CostTableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var costTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        costTableView.delegate = self
        costTableView.dataSource = self
        costTableView.register(UINib(nibName:"CostCell", bundle: nil), forCellReuseIdentifier:"CostCell")
    }

    @IBAction func addBtn(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension CostTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        
    }
    //눌리는 행이 0 그외는 모두 눌려서 생긴 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CostCell", for: indexPath) as? CostCell
     
            
            return cell!
        
    }
    
   
}
