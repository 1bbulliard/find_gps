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
// i'm using this as a model https://www.youtube.com/watch?v=hWMkimzIQoU&t=1275s

struct ContentView: View {
 
 //   @StateObject  var viewModel = ContentViewModel()
    @ObservedObject var viewModel = ContentViewModel()
 
    var body: some View {
       
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onTapGesture {
                viewModel.GetLatLong()
                viewModel.checkiflocationservicesisenabled()
                viewModel.checkLocationAuthorization()
              //  viewModel.locationManager?.startUpdatingLocation()
            }
            .onAppear {
                viewModel.checkiflocationservicesisenabled()
                viewModel.GetLatLong()
                viewModel.checkLocationAuthorization()
              //  viewModel.locationManager?.startUpdatingLocation()
                }
       
      
      //  viewModel.checkiflocationservicesisenabled()
     //   viewModel.checkLocationAuthorization()
        
        let result = viewModel.GetLatLong()
        Text("Lat: \(result.0)")
        Text("long: \(result.1)")
     
    }
    
    
}



class ContentViewModel: NSObject, ObservableObject,
CLLocationManagerDelegate{
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.20, longitude: -92.01),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var locationManager: CLLocationManager?
    override init()
    {
        super.init()
        locationManager?.delegate = self
    }

    @State var stat = 0
    @State var stat2 = 0
    
  
    func GetLatLong() -> (Double, Double)
    {
 
        locationManager?.startUpdatingLocation()
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        print("lat: \(latitude)")
        stat2 = 3
        return (latitude ?? 0, longitude ?? 0)
    }
    func checkiflocationservicesisenabled()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
          
        } else {
            print("show an alert")
        }
       
    }
 func checkLocationAuthorization() {
    
     guard let locationManager = locationManager else {return}
        switch locationManager.authorizationStatus {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            stat = 1
        case .restricted:
            print("your location is restricted maybe due to parental control")
            stat = 2
        case .denied:
            print("you have denied permission for this app.. plz go into app allow")
            stat = 3
        case .authorizedAlways:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            stat = 4
                break
            
        case
          .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            locationManager.startUpdatingLocation()
            
            stat = 5
            break
        @unknown default:
            stat = 6
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

