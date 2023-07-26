//
//  WritingPageViewController.swift
//  iOS
//
//  Created by 이정동 on 2023/02/13.
//

import UIKit


class WritingPageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiphotoView: UIView!
    @IBOutlet weak var outView: UIView!
    @IBOutlet weak var contents: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var labelView: UIView!
    var photoArray: [ImageData] = []
    
    @IBOutlet weak var indexBackView: UIView!
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var noImageView: UIImageView!
    // MARK: 이미지 터치기능을 위한 didset
    @IBOutlet var imageView: UIImageView!{
        didSet {
            imageView.isUserInteractionEnabled = true
            imageView.image = UIImage(named: "영수증보기")
        }
    }
    var onTapped :Bool = true
    
    
    // 새로 추가한 변수
    var place: Place!
    var spendings: [Spending] = []
    var currentPage : Int = 0
    var lastContentOffset: CGFloat = 0 // 셀 넘길때 인덱스 오류막음
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        var totalPrice : Int = 0
        // 전화면에서 전달받은 데이터들을 통해 셋팅
       
        if place.diary == "" {
            contents.text = "여행을 기록해보세요"
            contents.textColor = .lightGray
        }else{
            contents.text = place.diary
            contents.textColor = .black
        }
        // contents.text = place.diary
        
        if (spendings.count != 0){
            for i in 0...spendings.count-1{
                totalPrice += (spendings[i].quantity ?? 1) * (spendings[i].price ?? 0)
            }
            // costLabel.text = String(totalPrice)
            place.totalSpending! += totalPrice
            costLabel.text = NumberFormatter.numberFormatter(number:totalPrice)//"\(totalPrice)"
        }
        collectionView.reloadData()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        pageControl.currentPage = 0
        pageControl.numberOfPages = photoArray.count
        
        contents.translatesAutoresizingMaskIntoConstraints = false
        indexBackView.layer.cornerRadius = 10
        pageControl.layer.cornerRadius = 10
        
        // 테이블 뷰 데이터 설정
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tableHeight = tableView.frame.height
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: uiphotoView.frame.height + labelView.frame.height + tableView.contentSize.height + 100)
        // 테이블 뷰의 높이 증가
        
        outView.frame.size.height = scrollView.contentSize.height
        tableView.frame.size.height = tableHeight
        
        tableView.reloadData()
        
    }
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTitleMode()
      //  costViewSetting()
        onTapped = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.isHidden = true
        
        
        
        
        labelViewSetting()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageButtonTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        uploadImageCard {
                self.pageControl.numberOfPages = self.photoArray.count
                self.collectionView.reloadData()
            }
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0 // 셀 사이의 수평 간격
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // 콜렉션 뷰 경계선으로부터 셀까지의 여백
        collectionView.collectionViewLayout = layout
        
        //테이블뷰 겉의 선
        tableView.layer.masksToBounds = true
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowRadius = 4
        tableView.layer.shadowOpacity = 0.3
        
        let tableHeight = tableView.frame.height
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: uiphotoView.frame.height + labelView.frame.height + tableView.contentSize.height + 100)
        // 테이블 뷰의 높이 증가
        
        outView.frame.size.height = scrollView.contentSize.height
        tableView.frame.size.height = tableHeight
        
        tableView.reloadData()
        // 테이블 뷰의 높이 증가
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        self.viewDidLayoutSubviews()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 스크롤 뷰 컨텐츠 크기 재설정
        let contentHeight = uiphotoView.frame.height + labelView.frame.height + tableView.contentSize.height + 100
        if scrollView.contentSize != CGSize(width: scrollView.frame.width, height: contentHeight) {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
        }
        
        
    }
    
    
    
    @objc private func imageButtonTapped(_ sender: UITapGestureRecognizer) {
        onTapped = !onTapped
        
        //애니메이션 동작할때는 chevron.up이 회전하고 이동작이 끝나면 completion
        UIView.animate(withDuration: 0.3) {
            if self.onTapped {
                self.imageView.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } completion: { _ in //테이블 뷰 보이기/숨기기
            if self.onTapped {
                hideTableView()
                
            } else {
                showTableView() // showTableView() 메서드를 호출하여 애니메이션 실행
                
            }
        }
        func hideTableView() {
            self.tableView.isHidden = true
            
            var delayCounter = 0.1
            
            let cells = tableView.visibleCells
            for i in 0..<cells.count {
                let cell = cells[i]
                UIView.animate(withDuration: 0.5, delay: delayCounter, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: -self.tableView.bounds.height)
                }, completion: { _ in
                    // 셀의 위치를 초기화합니다.
                    cell.transform = CGAffineTransform.identity
                })
                delayCounter += 0.1
            }
            
        }
        
        func showTableView() {
            self.tableView.isHidden = false
            UIView.animate(withDuration: 0.8, animations: {
            })
            // 첫번째 row
            var delayCounter = 0.1
            for i in 0..<tableView.visibleCells.count {
                let cell = tableView.visibleCells[i]
                cell.transform = CGAffineTransform(translationX: 0, y: -tableView.bounds.height)
                UIView.animate(withDuration: 0.5, delay: delayCounter, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform.identity
                    
                }, completion: nil)
                delayCounter += 0.1
            }
        }
    }

    // MARK: - uploadImageCard
    // 여행지 사진 네트워킹 완전히 출력이후에 pageControl사용
    func uploadImageCard(completion: @escaping () -> Void) {
        PhotoNetManager.shared.read(uid: place.uid!, pid: place.pid!) { photos in
            var images = [ImageData]()
            let group = DispatchGroup()
            let queue = DispatchQueue(label: "com.myApp.photoQueue")
            
            // 여행지에 추가한 여러 사진들을 적용
            for photo in photos {
                group.enter()
                guard let url = URL(string: photo.imageUrl) else { continue }
                queue.async {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            images.append(ImageData(image: image, imageUrl: photo.imageUrl))
                        }
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.photoArray = images
                completion()
            }
        }
    }

    
    // MARK: - labelViewSetting() :UI세팅
    func labelViewSetting(){
        labelView.layer.cornerRadius = 10
        labelView.layer.borderWidth = 3
        labelView.layer.borderColor = UIColor.systemGray6.cgColor
        
        
    }
    
    //    // MARK: -costViewSetting() :UI세팅
    //    func costViewSetting(){
    //        costView.layer.cornerRadius = 10
    //    }
    //

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
    
    @IBAction func pageControlValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
