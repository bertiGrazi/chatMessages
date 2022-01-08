//
//  RegisterViewController.swift
//  chatMessages
//
//  Created by Grazielli Berti on 07/01/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - Views
    private let scrowllView: UIScrollView = {
        let scrowllView = UIScrollView()
        scrowllView.clipsToBounds = true
        return scrowllView
    }()
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "person")
        imageview.tintColor = .gray
        imageview.contentMode = .scaleAspectFit
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
        print("Change pic called")
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
        
        //TODO: - Firebase Login
    }
    
    fileprivate func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to register",
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
