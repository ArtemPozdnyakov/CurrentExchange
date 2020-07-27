//
//  NetworkRequest.swift
//  Exchange Rates
//
//  Created by admin on 6/4/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import Alamofire
protocol NetworkWetherDelegate {
    func updateInterface(_: NetworkRequest, with currentWeather: CourseModel)
}


class NetworkRequest {
    let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
    var delegate: NetworkWetherDelegate?
    
    func getCourse() {
        DispatchQueue.global().async {
            AF.request(self.url!).response { response in
                if let data = response.data {
                    if let currentWeather = self.parseJSON(withData: data) {
                        self.delegate?.updateInterface(self, with: currentWeather )
                        print(currentWeather)
                    }
                }
            }
        }
    }
    
    
    fileprivate func parseJSON(withData data: Data) -> CourseModel? {
        let decoder = JSONDecoder()
        do {
            let currentWhetherData = try decoder.decode(CourseDataModel.self, from: data)
            guard let currentWeather = CourseModel(courseDataModel: currentWhetherData) else { return nil}
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
