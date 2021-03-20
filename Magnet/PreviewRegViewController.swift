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
    var emailvar: String =  ""
    var passwordvar: String = ""
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    /**
    var userkey: String {
        func willSet(tempkey) {
            getKey() = tempkey
            return userkey
        }
        func getKey() -> String {
            print("KEY")
            print(userkey)
            return userkey
        }
        
    }
    init(userkey: String) {
        self.userkey = userkey
        super.init(nibName: nil, bundle: nil)
    }
 */
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if (segue.identifier == "segue") {
            var registrationViewController = segue.destination as! RegistrationViewController
            registrationViewController.email = emailtext.text!
            registrationViewController.password = passwordtext.text!
            
        }
        if (segue.identifier == "segueTwo") {
            var secregistrationViewController = segue.destination as! SecondRegViewController
            secregistrationViewController.email = emailtext.text!
            secregistrationViewController.password = passwordtext.text!
        }
    }
    //shouldn't be able to register if email already exists!
    @IBAction func reg1option(_ sender: Any) {
        self.emailvar = emailtext.text!
        self.passwordvar = passwordtext.text!
        if (!emailvar.isEqual("") && !passwordvar.isEqual("")) {
            var found = false
            ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
                //print(snapshot)
                for users in snapshot.children.allObjects as! [DataSnapshot] { //users
                    var emailcheck = users.childSnapshot(forPath: "Email").value as! String
                    if (emailcheck.elementsEqual(self.emailvar)) {
                        found = true;
                    }
                }
            })//this
            
            
            if (found == false) {
                performSegue(withIdentifier: "segue", sender: self)
            }
        }
    }
    @IBAction func reg2option(_ sender: Any) {
        self.emailvar = emailtext.text!
        self.passwordvar = passwordtext.text!
        if (!emailvar.isEqual("") && !passwordvar.isEqual("")) {
            var found = false
            ref.child("User").observeSingleEvent(of: .value, with: { snapshot in
                //print(snapshot)
                for users in snapshot.children.allObjects as! [DataSnapshot] { //users
                    var emailcheck = users.childSnapshot(forPath: "Email").value as! String
                    if (emailcheck.elementsEqual(self.emailvar)) {
                        found = true;
                    }
                }
            })
            if (found == false) {
                performSegue(withIdentifier: "segueTwo", sender: self)
            }
        }
    }
    /**
    func getKey() -> String {
        print("KEY")
        print(userkey)
        return userkey
    }
    func setKey(tempkey: String) -> String {
        self.userkey = tempkey
        return userkey
    }
 */
}

