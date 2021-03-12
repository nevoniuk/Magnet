//
//  MAPVC.swift
//  Magnet
//
//  Created by Yuanqi Cao on 3/7/21.
//

import UIKit
import MapKit


class MAPVC: UIViewController, CLLocationManagerDelegate{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    let locManager = CLLocationManager()
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
        manager.stopUpdatingLocation()
        
        checkLocation(location)
        }
    }
    
    func checkLocation(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
    
    }
}


