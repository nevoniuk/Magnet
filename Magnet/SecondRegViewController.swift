//
//  SecondRegViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/1/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class SecondRegViewController: UIViewController {

    @IBOutlet weak var selectsportbutton: UIButton!
    @IBOutlet weak var tbleview: UITableView!
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var lastnamefield: UITextField!
    @IBOutlet weak var agefield: UITextField!
    @IBOutlet weak var addbutton: UIButton!
    var reference: DatabaseReference!
    let sportsList = ["Soccer", "Tennis", "BasketBall", "Running"]
    var firstName = ""
    var lastName = ""
    var age = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference()
        tbleview.isHidden = true
        tbleview.delegate = self
        tbleview.dataSource = self
        firstName = namefield.text!
        lastName = lastnamefield.text!
        age = agefield.text!
    }
    
    @IBAction func clickedselect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.tbleview.isHidden = false
        }
    }
    var key = ""
    @IBAction func clickedadd(_ sender: Any) {
        //add text already in text fields to database
        //reset text fields to allow the user to add another member
        var sportcell = selectsportbutton.titleLabel?.text
        if (firstName != "" && lastName != "" && age != "") {
            self.reference.child("User").child(key).setValue(["First Name": firstName, "Last Name": lastName, "Age": age])
        }
        if (sportcell != "") {
            self.reference.child("User").child(key).setValue(["Interests":sportcell])
        }
        namefield.text = ""
        lastnamefield.text = ""
        agefield.text = ""
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
}

extension SecondRegViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sportsList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectsportbutton.setTitle((sportsList[indexPath.row]), for: .normal)
        animate(toggle: false)
    }
}
