//
//  MAPVC.swift
//  Magnet
//
//  Created by Yuanqi Cao on 3/7/21.
//

import UIKit
import GoogleMaps

class MAPVC: UIViewController {
    
    var mapView: GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()

        GMSServices.provideAPIKey("AIzaSyAXuSJ-ig_PoDKy3BvFnMnqvX7Mbahl5_E")
            let camera = GMSCameraPosition.camera(withLatitude: 12.123456, longitude: -123.123456, zoom: 12)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
            view = mapView
            
            let currentLocation = CLLocationCoordinate2DMake(12.1234565, -122.1234565)
            let marker = GMSMarker(position: currentLocation)
            marker.title = "Location"
            marker.map = mapView
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: "next")
            
        }
func next(){
    let nextLocation = CLLocationCoordinate2DMake(37.234523, -122.387293)
    mapView?.camera = GMSCameraPosition.camera(withLatitude: nextLocation.latitude, longitude: nextLocation.longitude, zoom: 15)
    
    let marker = GMSMarker(position: nextLocation)
    marker.title = "station"
    marker.snippet = "Hello"
}
}
