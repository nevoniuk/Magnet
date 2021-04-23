//
//  GroupMessages.swift
//  Magnet
//
//  Created by Esteban Richey on 4/23/21.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation
import Foundation
import StoreKit
import UserNotifications
import AVFoundation


class GroupMessages: UIViewController {
    
    @IBAction func share(_ sender: Any) {
            let activityVC = UIActivityViewController(activityItems: ["https://github.com/estebanrichey/Magnet"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
    }
    
    
}
