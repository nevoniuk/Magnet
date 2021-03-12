//
//  ProfileView.swift
//  Magnet
//
//  Created by Esteban Richey on 3/12/21.
//

import Foundation
import UIKit

class ProfileView: UIViewController {
    
    @IBAction func reportIssuePress(sender: Any) {
        
        //sends you to a webpage to generate an email to "richeye@purdue.edu" Esteban Richey's email
        if let emailURL = URL(string: "https://e-mailer.link/100148080218/") {
            UIApplication.shared.open(emailURL)
        }
    }
    

}
