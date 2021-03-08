//
//  RegistrationViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 2/28/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var selectsportbttn: UIButton!
    @IBOutlet weak var tbleview: UITableView!
    
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var lastnamefield: UITextField!
    @IBOutlet weak var agefield: UITextField!
    
    let sportsList = ["Soccer", "Tennis", "BasketBall", "Running"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tbleview.isHidden = true
        tbleview.delegate = self
        tbleview.dataSource = self
        var firstName = namefield.text
        var lastName = lastnamefield.text
        var age = agefield.text
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
