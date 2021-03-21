//
//  ProfilePageVC.swift
//  Magnet
//
//  Created by Esteban Richey on 3/21/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ProfilePageView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAccountPressed(_sender: UIButton) {
        
        var confirmDelete = false
        let alert = UIAlertController(title: "Confirm Account Deletion", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in NSLog("The \"OK\" alert occured.")}))
        
        self.present(alert, animated: true, completion: nil)
        
        
        if confirmDelete {
            
            let user = Auth.auth().currentUser
            
            
            user?.delete { error in
                if let error = error {
                    //an error occured
                    print("An Error Occured. Deletion of account unsuccesful")
                } else {
                    //Account Deleted succesfully
                    print("Account deleted succesfully")
                }
                
            }
            
        }
        
    }
    
    
    
}