extension WritingPageViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    
 
      func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          let count = photoArray.count
          indexLabel.text = "\(1) / \(count)"
          if lastContentOffset > collectionView.contentOffset.x {
              // User scrolled to previous page
              if indexPath.row > 0 {
                  pageControl.currentPage = indexPath.row - 1
                  indexLabel.text = "\(indexPath.row) / \(count)"
              }
          } else if lastContentOffset < collectionView.contentOffset.x {
              // User scrolled to next page
              if indexPath.row < count - 1 {
                  pageControl.currentPage = indexPath.row + 1
                  indexLabel.text = "\(indexPath.row + 2) / \(count)"
              }
          }
      }
      
      func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
          pageControl.currentPage = currentPage
          indexLabel.text = "\(currentPage + 1) / \(photoArray.count)"
      }
      
      func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
          lastContentOffset = scrollView.contentOffset.x
      }
      
      // Other UICollectionView delegate methods
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height - 26
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoArray.count == 0 {
            noImageView.image = UIImage(named: "빈이미지")
            noImageView.isHidden = false
            indexBackView.isHidden = true
            return 0
        } else {
            indexBackView.isHidden = false
            noImageView.isHidden = true
            return photoArray.count
        }
        // return self.photoArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WritingEditPhotosCollectionViewCell", for: indexPath) as? WritingEditPhotosCollectionViewCell else { return UICollectionViewCell() }
        cell.photos.image = self.photoArray[indexPath.row].image
        return cell
        
    }
    

    
}



//MARK: - WriringPageVieController
extension WritingPageViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let contentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        if contentHeight > tableViewHeight {
            // 셀 추가 시 테이블 뷰 높이 추가
            var frame = tableView.frame
            frame.size.height += cell.frame.size.height
            tableView.frame = frame
            
            // 스크롤뷰 프레임이랑 컨텐츠 높이 맞춰야함 -> 컨텐츠 높이 재계산 후 스크롤 뷰 컨텐츠 크기 조정
            let contentHeight = uiphotoView.frame.height + labelView.frame.height + tableView.contentSize.height + 100
            if scrollView.contentSize != CGSize(width: scrollView.frame.width, height: contentHeight) {
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        spendings.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GetpriceTableViewCell", for: indexPath) as? GetpriceTableViewCell else { return UITableViewCell() }
        
        
        if indexPath.row == 0 {
            // 라벨 폰트와 색상 변경
            cell.itemLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cell.amountLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cell.priceLabel.font = UIFont.boldSystemFont(ofSize: 18)
            cell.itemLabel.textColor = UIColor.black
            cell.amountLabel.textColor = UIColor.black
            cell.priceLabel.textColor = UIColor.black
            cell.layer.cornerRadius = 8
            // 셀의 테두리 색상 변경
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.darkGray.cgColor
            
            // 셀의 크기 변경
            cell.frame.size.height = 100
            // 첫 번째 row에 개수 라벨 추가
            cell.itemLabel.text = "품명"
            cell.amountLabel.text = "수량"
            cell.priceLabel.text = "가격"
        } else {
            cell.layer.cornerRadius = 0
            cell.itemLabel.font = UIFont.systemFont(ofSize: 17)
            cell.amountLabel.font = UIFont.systemFont(ofSize: 17)
            cell.priceLabel.font = UIFont.systemFont(ofSize: 17)
            cell.itemLabel.textColor = UIColor.darkGray
            cell.amountLabel.textColor = UIColor.darkGray
            cell.priceLabel.textColor = UIColor.darkGray
            cell.layer.borderWidth = 0
            cell.frame.size.height = 60
            
            let spending = spendings[indexPath.row-1] // 지출 내역은 첫 번째 row를 제외한 인덱스에 저장
            cell.itemLabel.text = spending.name
            cell.amountLabel.text = "\(spending.quantity ?? 1)"
            cell.priceLabel.text = NumberFormatter.numberFormatter(number:spending.price!)//"\(spending.price ?? 0)"
        }
        
        return cell
    }
}

