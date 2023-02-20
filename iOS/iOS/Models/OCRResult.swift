//
//  Receipt.swift
//  iOS
//
//  Created by 이정동 on 2023/01/20.
//

import Foundation


// MARK: - OCRResult
struct OCRResult: Codable {
    let images: [Image]
}

// MARK: - Image
struct Image: Codable {
    let receipt: Receipt
}

// MARK: - Receipt
struct Receipt: Codable {
    let result: ReceiptData
}

// MARK: - Result
struct ReceiptData: Codable {
    let storeInfo: StoreInfo
    let subResults: [SubResult]
    let totalPrice: Price
}

// MARK: - StoreInfo
struct StoreInfo: Codable {
    let name: Name
}

// MARK: - Name
struct Name: Codable {
    let text: String
    let formatted: Formatted
}

// MARK: - Formatted
struct Formatted: Codable {
    let value: String
}

// MARK: - SubResult
struct SubResult: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let name, count: Name
    let price: Price
}

// MARK: - Price
struct Price: Codable {
    let price: Name
}
