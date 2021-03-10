//
//  SignInViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/1/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class SignInViewController: UIViewController {
    var ref: DatabaseReference!
    let userkey = SignInViewController()
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwfield: UITextField!
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
    }
    @IBAction func clicked(_ sender: Any) {
        var email = emailfield.text!
        var password = passwfield.text!
        var Found = false
        if ((emailfield.text != "") && (passwfield.text != "")) {
            ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
                for users in snapshot.children.allObjects as! [DataSnapshot] { //users
                    var emailcheck = users.childSnapshot(forPath: "Email").value as! String
                    if (emailcheck.elementsEqual(email)) {
                        var passwordcheck = users.childSnapshot(forPath: "Password").value as! String
                        if (passwordcheck.elementsEqual(password)) {
                            Found = true;
                            let userkey = users.key
                        }
                    }
                } //end snapshot loop
            })
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
