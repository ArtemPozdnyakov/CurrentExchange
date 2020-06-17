//
//  SearchMap.swift
//  ExchangeRates
//
//  Created by admin on 6/5/20.
//  Copyright © 2020 Artem Pozdnyakov. All rights reserved.
//

import UIKit
import YandexMapKit
import YandexMapKitSearch
import CoreLocation


/**
 * This example shows how to add and interact with a layer that displays search results on the map.
 * Note: search API calls count towards MapKit daily usage limits. Learn more at
 * https://tech.yandex.ru/mapkit/doc/3.x/concepts/conditions-docpage/#conditions__limits
 */
class SearchViewController: UIViewController, YMKMapCameraListener {
    
    var mapView: YMKMapView = YMKMapView()
    var searchManager: YMKSearchManager?
    var searchSession: YMKSearchSession?
    
    
    var latitude: Double = 0
    var longtude: Double = 0
    
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
   
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    
   
    
    func requestLocation(lat: Double, long: Double) {
        latitude = lat
        longtude = long
        
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
        
       let com = mapView.mapWindow.map//.mapWindow.map.addCameraListener(with: self)
        com.addCameraListener(with: self)
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: YMKPoint(latitude: latitude, longitude: longtude),
            zoom: 14,
            azimuth: 0,
            tilt: 0))
    }
    
    
    
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateSource: YMKCameraUpdateSource,
                                 finished: Bool) {
        if finished {
            let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
                if let response = searchResponse {
                    self.onSearchResponse(response)
                } else {
                    self.onSearchError(error!)
                }
            }
            
            searchSession = searchManager!.submit(
                withText: "обмен валют",
                geometry: YMKVisibleRegionUtils.toPolygon(with: map.visibleRegion),
                searchOptions: YMKSearchOptions(),
                responseHandler: responseHandler)
        }
    }
    
    func onSearchResponse(_ response: YMKSearchResponse) {
        let mapObjects = mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        for searchResult in response.collection.children {
            if let point = searchResult.obj?.geometry.first?.point {
                let placemark = mapObjects.addPlacemark(with: point)
                placemark.setIconWith((UIImage(named: "touchka"))!)
            }
        }
    }
    
    func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longtude = location.coordinate.longitude
        requestLocation(lat: latitude, long: longtude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription )
    }
}

