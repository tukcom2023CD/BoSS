//
//  mainPlanButtonTappedViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/02/07.
//

import UIKit

class mainPlanButtonTappedViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        print("저장완료")
        // 다시 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
