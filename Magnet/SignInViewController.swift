//
//  SignInViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/1/21.
//

import UIKit

class SignInViewController: UIViewController {
    //var ref: DatabaseReference!
    //ref = Database.database().reference()
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailfield: UITextField!
    @IBOutlet weak var passwfield: UITextField!
    @IBAction func clicked(_ sender: Any) {
        let email = emailfield.text
        let password = passwfield.text
        //Bool Found = false;
        if ((emailfield.text != "") && (passwfield.text != "")) {
            //1.check if there is matching data in the google firebase
            //2.check email first
            //firebase.database.ref("rules/User").on('value', function(snap)) {
              //  snap.forEach(function(childNodes)) {
                    
                //}
            //}
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
