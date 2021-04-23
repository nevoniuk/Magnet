//
//  SignInViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/1/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    var ref: DatabaseReference!
    //let userkey = SignInViewController()
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwfield: UITextField!
    @IBOutlet var googleSign: GIDSignInButton!
    var email = ""
    var password = ""
    var signIn = false
    var userUid = ""
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
        if(GIDSignIn.sharedInstance()?.currentUser != nil){
            self.goToFeed()
        }
        if ((emailfield.text != "") && (passwfield.text != "")) {
            self.email = emailfield.text!
            self.password = passwfield.text!
            print(self.email)
            print(self.password)
            self.signIn = true
            Auth.auth().signIn(withEmail: self.email, password: self.password)
            
            if(Auth.auth().currentUser != nil){
                self.userUid = Auth.auth().currentUser!.uid
                self.goToFeed()
            }
            else {
               
            }
 
        }
    }
}
