//
//  photoLinkCell.swift
//  Magnet
//
//  Created by Natalie Evoniuk on 4/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
class photoLinkCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    var urllink = ""

    static let identifier = "photoLinkCell"
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

                    self.photo.image = imgg
                }
            }
        }
    }
    
    func configCell(img: String) {
        self.urllink = img
        self.uploadImg() {
            (imgg, error) in
            self.photo.image = imgg
        }
    }
}
