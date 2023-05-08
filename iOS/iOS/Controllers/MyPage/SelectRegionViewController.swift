//
//  selectRegionViewController.swift
//  iOS
//
//  Created by JunHee on 2023/04/11.
//

import UIKit
import SwiftSoup

// 여행 지역 선택 화면
class SelectRegionViewController : UIViewController {
    
    // Delegate 프로토콜 채택
    weak var delegate: MyDelegate?
    
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var regionArray = [String]() // 지역 이름 배열
    var selectedRegion = "" // 선택된 지역 이름
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        localPasing()
    }
    
    // UI 설정
    func setUI() {
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 컬렉션 뷰 UI 코드 설정
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeightSize * -0.12),
        ])
        
        // 버튼 스택 뷰 UI 코드 설정
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            // 상단으로 부터 떨어진 거리 설정
            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeightSize * -0.04),
            // X축 중심에 맞춤
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 사이즈 설정
        ])
        
        // 취소 버튼 UI 코드 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            cancelButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.cancelButton.layer.cornerRadius = screenWidthSize * 0.03
        
        // 선택 버튼 UI 코드 설정
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            applyButton.widthAnchor.constraint(equalToConstant: screenWidthSize * 0.3),
            applyButton.heightAnchor.constraint(equalToConstant: screenWidthSize * 0.1)
        ])
        self.applyButton.layer.cornerRadius = screenWidthSize * 0.03
    }
    
    // 지역 정보 가져오기
    func localPasing(){
        guard let url = URL(string: "https://ko.wikipedia.org/wiki/%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD%EC%9D%98_%EC%9D%B8%EA%B5%AC%EC%88%9C_%EB%8F%84%EC%8B%9C_%EB%AA%A9%EB%A1%9D#%EA%B0%99%EC%9D%B4_%EB%B3%B4%EA%B8%B0") else {
            return
        }
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            
            let table: Element = try doc.select("table.wikitable").first()!
            let rows: Elements = try table.select("tr")
            
            let numRows = rows.count
            
            for (i, row) in rows.enumerated() {
                if i == numRows - 1 { // 맨 마지막 행에서는 반복문을 종료
                    break
                }
                let cols: Elements = try row.select("td:eq(1)")
                for col in cols {
                    let data = try col.text()
                    regionArray.append(data)
                    print(try col.text())
                }
            }
        } catch Exception.Error(let type, let message) {
            print("\(type) : \(message)")
        } catch {
            print("error")
        }
        collectionView.reloadData()
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
    // 셀 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regionArray.count
    }
    
    // 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "regionCell", for: indexPath) as?
                regionCell else {
            return UICollectionViewCell()
        }
        
        // 화면 사이즈 값 저장
        let screenWidthSize = UIScreen.main.bounds.size.width
        let screenHeightSize = UIScreen.main.bounds.size.height
        
        // 제약 조건 코드 설정
        cell.regionName.translatesAutoresizingMaskIntoConstraints = false
        cell.regionCheckImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cell.regionName.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: screenWidthSize * 0.06),
            cell.regionName.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.regionCheckImage.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -screenWidthSize * 0.06),
            cell.regionCheckImage.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.regionCheckImage.widthAnchor.constraint(equalToConstant : screenWidthSize * 0.075),
            cell.regionCheckImage.heightAnchor.constraint(equalToConstant : screenWidthSize * 0.075)
        ])
        
        // cell UI 설정
        cell.layer.cornerRadius = screenWidthSize * 0.06
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // cell 그림자 설정
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5
        
        // cell 내용 설정
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
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var regionCheckImage: UIImageView!
}
