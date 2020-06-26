//
//  AddViewController.swift
//  MyNotes
//
//  Created by Pace Wisdom on 23/06/20.
//  Copyright © 2020 Pace Wisdom. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var titleField: UITextField!
    
    @IBOutlet var decriptionField: UITextView!

    @IBOutlet weak var attachment: UIImageView!
    
    @IBOutlet weak var attachmentHeight: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ConfigureUI()
        

        // Do any additional setup after loading the view.
    }
    
    func ConfigureUI() {
        
        self.attachment.layer.cornerRadius = 10
        
        decriptionField.layer.borderWidth = 1
        
        decriptionField.layer.cornerRadius = 10
        
        decriptionField.layer.borderColor = UIColor.darkGray.cgColor
                
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        decriptionField.text = "Enter body here...."
        
        self.attachmentHeight.constant = 0
                
        decriptionField.delegate = self
    }
        
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter body here...." {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter body here...."
        }
    }
    
    @IBAction func didSaveButton(_ sender: UIButton) {
        
        if decriptionField.text == "Enter body here...." {
            decriptionField.text = ""
        }
        
        if let titleText = titleField.text,!titleText.isEmpty,
            let descriptionText = decriptionField.text,!descriptionText.isEmpty{
            
            CoreDataManager.shared.SaveAttachment(title: titleText, body:descriptionText, attachment: (attachment.image?.pngData()), isSelected: false)

        }else{
            
            decriptionField.text = "Enter body here...."
            
            Alert(Message: "Please Enter Note")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attachmentBtn(_ sender: UIButton) {
        
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBtnActn(_ sender: UIButton) {
        
        self.titleField.text = ""
        self.decriptionField.text = "Enter body here...."
        
    }
   
    func Alert (Message: String){
          
        let alert = UIAlertController(title: "Alert", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
          
          
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.originalImage]{
            
            self.attachmentHeight.constant = 150

            self.attachment.image = (img as! UIImage).upOrientationImage()
        }
     
        self.dismiss(animated: true, completion: nil)
    }
    
}
