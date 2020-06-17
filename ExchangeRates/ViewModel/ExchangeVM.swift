//
//  ExchangeVM.swift
//  ExchangeRates
//
//  Created by admin on 6/12/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Foundation

protocol ExchangeVM: class {

    var courseName: [String] { get set }
    var onUpdate: () -> Void { get set }
    var updateValues: (VisualModel) -> Void { get set }
    
    func set(value: String?)
    func set(type: String)
}



final class ExchangeVMImpl: ExchangeVM {
    
    
    private let net: NetworkRequest
    private var tempCourse: CourseModel = CourseModel()
    private var value: Double = 1
    private var type: String = ""
    
    var courseName: [String] = []
    
    var onUpdate: () -> Void = { }
    var updateValues: (VisualModel) -> Void = { _ in }
    
    init(networkServise: NetworkRequest) {
        self.net = networkServise
        networkServise.delegate = self
        networkServise.getCourse()
    }
    
    func set(value: String?) {
        
        if let tempValue = value, let it = Double(tempValue) {
            self.value = it
        } else {
            self.value = 1
        }
        
        updateValues(calkExchange(type: type, value: self.value))
    }
    
    func set(type: String) {
        self.type = type
        updateValues(calkExchange(type: type, value: value))
    }
    
    private func calkExchange(type: String, value: Double) -> VisualModel {
        
        var exchange: String = ""
        var fullName: String = ""
        
        
        if let course = tempCourse.valute[type] {
            exchange = "\((course * value).rounded())"
        }
        
        if let full = tempCourse.fullName[type] {
            fullName = full
        }
               
       return VisualModel(valueName: type, fullName: fullName, exchangeValue: exchange)
    }
}

extension ExchangeVMImpl: NetworkDelegate {
    func updateInterface(with current: CourseModel) {
        tempCourse = current
        courseName = current.valute.map { $0.key }
        onUpdate()
    }
}
