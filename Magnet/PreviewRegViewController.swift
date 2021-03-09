//
//  PreviewRegViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/1/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class PreviewRegViewController: UIViewController {

    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //var email = emailtext.text
    //var password = passwordtext.text
    //shouldn't be able to register if data already exists!
    @IBAction func reg1option(_ sender: Any) {
        var emailvar = emailtext.text!
        var passwordvar = passwordtext.text!
        if (!emailvar.isEqual("") && !passwordvar.isEqual("")) {
         //   ref.observe(.value(emailvar)) { snapshot in
          //      for listchild in snapshot.children {
           //         if ((listchild.value(forKey: "User/UserId/Email") as? emailvar)) {
                        
            //        }
             //   }
           // }
            guard let key = ref.child("User").childByAutoId().key
            else {return}
            self.ref.child("User").child(key).child("UserId").setValue(["Email": emailvar, "Password": passwordvar])
            //let post = ["User/UserId/Email": emailvar, "User/UserId/Password": passwordvar]
            //let childUpdates = ["/User/\(key)": post]
            // "/user-posts/\(key)/": post
            //ref.updateChildValues(childUpdates)

            //self.ref.child("User").
        }
    }
    @IBAction func reg2option(_ sender: Any) {
        var emailvar = emailtext.text!
        var passwordvar = passwordtext.text!
        if (!emailvar.isEqual("") && !passwordvar.isEqual("")) {
            guard let key = ref.child("User").childByAutoId().key
            else {return}
            self.ref.child("User").setValue(["UserId": key])
            self.ref.child("User").child(key).child("UserId").setValue(["Email": emailvar, "Password": passwordvar])
        }
    }
}
