//
//  MapView.swift
//  MyMap
//
//  Created by yagi.hiro on 2023/09/20.
//

import SwiftUI
import MapKit

enum MapType {
    case standard
    case satelite
    case hybrid
}

struct MapView: UIViewRepresentable {
    let searchKey: String
    let mapType: MapType
    
    func makeUIView(context: Context) -> MKMapView {
        // return MKMapView()、return省略可能
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("検索キーワード：\(searchKey)")
        
        switch mapType {
        case .standard:
            uiView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .flat)
        case .satelite:
            uiView.preferredConfiguration = MKImageryMapConfiguration()
        case .hybrid:
            uiView.preferredConfiguration = MKHybridMapConfiguration()
        }
        
        let geocoder = CLGeocoder()
        
        // トレイリングクロージャ(completionHandlerが省略されているが意味は一緒)
        // geocoder.geocodeAddressString(searchKey) { placemarks, error in
        geocoder.geocodeAddressString(
            searchKey,
            completionHandler: { (placemarks, error) in
            if let placemarks,
               let firstPlacemark = placemarks.first,
               let location = firstPlacemark.location {
                let targetCoordinate = location.coordinate
                print("経緯経度：\(targetCoordinate)")
                
                let pin = MKPointAnnotation()
                
                pin.coordinate = targetCoordinate
                
                pin.title = searchKey
                
                uiView.addAnnotation(pin)
                
                uiView.region = MKCoordinateRegion(
                    center: targetCoordinate,
                    latitudinalMeters: 500.0,
                    longitudinalMeters: 500.0)
                
            }
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(searchKey: "羽田空港", mapType: .standard)
    }
}
