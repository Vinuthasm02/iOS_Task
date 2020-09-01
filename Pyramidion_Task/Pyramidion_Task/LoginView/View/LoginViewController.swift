//
//  LoginViewController.swift
//  Pyramidion_Task
//
//  Created by Vinutha on 01/09/20.
//  Copyright © 2020 Pyramidion. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var choosePictureLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCorrectionLabel: UILabel!
    
    //MARK: Properties
    private var loginViewModel = LoginViewModel()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userImageViewTapped(_:))))
        choosePictureLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userImageViewTapped(_:))))
    }
    
    //MARK: Methods
    func customizeUI() {
        let radius: CGFloat = userImageView.bounds.size.width / 2.0
        userImageView.layer.cornerRadius = radius
        userImageView.layer.masksToBounds = true
    }
    
    @objc func userImageViewTapped(_ gestureRecognizer: UITapGestureRecognizer){
        handleImageSelection()
    }
    
    func handleImageSelection(){
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        sheet.addAction(UIAlertAction(title: "Take New Photo", style:
            UIAlertAction.Style.default, handler: { (action) -> Void in
                if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) )
                {
                    imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    imagePicker.cameraCaptureMode = .photo
                    imagePicker.cameraDevice =  UIImagePickerController.CameraDevice.rear
                    imagePicker.modalPresentationStyle = .overCurrentContext
                    self.present(imagePicker, animated: false, completion: nil)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
                
        }))
        sheet.addAction(UIAlertAction(title: "Choose From Gallery", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.modalPresentationStyle = .overCurrentContext
            self.present(imagePicker, animated: false, completion: nil)
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(sheet, animated: true, completion: nil)
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage.circle ?? UIImage()
    }
    
    //MARK: Actions
    @IBAction func SubmitClicked(_ sender: UIButton) {
        if userImageView.image == nil {
            userImageErrorLabel.isHidden = false
            userImageErrorLabel.text = "Please choose your picture"
            return
        } else {
            userImageErrorLabel.isHidden = true
        }
        if emailTextField.text == nil || emailTextField.text!.isEmpty == true || !loginViewModel.isEmailValid(email: emailTextField.text!) {
            emailErrorLabel.isHidden = false
            emailErrorLabel.text = "Please enter Valid Email"
            return
        } else {
            emailErrorLabel.isHidden = true
        }
        if passwordTextField.text == nil || passwordTextField.text!.isEmpty == true {
            passwordCorrectionLabel.isHidden = false
            passwordCorrectionLabel.text = "Password field cannot be empty"
            return
        } else if let message = loginViewModel.validatePassWordAndReturnRespectMessage(password: passwordTextField.text!), !message.isEmpty {
            passwordCorrectionLabel.isHidden = false
            passwordCorrectionLabel.text = message
            return
        } else {
            passwordCorrectionLabel.isHidden = true
        }
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SwitchViewController") as! SwitchViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

//MARK: UIImagePicker delegate
extension LoginViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)//For Removing ActionSheet
        self.dismiss(animated: false, completion: nil)// for removing this vc
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false, completion: nil)
        userImageErrorLabel.isHidden = true
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if image == nil{
            dismiss(animated: false, completion: nil)
            handleImageSelection()
            return
        }
        let normalizedImage = fixOrientation(img: image!)
        userImageView.image = normalizedImage
        self.dismiss(animated: false, completion: nil)
    }
}
extension UIImage {
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
