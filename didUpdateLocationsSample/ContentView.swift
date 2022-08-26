//
//  ContentView.swift
//  didUpdateLocationsSample
//
//  Created by Ryo on 2022/08/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AppDelegate()
    var body: some View {
        VStack {
            Text("緯度: \(viewModel.latitude)")
            Text("経度: \(viewModel.longitude)")
        }
    }
}

import SwiftUI
import CoreLocation


class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,ObservableObject {
    
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    
    var locationManager : CLLocationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        locationManager!.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            // 更新に必要な最小移動距離
            locationManager!.distanceFilter = 10
            // 徒歩、自動車等の移動手段
            locationManager!.activityType = .fitness
            // 位置情報取得開始
            locationManager!.startUpdatingLocation()
        }
        
        return true
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
