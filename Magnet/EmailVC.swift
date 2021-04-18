//
//  EmailVC.swift
//  Magnet
//
//  Created by Esteban Richey on 3/28/21.
//

import Foundation
import MessageUI


class EmailVC: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        
    let myPickerController = UIImagePickerController()
    let mailPicker = MFMailComposeViewController()

    
    @IBAction func attach(_ sender: Any) {
        //SHOW UIIMAGEPICKER
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = true
        myPickerController.mediaTypes = ["public.image"]
        self.present(myPickerController, animated: true, completion: nil)
        
        //END SHOW UIIMAGEPICKER
    }
    @IBOutlet weak var Attach: UIButton!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageJPEG = image.jpegData(compressionQuality: 1.0)
        mailPicker.addAttachmentData(imageJPEG!, mimeType: "image/jpeg", fileName: "report_attachment")
    }
    
    
    @IBAction func sendMail(_ sender: Any) {
        mailPicker.mailComposeDelegate = self
        mailPicker.setToRecipients(["magnet_app@outlook.com"])
        if let subjectText = Subject.text {
            mailPicker.setSubject(subjectText)
        }
        
        mailPicker.setMessageBody(body.text, isHTML: true)
        if MFMailComposeViewController.canSendMail() {
            present(mailPicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Email not set up", message: "Email is not set up on this device. Are you using a Simulator rather than real hardware?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK Action"), style: .cancel, handler: {_ in NSLog("The \"CANCEL\" alert occured.")}))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var Subject: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Subject.delegate = self
        body.delegate = self
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        body.text = textView.text
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
        
    }
    
    
}
