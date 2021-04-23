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
    //@IBOutlet weak var caption: UITextField!
    //@IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var captionButton: UIButton!
    
    //var imagePicker : UIImagePickerController!
    var imageSelected = false
    var urllink: String!
    var userUid: String!
    var photoCount: Int!
    var buttontap : (()->())?
    var caption : (()->())?
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
      //  self.insertSubview(self.captionButton, belowSubview: self.photo)
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
    
    func configPhoto(img: String, key: String) -> () {
        self.urllink = img
        if (self.urllink == "") {
            return
        }
        print("link for cell \(self.urllink)")
        self.userUid = key
        self.uploadImg() {
            (imgg, error) in
            self.photo.image = imgg
        }
        print("image downloaded")
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
    }
    
    @IBAction func captionTap(_ sender: Any) {
        caption?()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //download image and write it to storage
    //
    
    
}
