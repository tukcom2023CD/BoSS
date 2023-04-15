//
//  WritingPageViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit

//받는 프ㄹ
class WritingPageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableLabel: UIStackView!
    @IBOutlet weak var labelView: UIView!
    var photoArray: [UIImage] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
   
    // MARK: 이미지 터치기능을 위한 didset
    @IBOutlet var imageView: UIImageView!{
        didSet {
            imageView.isUserInteractionEnabled = true
            imageView.image = UIImage(systemName: "chevron.down")
        }
    }
    var imageCardData : UIImage! = UIImage(named: "여행사진 1")
    var onTapped :Bool = true
    
    
    // 새로 추가한 변수
    var place: Place!
    var spendings: [Spending] = []
    var currentPage : Int = 0
    
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var totalPrice : Int = 0
        // 전화면에서 전달받은 데이터들을 통해 셋팅
        contents.text = place.diary
        
        if (spendings.count != 0){
            for i in 0...spendings.count-1{
                totalPrice += (spendings[i].quantity ?? 1) * (spendings[i].price ?? 0)
            }
            // costLabel.text = String(totalPrice)
            place.totalSpending! += totalPrice
            costLabel.text = "\(totalPrice)"
        }
        contents.translatesAutoresizingMaskIntoConstraints = false
        tableView.reloadData()
        collectionView.reloadData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        pageControl.currentPage = 0
        pageControl.numberOfPages = photoArray.count
        labelViewSetting()
    }
    
    
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
        uploadImageCard()
       
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
       
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
    

    // MARK: - uploadImageCard
    // 여행지 사진 네트워킹
    func uploadImageCard() {
        
        
        
//        PhotoNetManager.shared.read(uid: place.uid!, pid: place.pid!) { photos in
//
//            // 여행지에 추가한 여러 사진들을 적용
//            for photo in photos {
//                guard let url = URL(string: photo.imageUrl) else { return }
//                guard let data = try? Data(contentsOf: url) else { return }
//
//                DispatchQueue.main.async {
//                    // 이후에 이미지 슬라이드를 통해 여러 사진 적용할 수 있도록 수정
//                    self.imageCard.image = UIImage(data: data)
//                }
//            }
//        }
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
    
    
    // MARK: - backButtonTapped
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - editButtonTapped(수정 페이지로 이동 + 데이터 전달
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: "WritingEditPageViewController") as? WritingEditPageViewController else { return }
        
        vc.place = place // Place 데이터 전달 (diary, total_spending)
        vc.spendings = spendings // spendings(상세 지출) 데이터 전달
        vc.photoArray = self.photoArray
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension WritingPageViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 각 셀의 크기를 지정
        var cgSize = CGSize(width: 386, height: collectionView.frame.height)
        return cgSize
    }
       
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritingEditPhotosCollectionViewCell", for: indexPath) as? WritingEditPhotosCollectionViewCell else { return UICollectionViewCell() }
        cell.photos.image =
        self.photoArray[indexPath.row]
        return cell
        
    }
    

    
}
    
    

//MARK: - WriringPageVieController
extension WritingPageViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        spendings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GetpriceTableViewCell", for: indexPath) as? GetpriceTableViewCell else { return UITableViewCell() }
        
        
        let spending = spendings[indexPath.row] // 상세 지출 내역
        cell.itemLabel.text = spending.name
        cell.amountLabel.text = "\(spending.quantity ?? 1)"
        cell.priceLabel.text = "\(spending.price ?? 0)"
        
        return cell
    }
}
