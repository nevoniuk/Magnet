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
    //let userkey = SignInViewController()
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwfield: UITextField!
    var email = ""
    var password = ""
    var signIn = false
    var userUid = ""
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if (segue.identifier == "signInSegue") {
            var matchingViewController = segue.destination as! MatchingViewController
            matchingViewController.signIn = self.signIn
            matchingViewController.userUid = self.userUid
        }
    }
    func goToFeed() {
        performSegue(withIdentifier: "signInSegue", sender: self)
    }
    @IBAction func clicked(_ sender: Any) {
        if ((emailfield.text != "") && (passwfield.text != "")) {
            self.email = emailfield.text!
            self.password = passwfield.text!
            self.signIn = true
            ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
                for users in snapshot.children.allObjects as! [DataSnapshot] { //users
                    var emailcheck = users.childSnapshot(forPath: "Email").value as! String
                    if (emailcheck.elementsEqual(self.email)) {
                        var passwordcheck = users.childSnapshot(forPath: "Password").value as! String
                        if (passwordcheck.elementsEqual(self.password)) {
                            let userkey = users.key
                            Auth.auth().signIn(withEmail: self.email, password: self.password)
                            self.signIn = true
                            self.userUid = Auth.auth().currentUser!.uid
                            print("USERRR")
                            print(self.userUid)
                            self.goToFeed()
                        }
                    }
                } //end snapshot loop
            }) 
            
        }
    }
}
