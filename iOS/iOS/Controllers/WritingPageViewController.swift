//
//  WritingPageViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit
// MARK: WritingEditPageViewController : 영수증정보( 1총합, 2품명, 3수량, 4가격)  5contents 정보 받음 => 1-5 정보다시 EditPageviewController로 넘김
//물어볼꺼1 viewController에서 Model 이렇게 접근해도 괜찮은지? 나중에 데이터 저장하는거 만들면 이거 없애는건지?


class WritingPageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableLabel: UIStackView!
    @IBOutlet weak var labelView: UIView!
    
    
    // MARK: 이미지 터치기능을 위한 didset
    @IBOutlet var imageView: UIImageView!{
        didSet {
            imageView.isUserInteractionEnabled = true
            imageView.image = UIImage(systemName: "chevron.down")
        }
    }
    var imageCardData : UIImage! = UIImage(named: "여행사진 1")
    var contentsData: String?
    var onTapped :Bool = true
    var selectedIndexPathSection:Int = -1
    var getPrice : [AllData] = [AllData(itemData: "", amountData: "", priceData: "")]
    var totalPrice : String = "0"
    var subTotalData: [Int]?
    
    var place: Place! // MainPlan에서 넘어온 Place 데이터 (diary, total_spending)
    var spendings: [Spending] = [] // 상세 지출내역 리스트
    
    // MARK: - viewDidLoad
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
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 전화면에서 전달받은 데이터들을 통해 셋팅
//        imageCard.image = imageCardData
        uploadImageCard()
        
        //contents.text = contentsData
        //costLabel.text = totalPrice
        contents.text = place.diary
        costLabel.text = "\(place.totalSpending!)"
        
        
        contents.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        labelViewSetting()
    }
    
    // MARK: - uploadImageCard
    // 여행지 사진 네트워킹
    func uploadImageCard() {
        PhotoNetManager.shared.read(uid: place.uid!, pid: place.pid!) { photos in
            
            // 여행지에 추가한 여러 사진들을 적용
            for photo in photos {
                guard let url = URL(string: photo.imageUrl) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                
                DispatchQueue.main.async {
                    self.imageCard.image = UIImage(data: data)
                }
                
            }
            
        }
    }
    
    
    // MARK: - labelViewSetting() :UI세팅
    func labelViewSetting(){
        labelView.layer.cornerRadius = 10
        labelView.layer.borderWidth = 3
        labelView.layer.borderColor = UIColor.systemGray6.cgColor
        
        
    }
    // MARK: - uiViewSetting() :UI세팅
    func uiViewSetting(){
        uiView.dropShadow(color: UIColor.lightGray, offSet:CGSize(width: 0, height: 6), opacity: 0.5, radius:5)
        self.uiView.layer.borderWidth = 0.3
        self.uiView.layer.borderColor = UIColor.lightGray.cgColor
        self.uiView.layer.cornerRadius = 10
    }
    
    // MARK: -imageCardSetting() :UI세팅
    func imageCardSetting(){
        self.imageCard.layer.borderWidth = 0.3
        self.imageCard.layer.borderColor = UIColor.lightGray.cgColor
        self.imageCard.layer.cornerRadius = 10
        
    }
    // MARK: -costViewSetting() :UI세팅
    func costViewSetting(){
        costView.layer.cornerRadius = 10
    }
    
    
    
    // MARK: 스무스한 타이틀 변경
    func changeTitleMode() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        print(self.scrollView.contentOffset.y)
        if self.scrollView.contentOffset.y > 0 {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            navigationItem.largeTitleDisplayMode = .always
        }
    }
    
    
    // MARK: backButtonTapped
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: editButtonTapped(수정 페이지로 이동 + 데이터 전달
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: "WritingEditPageViewController") as? WritingEditPageViewController else { return }
        
        vc.getAllData = getPrice
        vc.getImageCard = imageCard.image
        vc.getContents = contents.text
        vc.getTotalData = totalPrice
        vc.getSubTotalData = subTotalData
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - WriringPageVieController
extension WritingPageViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //getPrice.count
        spendings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GetpriceTableViewCell", for: indexPath) as? GetpriceTableViewCell else { return UITableViewCell() }
        
//        cell.itemLabel.text = getPrice[indexPath.row].itemData
//        cell.amountLabel.text = getPrice[indexPath.row].amountData
//        cell.priceLabel.text = getPrice[indexPath.row].priceData
        
        let spending = spendings[indexPath.row]
        
        cell.itemLabel.text = spending.name
        cell.amountLabel.text = "\(spending.quantity ?? 1)"
        cell.priceLabel.text = "\(spending.price)"
        
        return cell
    }
}
