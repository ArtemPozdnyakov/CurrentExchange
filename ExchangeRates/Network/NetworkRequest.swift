//
//  NetworkRequest.swift
//  Exchange Rates
//
//  Created by admin on 6/4/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Alamofire

protocol NetworkDelegate: class {
    func updateInterface(with current: CourseModel)
}

final class NetworkRequest {
    let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
    weak var delegate: NetworkDelegate?
    
    func getCourse() {
        DispatchQueue.global().async {
            AF.request(self.url!).response { response in
                if let data = response.data {
                    if let current = self.parseJSON(withData: data) {
                        self.delegate?.updateInterface(with: current)
                    }
                }
            }
        }
    }
    
    
    fileprivate func parseJSON(withData data: Data) -> CourseModel? {
        let decoder = JSONDecoder()
        do {
            let currentData = try decoder.decode(CourseDataModel.self, from: data)
            let current = CourseModel(courseDataModel: currentData)
            return current
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
