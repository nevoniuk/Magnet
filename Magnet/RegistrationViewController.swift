//
//  RegistrationViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 2/28/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class RegistrationViewController: PreviewRegViewController {
    @IBOutlet weak var selectsportbttn: UIButton!
    @IBOutlet weak var tbleview: UITableView!
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var lastnamefield: UITextField!
    @IBOutlet weak var agefield: UITextField!
    var refr: DatabaseReference!
    let sportsList = ["Soccer", "Tennis", "BasketBall", "Running"]
    var firstName = ""
    var lastName = ""
    var age = ""
    override func viewDidLoad() {
        refr = Database.database().reference()
        super.viewDidLoad()
        tbleview.isHidden = true
        tbleview.delegate = self
        tbleview.dataSource = self
        firstName = namefield.text!
        lastName = lastnamefield.text!
        age = agefield.text!
        // Do any additional setup after loading the view.
    }
    @IBAction func clickedbutton1(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.tbleview.isHidden = false
        }
    }
    func animate(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.tbleview.isHidden = false
            }
        }
        else {
            UIView.animate(withDuration: 0.3) {
                self.tbleview.isHidden = true
            }
        }
    }
    //init (userkey: String) {
   //     super.init(userkey: String)
   // }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    @IBOutlet weak var RegisterButton: UIButton!
    @IBAction func RegisterAction(_ sender: Any) {
       // let key = (object1)!.getKey()
        //if (object1?.getKey() != nil) {
       //     key = object1!.getKey()
       // }
        let key = getKey() //PROBLEM: key returns as empty
        var sportcell = selectsportbttn.titleLabel?.text
        if (firstName != "" && lastName != "" && age != "") {
            self.refr.child("User").child(key).setValue(["First Name": firstName, "Last Name": lastName, "Age": age])
        }
        if (sportcell != "") {
            self.refr.child("User").child(key).setValue(["Interests":sportcell])
        }
    }
}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sportsList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectsportbttn.setTitle((sportsList[indexPath.row]), for: .normal)
        animate(toggle: false)
    }
    
}

