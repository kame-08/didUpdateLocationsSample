//
//  ContentView.swift
//  didUpdateLocationsSample
//
//  Created by Ryo on 2022/08/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = LocationManager()
    var body: some View {
        VStack {
            Text("緯度: \(viewModel.latitude)")
            Text("経度: \(viewModel.longitude)")
        }
    }
}

import SwiftUI
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate,ObservableObject {
    
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    
    var locationManager : CLLocationManager?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        locationManager!.requestWhenInUseAuthorization()
        

    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            // 更新に必要な最小移動距離
            locationManager!.distanceFilter = 10
            // 徒歩、自動車等の移動手段
            locationManager!.activityType = .fitness
            // 位置情報取得開始
            locationManager!.startUpdatingLocation()
        case .notDetermined, .denied, .restricted:
            // ...
            break
        default:
            // ...
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        
        latitude = location.latitude
        longitude = location.longitude
        print("緯度: \(location.latitude) 経度: \(location.longitude)")

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
