//
//  WithDrawMembershipViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/07.
//

import UIKit

class WithDrawMembershipViewController : UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var withDrawButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func withDrawButtonTapped(_ sender: UIButton) {
        // 현재 화면 닫기
        dismiss(animated: true, completion: nil)
    }
}
