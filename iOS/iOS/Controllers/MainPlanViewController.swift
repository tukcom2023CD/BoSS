//
//  MainPlanViewController.swift
//  iOS
//
//  Created by 박다미 on 2023/01/29.
//

// 앞에서 지역명 날짜 가져와야함

import UIKit
// index순서 MainPlanDetailTableViewCell에 넘길 프로토콜.
protocol sendIndexRow: AnyObject {
    func pass(text: Int)
}

class Section {
    let title: String
    let options: [String]
    var isOpend: Bool = false
    
    init(title: String,
         options: [String],
         isOpend: Bool = false){
        
        self.title = title
        self.options = options
        self.isOpend = isOpend
    }
}



class MainPlanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    weak var delegate: sendIndexRow?
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTitleMode()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.register(UINib(nibName:"MainPlanTableViewCell", bundle: nil), forCellReuseIdentifier:"MainPlanTableViewCell")
        
        tableView.register(UINib(nibName:"MainPlanDetailTableViewCell", bundle: nil), forCellReuseIdentifier:"MainPlanDetailTableViewCell")
        sections = [
            Section(title: "Day 1", options: [1,2,3].compactMap({ return "Cell \($0)" })), //$0으로 일일이 0 1 2 3 안씀
            Section(title: "Day 2", options: [1,2].compactMap({ return "Cell \($0)" })),
            Section(title: "Day 3", options: [1,2].compactMap({ return "Cell \($0)" })),
            Section(title: "Day 4", options: [1,2,3].compactMap({ return "Cell \($0)" }))
        ]
        
        tableView.reloadData()
        
       
    }
    // 화면에 다시 진입할때마다 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
 //타이틀 변환주기
    
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
   

}
extension MainPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpend {
            return section.options.count + 1
        } else {
            return 1
        }
    }
    //눌리는 행이 0 그외는 모두 눌려서 생긴 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainPlanTableViewCell", for: indexPath) as? MainPlanTableViewCell
            cell?.titleLabel.text = sections[indexPath.section].title
            
            return cell!
        } else {
            let cellDetail = tableView.dequeueReusableCell(withIdentifier: "MainPlanDetailTableViewCell", for: indexPath) as? MainPlanDetailTableViewCell
            cellDetail?.numberLabelText = indexPath.row
            
            
            //마지막 row라면 버튼이 보인다.
            
            cellDetail?.addPlaceButton.isHidden = false
            cellDetail?.plusButtonPressed = { [weak self] (senderCell) in
                // 뷰컨트롤러에 있는 세그웨이의 실행
                self?.performSegue(withIdentifier: "ToSeePlace", sender: indexPath)
            }
         //   print("\(cellDetail!.numberLabelText ?? 0)")
           //       print("\(indexPath.row)")
            
            //delegate?.pass(text: indexPath.row)
//            cellDetail?.tableView .titleLabel.text = sections[indexPath.section].options[indexPath.row - 1]
            cellDetail?.selectionStyle = .none
            return cellDetail!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let interval:CGFloat = 3
        let width: CGFloat = ( UIScreen.main.bounds.width - interval * 3 ) / 2
        switch indexPath.row {
        case 0:
            return 30
        default:
            return 100
        }
    
}
    
    //셀 클릭시 디테일 셀들이 나온다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
        sections[indexPath.section].isOpend = !sections[indexPath.section].isOpend
        tableView.reloadSections([indexPath.section], with: .none)
        } else {
            //세부셀 온터치
            performSegue(withIdentifier: "toDetailPage", sender: indexPath)
        }
    }
}
