//
//  RegisterViewController.swift
//  chatMessages
//
//  Created by Grazielli Berti on 07/01/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    //MARK: - Views
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrowllView: UIScrollView = {
        let scrowllView = UIScrollView()
        scrowllView.clipsToBounds = true
        return scrowllView
    }()
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "person.circle")
        imageview.tintColor = .gray
        imageview.contentMode = .scaleAspectFit
        imageview.layer.masksToBounds = true
        imageview.layer.borderWidth = 1
        imageview.layer.borderColor = UIColor.lightGray.cgColor
        return imageview
    }()
    
    private let firstNameField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "First Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let lastNameField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Last Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .continue
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Email adreass"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    fileprivate let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        
        imageview.isUserInteractionEnabled = true
        scrowllView.isUserInteractionEnabled = true
        
        bindUI()
        setupView()
        setupConstrains()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstrains()
    }
    
    
    fileprivate func setupView() {
        view.addSubview(scrowllView)
        scrowllView.addSubview(imageview)
        scrowllView.addSubview(firstNameField)
        scrowllView.addSubview(lastNameField)
        scrowllView.addSubview(emailField)
        scrowllView.addSubview(passwordField)
        scrowllView.addSubview(registerButton)
    }
    
    fileprivate func setupConstrains() {
        super.viewDidLayoutSubviews()
        scrowllView.frame = view.bounds //all scream
        
        let size = view.width/3
        imageview.frame = CGRect(x: (view.width-size)/2,
                                 y: 50,
                                 width: size,
                                 height: size)
        
        imageview.layer.cornerRadius = imageview.width/2.0
        
        firstNameField.frame = CGRect(x: 30,
                                      y: imageview.bottom+20,
                                      width: scrowllView.width-60,
                                      height: 52)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+8,
                                     width: scrowllView.width-60,
                                     height: 52)
        
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom+8,
                                  width: scrowllView.width-60,
                                  height: 52)
        
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+8,
                                     width: scrowllView.width-60,
                                     height: 52)
        
        registerButton.frame = CGRect(x: 30,
                                      y: passwordField.bottom+20,
                                      width: scrowllView.width-60,
                                      height: 52)
        
    }
    
    fileprivate func bindUI() {
        //login Button
        registerButton.addTarget(self,
                                 action: #selector(logginButtonTapped),
                                 for: .touchUpInside)
        
        //change profile pic
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        gesture.numberOfTouchesRequired = 1
        imageview.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func logginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        
        //TODO: - Firebase Log In
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            guard !exists else {
                // user already exists
                self.alertUserLoginError(message: "Looks like a user account for that email already exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email,password: password, completion: {  authResult, error in
               
                
                guard authResult != nil, error == nil else {
                    print("Error cureating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firtsName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                
                self.navigationController?.dismiss(animated: true, completion: nil)
                
            })
        })
    }
    
    fileprivate func alertUserLoginError(message: String = "Please enter all information to create a new account") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "Dismiss",
                style: .cancel,
                handler: nil
            )
        )
        
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            logginButtonTapped()
        }
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(
            title: "Profile Picture",
            message: "How would you like to select a picture",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
                                                
                                            }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let viewController = UIImagePickerController()
        viewController.sourceType = .camera
        viewController.delegate = self
        viewController.allowsEditing = true
        present(viewController, animated: true)
    }
    
    func presentPhotoPicker() {
        let viewController = UIImagePickerController()
        viewController.sourceType = .photoLibrary
        viewController.delegate = self
        viewController.allowsEditing = true
        present(viewController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageview.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
