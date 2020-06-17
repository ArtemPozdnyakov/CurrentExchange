//
//  CourseModel.swift
//  ExchangeRates
//
//  Created by admin on 6/4/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Foundation

struct CourseModel {
    let valute: [String: Double]
    let fullName: [String: String]
    
    
    init(courseDataModel: CourseDataModel) {
        let c = courseDataModel.valute
        var dom: [String: Double] = [:]
        
            for (_,j) in c.enumerated(){
                dom[j.value.charCode] = j.value.valuettt
            }
        
        valute = dom
        
        var dom2: [String: String] = [:]
        for (_,j) in c.enumerated(){
            dom2[j.value.charCode] = j.value.fullName
        }
        fullName = dom2
    }
    
    init() {
        self.valute = [:]
        self.fullName = [:]
    }
}

