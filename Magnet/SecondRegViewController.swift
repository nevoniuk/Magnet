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
    var email = String()
    var password = String()
    var firstName: String = ""
    var lastName: String = ""
    var age: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        reference = Database.database().reference()
        tbleview.isHidden = true
        tbleview.delegate = self
        tbleview.dataSource = self
        print(email)
        print(password)
    }
    
    @IBAction func clickedselect(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.tbleview.isHidden = false
        }
    }
    @IBAction func clickedadd(_ sender: Any) {
        //add text already in text fields to database
        //reset text fields to allow the user to add another member
        let sportcell = selectsportbutton.titleLabel?.text
        self.firstName = namefield.text!
        self.lastName = lastnamefield.text!
        self.age = agefield.text!
        if (!firstName.isEqual("") && !lastName.isEqual("") && !age.isEqual("") && !email.isEqual("") && !password.isEqual("")) {
            guard let key = reference.child("User").childByAutoId().key
            else {return}
            self.reference.child("User").child(key).setValue(["Email": email, "Password": password,"First Name": firstName, "Last Name": lastName, "Age": age, "Interests": sportcell])
        }
        //reset the text fields to add another user
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
