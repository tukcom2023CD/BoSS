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
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableLabel: UIStackView!
    
    @IBOutlet weak var labelView: UIView!
    
    
    //이미지 터치기능을 위한 didset
    @IBOutlet var imageView: UIImageView!{
        didSet {
            imageView.isUserInteractionEnabled = true
            imageView.image = UIImage(systemName: "chevron.down")
        }
    }
    var imageCardData = UIImage(named: "여행사진 1")
    var contentsData: String?
    var onTapped :Bool = true
    var selectedIndexPathSection:Int = -1
    var getPrice : [AllData] = [AllData(itemData: "", amountData: "", priceData: "")]
    var totalPrice : String = "0 원"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTitleMode()
        imageCardSetting()
        uiViewSetting()
        costViewSetting()
        tableView.isHidden = true
        tableLabel.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageButtonTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc private func imageButtonTapped(_ sender: UITapGestureRecognizer) {
        onTapped = !onTapped
        if onTapped == true{
            tableView.isHidden = true
            tableLabel.isHidden = true
            imageView.image = UIImage(systemName: "chevron.down")
        }
        else {
            tableView.isHidden = false
            tableLabel.isHidden = false
            imageView.image = UIImage(systemName: "chevron.up")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 전화면에서 전달받은 데이터들을 통해 셋팅
        imageCard.image = imageCardData
        contents.text = contentsData
        contents.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        costLabel.text = totalPrice
        labelViewSetting()
        
    }
    
    
    
    
    func labelViewSetting(){
        labelView.layer.cornerRadius = 10
        labelView.layer.borderWidth = 3
        labelView.layer.borderColor = UIColor.systemGray6.cgColor
        
        
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
    func costViewSetting(){
        costView.layer.cornerRadius = 10
        
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
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
}
extension WritingPageViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getPrice.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GetpriceTableViewCell", for: indexPath) as? GetpriceTableViewCell else {return UITableViewCell()}
        cell.itemLabel.text = getPrice[indexPath.row].itemData
        cell.amountLabel.text = getPrice[indexPath.row].amountData
        cell.priceLabel.text = getPrice[indexPath.row].priceData
        
        return cell
    }
}
