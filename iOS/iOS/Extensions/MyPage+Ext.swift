//
//  MyPage+Ext.swift
//  iOS
//
//  Created by JunHee on 2023/02/14.
//

import Foundation
import UIKit

extension MyPageViewController : UITableViewDataSource, UITableViewDelegate {
    
    // 테이블 설정 함수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell", for: indexPath) as? CustomTableCell else {
             return UITableViewCell()
         }
         cell.labelTitle.text = titleArray[indexPath.row]
         cell.labelContent.text = contentArray[indexPath.row]
         cell.selectionStyle = .none
        
         return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "ShowSchedule", sender: nil)
        case 1: self.performSegue(withIdentifier: "ShowSpending", sender: nil)
        default:
            return
        }
    }
}


extension MyPageScheduleViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    // 컬렉션 뷰 cell 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleData.count
    }

    // 컬렉션 뷰 cell 내용 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomScheduleCollecionCell", for: indexPath) as?
                CustomScheduleCollecionCell else {
                return UICollectionViewCell()
            }
        
        // cell 설정
        cell.layer.cornerRadius = 20 // 둥근 모서리
        cell.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
        cell.layer.masksToBounds = false // 그림자 잘림 방지
        cell.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치
        cell.layer.shadowRadius = 5 // 그림자 반경
        cell.layer.shadowOpacity = 0.3 // alpha값
        
        // cell 내용 설정
        cell.scheduleTitle.text = scheduleData[indexPath.row].title
        cell.regionLabel.text = scheduleData[indexPath.row].region
        cell.startLabel.text = scheduleData[indexPath.row].start
        cell.stopLabel.text = scheduleData[indexPath.row].stop
        cell.scheduleImage.image = imageArray[indexPath.row]
        cell.statusLabel.text = status[indexPath.row]
        cell.statusLabel.layer.cornerRadius = 30
        cell.statusLabel.layer.borderWidth = 2
        
        if cell.statusLabel.text == "완료" {
            cell.statusLabel.textColor = UIColor.lightGray
            cell.statusLabel.layer.borderColor = UIColor.lightGray.cgColor
        } else if cell.statusLabel.text == "진행중" {
            cell.statusLabel.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.statusLabel.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
                
        // cell 내부 이미지 설정
        cell.scheduleImage.layer.cornerRadius = 30
        cell.scheduleImage.clipsToBounds = true
        
        return cell
    }
}

