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
    var userkey: String = ""
    init(userkey: String) {
        self.userkey = userkey
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    //shouldn't be able to register if email already exists!
    @IBAction func reg1option(_ sender: Any) {
        var emailvar = emailtext.text!
        var passwordvar = passwordtext.text!
        if (!emailvar.isEqual("") && !passwordvar.isEqual("")) {
            var found = false
            ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot)
                for users in snapshot.children.allObjects as! [DataSnapshot] { //users
                    var emailcheck = users.childSnapshot(forPath: "Email").value as! String
                    if (emailcheck.elementsEqual(emailvar)) {
                        found = true;
                    }
                }
            })
            if (found == false) {
                guard let key = ref.child("User").childByAutoId().key
                else {return}
                self.ref.child("User").child(key).setValue(["Email": emailvar, "Password": passwordvar])
                setKey(tempkey: key) //we need to allow other view controllers to access this key so we know what user were looking at
            }
        }
    }
    @IBAction func reg2option(_ sender: Any) {
        var emailvar = emailtext.text!
        var passwordvar = passwordtext.text!
        if (!emailvar.isEqual("") && !passwordvar.isEqual("")) {
            var found = false
            ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot)
                for users in snapshot.children.allObjects as! [DataSnapshot] { //users
                    var emailcheck = users.childSnapshot(forPath: "Email").value as! String
                    if (emailcheck.elementsEqual(emailvar)) {
                        found = true;
                    }
                }
            })
            if (found == false) {
                guard let key = ref.child("User").childByAutoId().key//KEY
                else {return}
                self.ref.child("User").child(key).setValue(["Email": emailvar, "Password": passwordvar])
                    setKey(tempkey: key)
                //we need to allow other view controllers to access this key so we know what user were looking at
            }
        }
    }
    func getKey() -> String {
        print("KEY")
        print(userkey)
        return userkey
    }
    func setKey(tempkey: String) -> String {
        self.userkey = tempkey
        return userkey
    }
}
//print(users.childSnapshot(forPath: "Email"))
//print(users.key) //works!
//var tempemail = self.ref.child("User").child(users.key).child("Email").getData {(error, snapshot) in
//    if let error = error {
     //   print("error getting data")
   // }
// }
//ref.observe(DataSnapshot.value, with: { snapshot in
//      for listchild in snapshot.children {
//         if ((listchild.value(forKey: "User/UserId/Email") as? emailvar)) {
            
//        }
 //   }
// }
