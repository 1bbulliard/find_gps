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
    //    @ObservableObject var lat: Double
    @StateObject  var viewModel = ContentViewModel()
    //    @ObservedObject var viewModel = ContentViewModel()
    //@ObservedObject var viewModelx:EnvironmentViewModel
    @StateObject var viewModelx:EnvironmentViewModel = EnvironmentViewModel()
    var body: some View {
        //  ScrollView{
        NavigationView{
        VStack {
            //  ZStack{
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            
                .ignoresSafeArea()
                .accentColor(Color(.systemPink))
                .onTapGesture {
                    viewModel.GetLatLong()
                    //   viewModel.locationManagerDidChangeAuthorization(<#T##manager: CLLocationManager##CLLocationManager#>)
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
            
           
            
            let result = viewModel.GetLatLong()
            Text("Lat: \(result.0)")
            Text("long: \(result.1)")
          
      //      move navigation view up
        //    NavigationView{
                NavigationLink("Click here for assistance:-->",
                               destination: EnvironmentViewModel51(viewModelx: viewModelx))
                
            }
            
            
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
            //     print("lat: \(latitude)")
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
    
    
    struct DataArray: Identifiable, Hashable {
        let id: String = UUID().uuidString
        let numbr: String
        let gps: Double
        let gps2: Double
    }
    class EnvironmentViewModel: ObservableObject{
        @Published var dataArray: [DataArray] = []
        @Published var do_once = true
        //maybe
        @ObservedObject var viewModel = ContentViewModel()
        
        init() {
            getData()
        }
        func getData() {
            
            let x = DataArray(numbr: "3372777878",gps: 33, gps2: 90)
            dataArray.append(contentsOf: [x])
            let y = DataArray(numbr: "3372771234",gps: 31, gps2: 90)
            dataArray.append(contentsOf: [y])
            
        }
        func additz(parm1: String) {
            let result = viewModel.GetLatLong()
            //  Text("Lat: \(result.0)")
            //  Text("long: \(result.1)")
            let y = DataArray(numbr: "\(parm1)",gps: result.0, gps2: result.1)
            dataArray.append(contentsOf: [y])
            
            
        }
    }
    
    
    struct EnvironmentViewModel51: View {
        // To use environment;
        //   1). add the StateObject as i did with the Observable object
        //   2).then add the.environmentObject below. step 1 and 2 are in the initial/primary view
        // To each sub view, add:
        //      @EnvironmentObject var viewModel: EnvironmentViewModel
        
        //    @StateObject var viewModelx:EnvironmentViewModel = EnvironmentViewModel()
        // should be state i think
         @ObservedObject var viewModelx:EnvironmentViewModel
      //  @StateObject var viewModelx:EnvironmentViewModel = EnvironmentViewModel()
        @State var num = ""
        @State private var showingPopover = false
        @State private var showingAlert = false
        //  let resultxx = viewModelx.dataArray {$1 = 90}
        var body: some View {
            //  ScrollView {
            VStack
            {
                //  Text("Phone numbers to call for help:")
                NavigationView {
                    
                    List {
                        
                        ForEach(viewModelx.dataArray, id: \.self){item in
                            
                            Text("--> \(item.numbr) GPS:  \(item.gps) \(item.gps2)"
                                 
                            )
                            .font(.system(size: 12, weight: .medium, design: .default))
                            
                        }
                        
                        .navigationTitle("Phone numbers to Call for help:")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    }
                }
                //   .frame(width:400, height: 212, alignment: .leading)
            }
            
            
            
            
            TextField("Please enter your number to help:", text: $num)
            Button("Save your number") {
                viewModelx.additz(parm1: num)
                showingAlert = true
                            }
            .alert("Thanks for adding your name to help others!!", isPresented: $showingAlert) {
                Button("ok") { }
            }
            
            //
            //        }
            
        }
        //  }
        
    }
    
    
    
    
    // end
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
             ContentView()
          //  EnvironmentViewModel51(viewModelx: viewModelx))
        }
    }
    
}
