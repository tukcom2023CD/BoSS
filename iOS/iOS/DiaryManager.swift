//
//  DiaryManager.swift
//  iOS
//
//  Created by 박다미 on 2023/02/13.
//


import Foundation
import UIKit

final class DiaryManager {
    
  
    private var diaryList: [Diary] = []
    
  
    func makeDiaryDatas() {
        diaryList = [
       Diary(imageCard: UIImage(named: "여행사진"), contents: "Text messaging, or texting, is the act of composing and sending electronic messages, typically consisting of alphabetic and numeric characters, between two or more users of mobile devices, desktops/laptops, or another type of compatible computer. Text messages may be sent over a cellular network, or may also be sent via satellite or Internet connection.The term originally referred to messages sent using the Short Message Service (SMS). It has grown beyond alphanumeric text to include multimedia messages using the Multimedia Messaging Service (MMS) containing digital images, videos, and sound content, as well as ideograms known as emoji (happy faces, sad faces, and other icons), and instant messenger applications (usually the term is used when on mobile devices")
//       Diary(imageCard: UIImage(named: "tripimg"), contents: "두번째"),
//       Diary(imageCard: UIImage(named: "tripimg"), contents: "세번째")
       
       ]
        
           
    }
    
    // 전체 멤버 리스트 얻기
    func getDiaryList() -> [Diary] {
        return diaryList
    }
    

    
    // 일지의 정보 업데이트 인덱스 0
    func updateDiaryInfo(index: Int, diary: Diary) {
        diaryList[index] = diary
    }
    

}
