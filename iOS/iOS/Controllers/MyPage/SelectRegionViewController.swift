//
//  selectRegionViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/11.
//

import UIKit

class SelectRegionViewController : UIViewController {
    
    // Delegate 프로토콜 채택
    weak var delegate: MyDelegate?
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    let regionArray = ["서울", "부산", "인천", "전주", "태안", "춘천", "강릉"] // 지역 이름 배열
    var selectedRegion = "" // 선택된 지역 이름
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // UI 설정
    func setUI() {
        cancelButton.layer.cornerRadius = 20
        applyButton.layer.cornerRadius = 20
    }
    
    // 변경 실패 오류
    func applyErrorAlret() {
        let alertController = UIAlertController(title: "지역 선택", message: "지역을 선택해주세요", preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "확인", style: .cancel) { (action) in
            print("확인")
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(okayAction) // 액션 추가
        present(alertController, animated: true, completion: nil)
    }
    
    // 취소 버튼 눌렀을 때
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // 변경 버튼 눌렀을 때
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        if self.selectedRegion == "" {
            applyErrorAlret()
        } else {
            // Delegate 호출
            self.delegate?.didChangeValue(value : self.selectedRegion)
            dismiss(animated: true)
        }
    }
}

extension SelectRegionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    // 셀 수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regionArray.count
    }
    
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "regionCell", for: indexPath) as?
                regionCell else {
            return UICollectionViewCell()
        }
        
        // cell UI 설정
        cell.layer.cornerRadius = 25
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // cell 그림자 설정
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        
        // cell 내용 설정
        cell.regionImage.layer.cornerRadius = 40
        cell.regionName.text = self.regionArray[indexPath.row]
        
        if self.selectedRegion == cell.regionName.text! {
            cell.regionCheckImage.tintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.835628319, green: 0.9630018675, blue: 0.8461384469, alpha: 1)
        }
        else {
            cell.regionCheckImage.tintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
            
        return cell
    }
    
    // 셀이 선택되었을 때 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 셀의 인덱스 경로를 이용하여 작업을 수행합니다.
        if let cell = collectionView.cellForItem(at: indexPath) as? regionCell {
            
            // 만약 선택된 지역이름이 이미 선택한 셀의 이름이라면
            if self.selectedRegion == cell.regionName.text! {
                self.selectedRegion = "" // 선택된 지역 이름 초기화
                self.collectionView.reloadData()
                
            }
            else {
                self.selectedRegion = cell.regionName.text! // 선택된 지역 이름으로 설정
                self.collectionView.reloadData()
            }
        }
    }
}

class regionCell : UICollectionViewCell {
    
    
    @IBOutlet weak var regionImage: UIImageView!
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var regionCheckImage: UIImageView!
    
}
