//
//  CustomizeViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 4/9/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class CustomizeViewController: UIViewController {

    @IBOutlet weak var switchm: UISwitch!
    @IBOutlet weak var switchf: UISwitch!
    @IBOutlet weak var switchb: UISwitch!
    @IBOutlet weak var registerb: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var endslider: UISlider!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    var male = false
    var female = false
    var both = false
    var userUid = String()
    var signIn = Bool()
    var numUsers = Int()
    var group = Bool()
    override func viewDidLoad() {
        let x = Int(round(slider.value))
        let y = Int(round(endslider.value))
        self.label1.text = "\(x)"
        self.label2.text = "\(y)"
        self.switchm.isOn = false
        self.switchf.isOn = false
        self.switchb.isOn = false
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if (segue.identifier == "customizeSegue") {
            var matching = segue.destination as! MatchingViewController
            matching.userUid = self.userUid
            matching.signIn = false
        }
        if (segue.identifier == "groupsegue") {
            var vc = segue.destination as! GroupRegViewController
            vc.userUid = self.userUid
            vc.signIn = false
            vc.numUsers = self.numUsers
        }
    }
    
    func goToFeedVC() {
        performSegue(withIdentifier: "customizeSegue", sender: self)
    }
    func goToGroupVC() {
        performSegue(withIdentifier: "groupsegue", sender: self)
    }
    @IBAction func slider1changed(_ sender: UISlider) {
        let x2 = Int(round(slider.value))
        print("\(x2)")
        self.label1.text = "\(x2)"
    }
    
    @IBAction func switched1(_ sender: UISwitch) {
        if (self.switchm.isOn) {
            print("on")
        }
        else {print("off")}
    }
    
    @IBAction func switched3(_ sender: UISwitch) {
        if (self.switchb.isOn) {
            print("on")
        }
        else {print("off")}
    }
    
    @IBAction func switched2(_ sender: UISwitch) {
        if (self.switchf.isOn) {
            print("on")
        }
        else {print("off")}
    }
    
    @IBAction func slider2changed(_ sender: UISlider) {
        let y2 = Int(round(endslider.value))
        print("\(y2)")
        self.label2.text = "\(y2)"
    }
    
    @IBAction func clicked(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
            self.userUid = Auth.auth().currentUser!.uid
        }
        else {
           
        }
        if switchm.isOn {
            self.male = true
        }
        else if switchf.isOn {
            self.female = true
        }
        else if  switchb.isOn {
            self.both = true
        }
        if (male) {
            Database.database().reference().child("User").child(self.userUid).child("Gender Preference").setValue(["gender": "male"])
        }
        else if (female) {
            Database.database().reference().child("User").child(self.userUid).child("Gender Preference").setValue(["gender": "female"])
        }
        else if (both) {
            Database.database().reference().child("User").child(self.userUid).child("Gender Preference").setValue(["gender": "none"])
        }
        
        Database.database().reference().child("User").child(self.userUid).child("Age Preference").setValue(["begin": label1.text, "end": label2.text])
        if (self.group) {
            goToGroupVC()
        }
        else {
            goToFeedVC()
        }
        
    }
}
