//
//  WritingPageViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit

class WritingPageViewController: UIViewController


{
    @IBOutlet weak var scrollView: UIScrollView!
   // @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    
    @IBOutlet weak var contents: UILabel!
    
    @IBOutlet weak var costButton: UIButton!
    
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var detailCost: UIView!
    
//    var diary: Diary? {
//        didSet {
//            guard let diary = diary else { return }
//            imageCard.image = diary.imageCard
//            contents.text = diary.contents
//
//        }
//
//
//    }
    var imageCardData = UIImage(named: "여행사진 1")
    var contentsData: String?
    
//    var topItems = [String]()
//    var subItems = [String]()
    
    
    var onTapped :Bool = true
    var selectedIndexPathSection:Int = -1
  
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTitleMode()
        imageCardSetting()
        
        uiViewSetting()
        costButtonSetting()
        detailCostSetting()
        // 전화면에서 전달받은 데이터들을 통해 셋팅
        imageCard.image = imageCardData
        contents.text = contentsData
    
 
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // tableview.reloadData()
    }
    
    
    @IBAction func costButtonTapped(_ sender: UIButton) {
        onTapped = !onTapped
        if onTapped == true{
            detailCost.isHidden = true
        }
        else {
            detailCost.isHidden = false
        }
       
    }
    func uiViewSetting(){
        uiView.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
       
       self.uiView.layer.borderWidth = 0.3
       self.uiView.layer.borderColor = UIColor.lightGray.cgColor
       self.uiView.layer.cornerRadius = 10
    }
    func imageCardSetting(){
        self.imageCard.layer.borderWidth = 0.3
        self.imageCard.layer.borderColor = UIColor.lightGray.cgColor
        self.imageCard.layer.cornerRadius = 10
     
    }
    func costButtonSetting(){
        costButton.layer.cornerRadius = 10
        costButton.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
    }
    
    func detailCostSetting(){
        costButton.layer.cornerRadius = 6
        detailCost.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
    }
    //스무스한 타이틀 변경
    func changeTitleMode(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        print(self.scrollView.contentOffset.y)
        if self.scrollView.contentOffset.y > 0
        {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    
    
        @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
      
    }
    
    //수정 페이지로 이동
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WritingEditPageViewController") as? WritingEditPageViewController else { return }
    
       // guard diary != nil else { return }
       
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
        
    }
    

}
//extension WritingPageViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let section = sections[section]
//        
//        if section.isOpend {
//            return section.options.count + 1
//        } else {
//            return 1
//        }
//    }
//    
//    //눌리는 행이 0 그외는 모두 눌려서 생긴 셀
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//   
//   
//    }
//        
//        
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//            return 50
//    
//        }
//    
