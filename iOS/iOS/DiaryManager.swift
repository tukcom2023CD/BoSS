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
    
    // 전체 멤버 리스트 만들기 (꼭 필요하지 않고, 원래 배열에 멤버 생성해도 됨)
    func makeDiaryDatas() {
        diaryList = [
       Diary(imageCard: UIImage(named: "여행사진"), contents: "Text messaging, or texting, is the act of composing and sending electronic messages, typically consisting of alphabetic and numeric characters, between two or more users of mobile devices, desktops/laptops, or another type of compatible computer. Text messages may be sent over a cellular network, or may also be sent via satellite or Internet connection.The term originally referred to messages sent using the Short Message Service (SMS). It has grown beyond alphanumeric text to include multimedia messages using the Multimedia Messaging Service (MMS) containing digital images, videos, and sound content, as well as ideograms known as emoji (happy faces, sad faces, and other icons), and instant messenger applications (usually the term is used when on mobile devices")
       ]
           
    }
    
    // 전체 멤버 리스트 얻기
    func getDiaryList() -> [Diary] {
        return diaryList
    }
    
//    // 새로운 일지 만들기 (인덱스 정리가 안돼서 일단 남김)
//    func makeNewDiary(_ member: Member) {
//        membersList.append(member)
//    }
    
    // 일지의 정보 업데이트 인덱스 0
    func updateDiaryInfo(diary: Diary) {
        diaryList[0] = diary
    }
    
//
//    subscript(index: Int) -> Diary {
//        get {
//            return diaryList[index]
//        }
//    }
}
