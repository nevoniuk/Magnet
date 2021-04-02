//
//  PhotoCell.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 4/1/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
class PhotoCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoButton: UIButton!
    //var imagePicker : UIImagePickerController!
    var imageSelected = false
    var urllink: String!
    var userUid: String!
    var photoCount: Int!
    var buttontap : (()->())?
    var superViewController: PersonalPageViewController?
    static let identifier = "PhotoCell"
    //1. make button function in the cell
    //2 make sure button appears for every other cell
    //3. delete function
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
    }

    func commonInit() {
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
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
                    //print(self.post.postImage)
                    self.photo.image = imgg
                }
            }
        }
    }
    
    func configPhoto(img: String) {
        self.urllink = img
        self.uploadImg() {
            (imgg, error) in
            self.photo.image = imgg
        }
    }
    @objc func animateIn() {
        addSubview(photo)
        photo.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.photo.alpha = 1
            self.photo.transform = CGAffineTransform.identity
        }
    }
   
    @IBAction func selectedImagePicker(_sender: Any) {
        self.imageSelected = true
        self.isSelected = true
        buttontap?()
        print("HERE")
        /**
        self.uploadData() {
            (url, error) in
            if let url = url {
                self.urllink = url.absoluteString
                print("URL")
                print(self.urllink)
                //self.keychain()
                let ref = Database.database().reference()
                ref.child("User").child(self.userUid).child("Photos").setValue(["\(self.photoCount)": self.urllink])
                self.photoCount = self.photoCount + 1
            }
        }
 */
        //present(imagePicker, animated: true)

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //download image and write it to storage
    //
    func uploadData(completion: @escaping (URL?, Error?) -> ()) {
            guard let img = photo.image, imageSelected == true
        else {
            print("image must be selected")
            return
            }
        guard let imageDat = img.jpegData(compressionQuality: 0.2) else {
            print("image not converted")
            return
        }
        let key = Auth.auth().currentUser?.uid
        self.userUid = key
        let imageName = UUID().uuidString
        let storeR = Storage.storage().reference()
        let imageRef = storeR.child(key!).child(imageName)
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
    
}
