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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.20, longitude: -92.01),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
    }
}

final class ContentViewModel:ObservableObject {
    var locationManager: CLLocationManager?
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
