//
//  RegistrationViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 2/28/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper
import FirebaseAuth
class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var selectsportbttn: UIButton!
    @IBOutlet weak var tbleview: UITableView!
    @IBOutlet weak var namefield: UITextField!
    @IBOutlet weak var lastnamefield: UITextField!
    @IBOutlet weak var agefield: UITextField!
    @IBOutlet weak var createActivity: UITextField!
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var photo: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    var userUid = ""
    let sportsList = ["Soccer", "Tennis", "BasketBall", "Running", "Online Activity", "Other"]
    var email = String()
    var password = String()
    var firstName: String = ""
    var lastName: String = ""
    var age: String = ""
    var imagePicker : UIImagePickerController!
    var imageSelected = false
    var urllink: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbleview.isHidden = true
        createActivity.isHidden = true
        createActivity.isEnabled = false
        tbleview.delegate = self
        urllink = String()
        tbleview.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    func goToFeedVC() {
        performSegue(withIdentifier: "regSegue", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            
        }
    }
    func keychain() {
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
       guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            print("image wasn't selected")
            return
       }
        userImagePicker.image = image
        print(userImagePicker.image)
        imageSelected = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedImagePicker(_sender: Any) {
        //imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
        if (segue.identifier == "regSegue") {
            var matchingViewController = segue.destination as! MatchingViewController
            matchingViewController.userUid = self.userUid
            matchingViewController.signIn = false
        }
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
    
    
    func uploadData(completion: @escaping (URL?, Error?) -> ()) {
            guard let img = userImagePicker.image, imageSelected == true
        else {
            print("image must be selected")
            return
            }
        guard let imageDat = img.jpegData(compressionQuality: 0.2) else {
            print("image not converted")
            return
        }
        let imageName = UUID().uuidString
        let storeR = Storage.storage().reference()
        let imageRef = storeR.child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(imageDat, metadata: metaData) { (metadata, error) in
            if let error = error {
                print(error)
                return
            }
            guard let metadata = metadata else {
                return
            }
            var downloadURL = URL(string: "https://firebase.com/")
            imageRef.downloadURL{ (url, err) in
                completion(url?.absoluteURL, err)
     
                if let url = url {
                    downloadURL = url.absoluteURL
                }
            }
        }
    }
    
    func createAUser(completion: @escaping (Firebase.User?, Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password:
                                password) { (user, error) in
            completion(user?.user, error)
            if let firebaseUser = user?.user {
                self.userUid = firebaseUser.uid
            }
        }
    }
    //func logOutAllUsers()
    @IBAction func RegisterAction(_ sender: Any) {
        let sportcell = selectsportbttn.titleLabel?.text
        var sport = sportcell as! String
        if (sport.elementsEqual("Other")) {
            sport = createActivity.text!
        }
        self.firstName = namefield.text!
        self.lastName = lastnamefield.text!
        self.age = agefield.text!
        var createdUser: Bool = false
        if (!firstName.isEqual("") && !lastName.isEqual("") && !age.isEqual("") && !email.isEqual("") && !password.isEqual("")) {
            createdUser = true
            self.createAUser() {
                (user, error) in
                if let firebaseUser = user {
                    print(firebaseUser.uid)
                }
            }
            print("User uid")
            print(self.userUid)
            self.uploadData() {
                (url, error) in
                if let url = url {
                    self.urllink = url.absoluteString
                    print("URL")
                    print(self.urllink)
                    self.keychain()
                    let ref = Database.database().reference()
                    ref.child("User").child(self.userUid).setValue(["Email": self.email, "Password": self.password,"FirstName": self.firstName, "LastName": self.lastName, "Age": self.age, "Interests": sport, "UserImage": self.urllink])
                    self.goToFeedVC()
                }
            }
        }
        //dismiss(animated: true, completion: nil)
    }
    
    
}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sportsList[indexPath.row]
        if (cell.textLabel?.text?.elementsEqual("Other") != nil) {
            createActivity.isHidden = false
            createActivity.isEnabled = true
        }
        else {
            createActivity.isHidden = true
            createActivity.isEnabled = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectsportbttn.setTitle((sportsList[indexPath.row]), for: .normal)
        animate(toggle: false)
    }
    
    
}

