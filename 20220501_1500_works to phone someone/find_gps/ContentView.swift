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
    
    @StateObject  var viewModel = ContentViewModel()
    
    @StateObject var viewModelx:EnvironmentViewModel = EnvironmentViewModel()
    var body: some View {
        
        NavigationView{
            VStack {
                
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
                
                Text("This app will provide numbers to you of people who have volunteered to help if you need assistance (example tow).  You may also add your number to provide assistance to other folks.  Click button below please.")
                    .font(.system(size: 9, weight: .light, design: .rounded))
                Divider()
                
                let result = viewModel.GetLatLong()
                let resultx = CLLocationManager().location?.coordinate.latitude
                Text("Lat: \(result.0) ")
               // Text("Lat: \(resultx)")
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
        @Published var latitude = CLLocationManager().location?.coordinate.latitude
        @Published var longitude = CLLocationManager().location?.coordinate.longitude
        // test this location
    //    @Published var location: CLLocation?
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
        //    let container: NSPersistantContainer
        //maybe
        @ObservedObject var viewModel = ContentViewModel()
        
        init() {
            getData()
        }
        func getData() {
            
            let x = DataArray(numbr: "337-277-7878",gps: 33, gps2: 90)
            dataArray.append(contentsOf: [x])
            let y = DataArray(numbr: "337-277-1234",gps: 31, gps2: 90)
            dataArray.append(contentsOf: [y])
            
        }
        func additz(parm1: String) {
            let result = viewModel.GetLatLong()
            //  Text("Lat: \(result.0)")
            //  Text("long: \(result.1)")
            let y = DataArray(numbr: "\(parm1)",gps: result.0, gps2: result.1)
            dataArray.append(contentsOf: [y])
            
            
        }
        func deletegps(indexset: IndexSet) {
            guard let index =  indexset.first else {return}
            //   let entity = dataArray [index]
            dataArray.remove(at: index)
            
            
            
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
                //      Text("Click a phone number to request help:")
                //      .font(.system(size: 12, weight: .semibold, design: .default))
                NavigationView {
                    //       Text("Click a phone number to request help:")
                    //       .font(.system(size: 12, weight: .semibold, design: .default))
                    List {
                        
                        ForEach(viewModelx.dataArray, id: \.self){item in
                            NavigationLink (destination: messview(selectedItem: item.numbr, lat: item.gps, longt: item.gps2),
                                            label: {
                                Text("--> \(item.numbr) GPS:  \(item.gps) \(item.gps2)")
                                
                                    .font(.system(size: 12, weight: .medium, design: .default))
                                
                                
                            }
                                            
                            )
                            
                        }
                        .onDelete (perform: viewModelx.deletegps)
                        //    .navigationTitle("Phone numbers to Call for help:")
                        //  .navigationBarTitle(Text("Phone numbers to call for help:").font(.custom(8))
                        .navigationBarTitle (Text("Click phone num to text help:"), displayMode: .inline)
                        
                        
                    }
                    
                }
                
            }
            
            
            
            
            
            TextField("or enter your own number to help:", text: $num)
            Button("Save your number") {
                viewModelx.additz(parm1: num)
                num = ""
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
    struct messview: View {
        let selectedItem: String
        let lat: Double
        let longt: Double
        //   @State parm2: String = "Please provide help"
        @State var parm2 = "Please provide help"
        @ObservedObject var viewModel = ContentViewModel()
        var body: some View {
            
            NavigationView{
                VStack {
                    Text("Click send to request help via text: \(selectedItem)")
                    Button("send") {
                        sendmessage(parm1: selectedItem, parm2: parm2, parm3: lat, parm4: longt)
                    }
                    Text("Click phone to request help via phone: \(selectedItem)")
                    Button("phone") {
                        phonex(parm1: selectedItem, parm2: parm2, parm3: lat, parm4: longt)
                    }
                }
            }
        }
        func sendmessage(parm1: String, parm2: String, parm3: Double, parm4: Double) {
            let result = viewModel.GetLatLong()
            let sms: String = "sms:\(parm1)&body=\(parm2) at lat:  \(result.0)  Longt: \(result.1)"
            let strurl: String =  sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string:strurl)!, options: [:], completionHandler: nil)
        }
        func phonex(parm1: String, parm2: String, parm3: Double, parm4: Double) {
            guard let number = URL(string:"tel://" + "\(parm1)") else { return }
            UIApplication.shared.open(number)
            
        }
    }
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            //  EnvironmentViewModel51(viewModelx: viewModelx);)
        }
    }
    
}
