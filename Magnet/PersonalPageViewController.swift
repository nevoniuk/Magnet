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
    var urllink: String!
    var imageList = [String]()
    var photoCount = 0
    var signIn = Bool()
    var photocell: PhotoCell?
    //when view loads check if sign in
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoPage.delegate = self
        PhotoPage.dataSource = self
        PhotoPage.isHidden = false
        Bio.isEditable = true
        Bio.isUserInteractionEnabled = true
        NameField.text = name
        self.urllink = profileLink
        print(self.urllink)
        print(self.signIn)
        print(self.profileLink)
        self.uploadProfile() {
            (imgg, error) in
            self.profileImage.image = imgg
        }

        var ref = Database.database().reference()
        print("ID")
        print(self.userUid)
        //gets bio text
        ref.child("User").child(self.userUid).child("Bio").observeSingleEvent(of: .value, with: {
            snapshot in
                let value = snapshot.value as? Dictionary<String, AnyObject>
            if let bioText = value?["text"] as? String {
                self.Bio.text = bioText as! String
            }
        })
        
        ref.child("User").child(self.userUid).child("Photos").observeSingleEvent(of: .value, with: { snapshot in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                var counter = "0"
                for data in snapshot {
                        if (self.signIn) {
                            print("in loop")
                            if let dict = data.childSnapshot(forPath: "link") as? Dictionary<String, AnyObject> {
                                if let link = dict["/"] as? String {
                                    print("THIS IS THE URL LINK")
                                    print(dict)
                                    print(link)
                                    self.imageList.append(link)
                                }
                               // self.uploadImg() {
                                  //  (imgg, error) in
                                 //   self.photocell?.photo.image = imgg
                                //}
                            }
                            var a = Int(counter)!
                            a+=1
                            counter = String(a)
                            print("COUNTER")
                            print(counter)
                        }
                    
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue , sender: Any?) {
  
        if (segue.identifier == "back") {
            var vc = segue.destination as! MatchingViewController
            vc.userUid = self.userUid
            vc.signIn = self.signIn
        }
    }
    func goBackToFeed() {
        performSegue(withIdentifier: "back", sender: self)
    }
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
        var photo: UIImage?
        let image1 = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        photo = image1
        print("selected image?")
        
        dismiss(animated: true, completion: {
            if let selectedImage = photo {
                self.photocell?.photo.image = selectedImage
                self.uploadData() {
                    (url, error) in
                    if let url = url {
                        self.urllink = url.absoluteString
                        print("URL")
                        print(self.urllink)
                        //self.keychain()
                        let ref = Database.database().reference()
                        ref.child("User").child(self.userUid).child("Photos").child("\(self.photoCount)").setValue(["link": self.urllink])
                        self.photoCount = self.photoCount + 1
                    }
                }
            }
        })
    }

    func uploadData(completion: @escaping (URL?, Error?) -> ()) {
        print("int upload")
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photocell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        //photocell.photoButton.addTarget(self, action: #selector(selected), for: .touchUpInside)
        photocell.buttontap = {
            () in
            print("edit tapped in cell")
            self.photocell = photocell
            self.showImagePicker()
        }
        if (self.signIn && photocell.buttontap == nil) {
            let image = imageList[indexPath.item]
            photocell.configPhoto(img: image)
        }
        return photocell
    }
   
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineitemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
 
    @IBAction func pressedEdit(_ sender: Any) {
        var text = self.Bio.text!
        Database.database().reference().child("User").child(self.userUid).child("Bio").setValue(["text": text])
    }
}

