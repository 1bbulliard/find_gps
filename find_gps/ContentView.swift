//
//  ContentView.swift
//  find_gps
//
//  Created by Bob Bulliard on 3/24/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

import MapKit



struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.20, longitude: -92.01),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear {
                viewModel.checkiflocationservicesisenabled()
                }
    
    }

}
        
class ContentViewModel: NSObject, ObservableObject,
CLLocationManagerDelegate{
    var locationManager: CLLocationManager?
    func checkiflocationservicesisenabled()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            //    checkLocationAuthorization()
        } else {
            print("show an alert")
        }
    }
 func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("your location is restricted maybe due to parental control")
        case .denied:
            print("you have denied permission for this app.. plz go into app allow")
        case .authorizedAlways:
                break
        case
          .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
}
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

