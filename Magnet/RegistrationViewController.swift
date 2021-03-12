//
//  RegistrationViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 2/28/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class RegistrationViewController: UIViewController {
    @IBOutlet weak var selectsportbttn: UIButton!
    @IBOutlet weak var tbleview: UITableView!
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var lastnamefield: UITextField!
    @IBOutlet weak var agefield: UITextField!
    var refr: DatabaseReference!
    let sportsList = ["Soccer", "Tennis", "BasketBall", "Running"]
    var email = String()
    var password = String()
    var firstName: String = ""
    var lastName: String = ""
    var age: String = ""
    override func viewDidLoad() {
        refr = Database.database().reference()
        super.viewDidLoad()
        tbleview.isHidden = true
        tbleview.delegate = self
        tbleview.dataSource = self
        // Do any additional setup after loading the view.
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
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
    /**
   override init () {
      super.init()
   }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    */
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBAction func RegisterAction(_ sender: Any) {
        let sportcell = selectsportbttn.titleLabel?.text
        self.firstName = namefield.text!
        self.lastName = lastnamefield.text!
        self.age = agefield.text!
        if (!firstName.isEqual("") && !lastName.isEqual("") && !age.isEqual("") && !email.isEqual("") && !password.isEqual("")) {
            guard let key = refr.child("User").childByAutoId().key
            else {return}
            self.refr.child("User").child(key).setValue(["Email": email, "Password": password,"First Name": firstName, "Last Name": lastName, "Age": age, "Interests": sportcell])
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

