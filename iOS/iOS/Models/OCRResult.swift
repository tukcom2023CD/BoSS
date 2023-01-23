//
//  Receipt.swift
//  iOS
//
//  Created by 이정동 on 2023/01/20.
//

import Foundation


struct OCRResult: Codable {
    let images: [Image]
}

struct Image: Codable {
    let receipt: Receipt
    let message: String
}

// MARK: - Receipt
struct Receipt: Codable {
    let receiptData: ReceiptData
    
    enum CodingKeys: String, CodingKey {
        case receiptData = "result"
    }
}

// MARK: - Result
struct ReceiptData: Codable {
    let storeInfo: StoreInfo
    let paymentInfo: PaymentInfo
    let subResults: [SubResult]
    let totalPrice: TotalPrice
}

// MARK: - StoreInfo
struct StoreInfo: Codable {
    let name, subName: Name
    let address: [Name]
}

// MARK: - Name
struct Name: Codable {
    let text: String
    let formatted: NameFormatted
}

// MARK: - NameFormatted
struct NameFormatted: Codable {
    let value: String
}

// MARK: - PaymentInfo
struct PaymentInfo: Codable {
    let date: DateClass
    let time: Time
}

// MARK: - DateClass
struct DateClass: Codable {
    let text: String
    let formatted: DateFormatted
}

// MARK: - DateFormatted
struct DateFormatted: Codable {
    let year, month, day: String
}

// MARK: - Time
struct Time: Codable {
    let text: String
    let formatted: TimeFormatted
}

// MARK: - TimeFormatted
struct TimeFormatted: Codable {
    let hour, minute, second: String
}

// MARK: - SubResult
struct SubResult: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let name, count: Name
    let priceInfo: PriceInfo
}

// MARK: - PriceInfo
struct PriceInfo: Codable {
    let price, unitPrice: Name
}

// MARK: - TotalPrice
struct TotalPrice: Codable {
    let price: Name
}
