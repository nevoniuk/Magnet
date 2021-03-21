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
        
        var confirmDelete = 0
        let alert = UIAlertController(title: "Confirm Account Deletion", message: "Are you sure you want to delete your account? This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("DELETE ACCOUNT", comment: "Default action"), style: .destructive, handler: {_ in NSLog("The \"DELETE\" alert occured.")
            confirmDelete = 1
            NSLog("%d", confirmDelete)
            
            if confirmDelete == 1{
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
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: {_ in NSLog("The \"CANCEL\" alert occured.")}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

