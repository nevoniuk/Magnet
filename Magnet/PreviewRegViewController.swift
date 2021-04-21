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
    @IBOutlet weak var switch18: UISwitch!
    var minAgeMet = true
    var ref: DatabaseReference!
    var emailvar: String =  ""
    var passwordvar: String = ""
    override func viewDidLoad() {
        switch18.isOn = true
        ref = Database.database().reference()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    
    @IBAction func switchClicked(_ sender: Any) {
        if (switch18.isOn) {
            self.minAgeMet = true
            button1.isEnabled = true
            button2.isEnabled = true
        }
        else {
            self.minAgeMet = false
            button1.isEnabled = false
            button2.isEnabled = false
        }
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
        if (!emailvar.isEqual("") && !passwordvar.isEqual("") && minAgeMet) {
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
        if (!emailvar.isEqual("") && !passwordvar.isEqual("") && minAgeMet) {
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
}

