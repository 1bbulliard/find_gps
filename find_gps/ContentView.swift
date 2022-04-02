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
 
    @StateObject  var viewModel = ContentViewModel()
 //   @State  var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.20, longitude: -92.01),
  //                                                 span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State var coordinates: (lat: Double, lon: Double) = (0,0)
    var body: some View {
       // viewModel.GetLatLong()
        let coordinatesx = CLLocationManager().location?.coordinate.latitude
        let latitude = CLLocationManager().location?.coordinate.latitude
            let longitude = CLLocationManager().location?.coordinate.longitude
     //   let coordinate = CLLocationManager.location?.coordinate
     //   Text("\(coordinate.latitude)")
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onTapGesture {
                viewModel.GetLatLong()
            }
            .onAppear {
                viewModel.checkiflocationservicesisenabled()
                viewModel.GetLatLong()
                
                }
       
      
   //     Text("Lat: \(coordinatesx.description)")
    //    Text("Lat: \(ContentViewModel.CLLocationManager().location?.coordinate.latitude)")
        Text("Long: \(viewModel.GetLatLong())")
     //   Text("Stat: \(viewModel.stat)")//    Text("Stat2 sd b 3: \(viewModel.stat2)")
    //    print("Lat: \(viewModel.GetLatLong()")
 //       print("Long: \(viewModel.longtitude)")
  //      print("Stat: \(viewModel.stat)")
  //      print("Stat2 sd b 3: \(viewModel.stat2)")
    }
    
    
}



class ContentViewModel: NSObject, ObservableObject,
CLLocationManagerDelegate{
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.20, longitude: -92.01),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    var locationManager: CLLocationManager?
    @State var latitude: Double = 0.0
    @State  var longtitude: Double = 0.0
    @State var stat = 0
    @State var stat2 = 0
    
    func GetLatLong() -> Double
    {
     
        let latitude = CLLocationManager().location?.coordinate.latitude
        let longitude = CLLocationManager().location?.coordinate.longitude
        print("lat: \(latitude)")
        stat2 = 3
        return latitude ?? 0
    }
    func checkiflocationservicesisenabled()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        //    let x = locationManager?.location
         //   let latitude = x?.coordinate.latitude
         //   let longtitude = x?.coordinate.longitude
            let latitude = CLLocationManager().location?.coordinate.latitude
                let longitude = CLLocationManager().location?.coordinate.longitude
            print("lat: \(latitude)")
                checkLocationAuthorization()
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

