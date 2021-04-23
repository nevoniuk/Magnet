//
//  PersonalPageViewController.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 3/30/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class PersonalPageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var sharingLabel: UILabel!
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var NameField: UILabel!
    @IBOutlet weak var Miles: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var location: UISlider!
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet weak var EditBio: UIButton!
    @IBOutlet weak var PressEditBio: UIButton!
    @IBOutlet weak var PhotoPage: UICollectionView!
    var imagePicker: UIImagePickerController!
    var userUid = String()
    var name = String()
    var profileLink = String()
    var photoSharing = true
    var upload = true
    var cellNum = 0
    var urllink: String!
    var imageList = [String]()
    var photoCount = 0
    var signIn = Bool()
    var photocell: PhotoCell?
    var counter = 0
    var image = ""
    //when view loads check if sign in
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoPage.delegate = self
        PhotoPage.dataSource = self
        PhotoPage.isHidden = false
        Bio.isEditable = true
        self.imageList.reserveCapacity(25)
        switch1.isOn = false
        Bio.isUserInteractionEnabled = true
        NameField.text = name
        self.urllink = profileLink
        
        //Database.database().reference().child("User").child(self.userUid).child("PhotoSharing").setValue(["val": "false"])
        self.sharingLabel.text = "Photo Sharing Off"
        self.uploadProfile() {
            (imgg, error) in
            self.profileImage.image = imgg
        }

        var ref = Database.database().reference()

        //gets bio text
        ref.child("User").child(self.userUid).child("Bio").observeSingleEvent(of: .value, with: {
            snapshot in
                let value = snapshot.value as? Dictionary<String, AnyObject>
            if let bioText = value?["text"] as? String {
                self.Bio.text = bioText as! String
            }
        })
        
        ref.child("User").child(self.userUid).child("Photos").observeSingleEvent(of: .value, with: { snapshot in
            for users in snapshot.children.allObjects as! [DataSnapshot] {
                let value = users.childSnapshot(forPath: "link").value as! String
                print(value)
                self.imageList.insert(value, at: self.counter)
                self.counter = self.counter + 1
                self.PhotoPage.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
  
        if (segue.identifier == "back") {
            var vc = segue.destination as! MatchingViewController
            vc.userUid = self.userUid
            vc.signIn = self.signIn
        }
        if (segue.identifier == "caption") {
            var vc = segue.destination as! CaptionViewController
            vc.userUid = self.userUid
            vc.imagelink = self.image
            vc.cellNumber = self.cellNum
            vc.profileLink = self.profileLink
            vc.name = self.name
        }
    }
    func goBackToFeed() {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    //for instant upload only
    func uploadImg(completion: @escaping (UIImage?, Error?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: self.urllink)
        storageRef.getData(maxSize: 100 * 1024) { (data, error) -> Void in
          // Create a UIImage, add it to the array
            if let error = error {
                print(error)
                return
            }
            if let imgData = data {
                if let imgg = UIImage(data: imgData) {
                    completion(imgg, error)
                    print(self.photocell?.photo)
                    self.photocell?.photo.image = imgg
                }
            }
        }
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        if switch1.isOn {
            Database.database().reference().child("User").child(self.userUid).child("PhotoSharing").setValue(["val": "true"])
            self.sharingLabel.text = "Photo Sharing On"
        }
        else {
            Database.database().reference().child("User").child(self.userUid).child("PhotoSharing").setValue(["val": "false"])
            self.sharingLabel.text = "Photo Sharing Off"
        }
    }
    
    
    func uploadProfile(completion: @escaping (UIImage?, Error?) -> ()) {
        let storageRef = Storage.storage().reference(forURL: self.urllink)
        storageRef.getData(maxSize: 100 * 1024) { (data, error) -> Void in
          // Create a UIImage, add it to the array
            if let error = error {
                print(error)
                return
            }
            if let imgData = data {
                if let imgg = UIImage(data: imgData) {
                    completion(imgg, error)
                    self.profileImage.image = imgg
                }
            }
        }
    }
    
    func showImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //picker.dismiss(animated: true, completion: nil)
        print("in picker controller")
        var photo: UIImage?
        let image1 = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        photo = image1
        print(image1)
        print(self.photoCount)
        dismiss(animated: true, completion: {
            if let selectedImage = photo {
                self.photocell?.photo.image = selectedImage

                self.uploadData() {
                    (url, error) in
                    if let url = url {
                        self.urllink = url.absoluteString
                        //self.keychain()
                        let ref = Database.database().reference()

                        ref.child("User").child(self.userUid).child("Photos").child("\(self.photoCount)").setValue(["link": self.urllink])
                        self.imageList.insert(self.urllink, at:  self.photoCount)
                        self.photoCount = self.photoCount + 1
                    }
                }
            }
        })
    }

    func uploadData(completion: @escaping (URL?, Error?) -> ()) {
        guard let img = self.photocell?.photo.image
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
        let imageRef = storeR.child(self.userUid).child(imageName)
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
    func goToCaptionPage() {
        performSegue(withIdentifier: "caption", sender: self)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("hereeee")
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ((self.imageList.count > 0) && (indexPath.item < self.imageList.count)) {
            self.image = self.imageList[indexPath.item]
        }
        if let photocell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath as IndexPath) as? PhotoCell {
            var cond = 0
            photocell.buttontap = {
                () in
                print("edit tapped in cell")
                self.photocell = photocell
                print("upload on cell # \(indexPath.item)")
                self.showImagePicker()
                cond = 1
                print("done")
                //self.PhotoPage.reloadData()
            }
            photocell.caption = {
                () in
                if (!self.image.elementsEqual("")) {
                    self.cellNum = indexPath.item
                    
                }
                
            }
            //only on upload
            if (cond == 0 && (indexPath.item < self.imageList.count) && self.upload) {
                print("buttontap is nil")
                print(self.image)
                print("upload on cell # \(indexPath.item)")
                photocell.configPhoto(img: self.image, key: self.userUid)
                self.photoCount = self.photoCount + 1
                if (self.imageList.count == self.photoCount) {
                    print("done uploading")
                    self.upload = false
                }
            }
            else if (upload == false) {
                photocell.configPhoto(img: "", key: "")
            }
            return photocell
        }
        //photocell.photoButton.addTarget(self, action: #selector(selected), for: .touchUpInside)
        print("created new photo cell")
        return PhotoCell()
    }
   
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineitemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
 
    @IBAction func pressedEdit(_ sender: Any) {
        var text = self.Bio.text!
        Database.database().reference().child("User").child(self.userUid).child("Bio").setValue(["text": text])
    }
}

