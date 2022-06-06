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
      //  ScrollView{
//NavigationView{
        VStack {
           // ZStack{
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
       
      //  let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(viewModel.checkiflocationservicesisenabled), userInfo: nil, repeats: true)
      //  viewModel.checkiflocationservicesisenabled()
     //   viewModel.checkLocationAuthorization()
        
         //   }
        
        let result = viewModel.GetLatLong()
        Text("Lat: \(result.0)")
        Text("long: \(result.1)")
        Spacer()
      //  ScrollView {
        NavigationView{
            NavigationLink("Click here for assistance:-->",
                           destination: EnvironmentViewModel51())
            NavigationLink("Please go here for assistance-->",
                           destination: nextview())
        }
// Spacer()
      //  }
  //   Text("If you need a tow, let me know!!")
   //     Text("heres phone numbers that can help:")
  //      Text("3372777378")
  //      Text("3372778386")
    }
    
    
//}
 //   }
    }
struct nextview: View {
 
 //   @StateObject  var viewModel = ContentViewModel()
 //   @ObservedObject var viewModel = ContentViewModel()
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @State var num = ""
    var body: some View {
        TextField("Please enter your number to help:", text: $num)
         //   .keyboardType(.decimalPad)
           Text("If you need a tow, let me know!!")
              Text("heres phone numbers that can help:")
             Text("3372777378")
             Text("3372778386")
        Text("\(num)")
            .onAppear  {
                
                EnvironmentViewModel51()
              //  addit(parm1: num)
                
            }
        
    }
}
func additx(parm1: String) {
    @EnvironmentObject var viewModel: EnvironmentViewModel
    @ObservedObject var ViewModel: EnvironmentViewModel
   // @ObservedObject var progress: UserProgress
    viewModel.dataArray.append("\(parm1)")
      //  .environmentObject(viewModel)
    
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
// begin
class EnvironmentViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    init() {
      getData()
    }

        func getData() {
          //  self.dataArray.append("iphone")
          //  self.dataArray.append("ipad")
            self.dataArray.append(contentsOf: ["3372777378", "3378455489", "3372778454"])
        }
    }


struct EnvironmentViewModel51: View {
// To use environment;
//   1). add the StateObject as i did with the Observable object
//   2).then add the.environmentObject below. step 1 and 2 are in the initial/primary view
// To each sub view, add:
//      @EnvironmentObject var viewModel: EnvironmentViewModel
    
    @StateObject var viewModel:EnvironmentViewModel = EnvironmentViewModel()
    @State var num = ""
    var body: some View {
        VStack {
            NavigationView {
                List
                {
                    
                    ForEach(viewModel.dataArray, id: \.self){item in
                        NavigationLink (destination: DetailView(selectedItem: item),
                                        label: {
                            Text(item)
                            //Text(item)
                        }
                        )
                        
                    }
                }
                .navigationTitle("Phone numbers to Call:")
                .environmentObject(viewModel)
            }
        }
        //try this
        ScrollView {
        VStack {
            Text("Please enter your phone number to help: ")
        TextField("Please enter your number to help:", text: $num)
         //   .keyboardType(.decimalPad)
          // Text("If you need a tow, let me know!!")
            
        Text("\(num)")
        //addity(parm1: num)
      //  viewModel.dataArray.append("\(num)")
}
}
    }
    func addity(parm1: String) {
        @EnvironmentObject var viewModel: EnvironmentViewModel
        @ObservedObject var ViewModel: EnvironmentViewModel
       // @ObservedObject var progress: UserProgress
        viewModel.dataArray.append("\(parm1)")
          //  .environmentObject(viewModel)
        
    }
}
struct DetailView: View {
    
    //note: this view doesnt use the environment , but just passes one item
    // to this view
    let selectedItem: String
    
    var body: some View {
        ZStack{
        
        Color.orange.ignoresSafeArea()
            //
            NavigationLink(
                destination: FinalView(),
                label: {
                    Text(selectedItem)
                        
                    .font(.headline)
                .foregroundColor((.orange))
                .padding()
                .padding()
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(30)
                }
            )
                }
            
            //
            
            
        }
    }


struct FinalView: View {
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.red, Color.blue],
                           startPoint: .leading,
                           endPoint: .trailing)
            .ignoresSafeArea()
            ScrollView{
                VStack(spacing: 20){
                    ForEach(viewModel.dataArray, id:\.self) {item in
                        Text(item)
                    }
                    .environmentObject(viewModel)
                }
            }
            
        }
    }
}


// end
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

}
