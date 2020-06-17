//
//  CourseDataModel.swift
//  ExchangeRates
//
//  Created by admin on 6/4/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Foundation

struct CourseDataModel: Codable {
    let valute: [String: Valutes]

    enum CodingKeys: String, CodingKey {
        case valute = "Valute"
    }
}

// MARK: - Valute
struct Valutes: Codable {
    let charCode: String
    let valuettt: Double
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case charCode = "CharCode"
        case valuettt = "Value"
        case fullName = "Name"
    }
}
