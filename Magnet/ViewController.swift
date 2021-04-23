//
//  ViewController.swift
//  Magnet
//
//  Created by Esteban Richey on 2/22/21.
//
import UIKit
import Firebase
import MapKit
import CoreLocation
import Foundation
import StoreKit
import UserNotifications
import AVFoundation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    @IBOutlet var mapView: MKMapView?
    @IBOutlet var rbutton: UIButton!
    
    var player: AVPlayer?
    @IBAction func share(_ sender: Any) {
            let activityVC = UIActivityViewController(activityItems: ["https://github.com/estebanrichey/Magnet"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
    }
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        playVid()
        setup()
      
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]){
            (granted, error) in
        }

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "testing notification!"
        notificationContent.body = "testing content"

        let date = Date().addingTimeInterval(0.1)

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: notificationContent, trigger: trigger)

        center.add(request){
            (error) in
        }
       

        // Add an overlay
        
        // Do any additional setup after loading the view.
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 39.611, longitude: -87.696)
        annotation.title = "Person 1"
        mapView?.addAnnotation(annotation)
        let testing = CLLocation(latitude: 40.000 as CLLocationDegrees, longitude: -88.000 as CLLocationDegrees)
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 25.9875, longitude: -97.186389)
        annotation2.title = "Person 2"
        mapView?.addAnnotation(annotation2)
        
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 43.8791, longitude: -103.4591)
        annotation3.title = "Person 3"
        mapView?.addAnnotation(annotation3)
        
        let annotation4 = MKPointAnnotation()
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 39.8875, longitude: -83.445)
        annotation4.title = "Person 4"
        mapView?.addAnnotation(annotation4)
        
        let annotation5 = MKPointAnnotation()
        annotation5.coordinate = CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190)
        annotation5.title = "Person 5"
        mapView?.addAnnotation(annotation5)
    
    }
    
    func setup() {
        // Assign delegate here. Can call the circle at startup,
        // or at a later point using the method below.
        // Includes <# #> syntax to simplify code completion.
        mapView?.delegate = self
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 39.611, longitude: -87.696),
                   radius: CLLocationDistance(SignInViewController.radius))
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 25.9875, longitude: -97.186389),
                   radius: CLLocationDistance(SignInViewController.radius))
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 43.8791, longitude: -103.4591),
                   radius: CLLocationDistance(SignInViewController.radius))
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 39.8875, longitude: -83.445),
                   radius: CLLocationDistance(SignInViewController.radius))
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190),
                   radius: CLLocationDistance(SignInViewController.radius))
        showCircle(coordinate: CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190),
                   radius: CLLocationDistance(SignInViewController.radius))
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D,
                    radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate,
                              radius: radius)
        mapView?.addOverlay(circle)
    }
    
    
    func playVid(){
        let path = Bundle.main.path(forResource: "Dubrovnik - 12866", ofType: ".mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player!.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player!.currentTime())
        player!.seek(to: CMTime.zero)
        player!.play()
        self.player?.isMuted = true
    }
    
    @objc func playerItemDidReachEnd(){
        player!.seek(to: CMTime.zero)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
           if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
               circle.strokeColor = UIColor.blue
               circle.fillColor = UIColor(red: 150, green: 100, blue: 0, alpha: 0.2)
               circle.lineWidth = 1
               return circle
           } else {
               return nil
           }
       }
    
    
    
    let locManager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
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
        
        mapView?.setRegion(region, animated: true)
        let point = MKPointAnnotation()
        point.coordinate = coordinate
        mapView?.addAnnotation(point)
        showCircle(coordinate: point.coordinate,
                   radius: 333333)

    }
    
    @IBAction func tapped(_ sender: Any){
        guard let scene = view.window?.windowScene else{
            print ("none")
            return
        }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview(in: scene)
        } else {
            // Fallback on earlier versions
        }
    }
    /**
    @objc private func tapped(){

     guard let scene = view.window?.windowScene else{
         print ("none")
         return
     }
     if #available(iOS 14.0, *) {
         SKStoreReviewController.requestReview(in: scene)
     } else {
         // Fallback on earlier versions
     }
}
 */
}

extension ViewController{
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If you want to include other shapes, then this check is needed.
        // If you only want circles, then remove it.
        var circleRenderer = MKCircleRenderer()
        if let circleOverlay = overlay as? MKCircle {
            circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = UIColor.blue
            circleRenderer.strokeColor = .black
            circleRenderer.alpha = 0.3
        }

        // If other shapes are required, handle them here
        return circleRenderer
    }
}


