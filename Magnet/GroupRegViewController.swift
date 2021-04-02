//
//  GroupRegViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/28/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import FirebaseAuth

class GroupRegViewController: UIViewController {
    var numUsers = Int()
    var userUid = String()
    var FirstName = ""
    var LastName = ""
    var Age = ""
    var counter = 0;
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var userIndex: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var continueBttn: UIButton!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        continueBttn.isEnabled = false
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if (segue.identifier == "feedGroupSegue") {
            var feedViewController = segue.destination as! MatchingViewController
            feedViewController.userUid = self.userUid
            feedViewController.signIn = false
            //feedViewController.numUsers = self.numusers
        }
    }
    func goToFeedVC() {
        performSegue(withIdentifier: "feedGroupSegue", sender: self)
    }
    @IBAction func addMember(_ sender: Any) {
        if (fname.text != "" && lname.text != "" && age.text != "" && self.counter != self.numUsers) {
            self.FirstName = fname.text!
            self.LastName = lname.text!
            self.Age = age.text!
            if let text = userIndex.text, let value = Int(text) {
                var userID = Auth.auth().currentUser?.uid
                print(userID!)
                guard let key = self.ref.child("User").child(userUid).child("GroupMembers").childByAutoId().key
                else {
                    return
                }
                self.ref.child("User").child(self.userUid).child("GroupMembers").child(key).setValue(["FirstName": self.FirstName, "LastName": self.LastName, "Age": self.Age])
             
            }
            if (self.counter != self.numUsers) {
                self.counter += 1
                let newcounter = self.counter as NSNumber
                let newValue : String = newcounter.stringValue
                self.userIndex.text = newValue
                fname.text = ""
                lname.text = ""
                age.text = ""
            }
        }
        if (self.counter == self.numUsers) {
            continueBttn.isEnabled = true
            addButton.isEnabled = false
        }
    }
    
    @IBAction func goToFeed(_ sender: Any) {
        goToFeedVC()
    }
    
}
