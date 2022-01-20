//
//  LoginViewController.swift
//  chatMessages
//
//  Created by Grazielli Berti on 07/01/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    //MARK: - Views
    private let scrowllView: UIScrollView = {
        let scrowllView = UIScrollView()
        scrowllView.clipsToBounds = true
        return scrowllView
    }()
    
    private let imageview: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "logo")
        imageview.contentMode = .scaleAspectFit
        return imageview
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
    
    fileprivate let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    fileprivate let loginFacebookButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        loginFacebookButton.delegate = self
      
        bindUI()
        setupView()
        setupConstrains()
        
       
        loginButton.center = view.center
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstrains()
    }
    
    
    fileprivate func setupView() {
        view.addSubview(scrowllView)
        scrowllView.addSubview(imageview)
        scrowllView.addSubview(emailField)
        scrowllView.addSubview(passwordField)
        scrowllView.addSubview(loginButton)
        scrowllView.addSubview(loginFacebookButton)
    }
    
    fileprivate func setupConstrains() {
        super.viewDidLayoutSubviews()
        scrowllView.frame = view.bounds //all scream
        
        let size = view.width/3
        imageview.frame = CGRect(x: (view.width-size)/2,
                                 y: 50,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageview.bottom+20,
                                  width: scrowllView.width-60,
                                  height: 52)
        
        
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom+8,
                                  width: scrowllView.width-60,
                                  height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom+20,
                                  width: scrowllView.width-60,
                                  height: 52)
        
        loginFacebookButton.frame.origin.y = loginButton.bottom+20
        loginFacebookButton.frame = CGRect(x: 30,
                                  y: loginButton.bottom+20,
                                  width: scrowllView.width-60,
                                  height: 52)
         
    }
    
    fileprivate func bindUI() {
        //button Register
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        //login Button
        loginButton.addTarget(self,
                              action: #selector(logginButtonTapped),
                              for: .touchUpInside)
    }
    
    @objc private func logginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        //TODO: - Firebase Log In
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let self = self else { return }
            
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }
            
            let user = result.user
            print("Logged in User: \(user)")
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    fileprivate func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to login",
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
    
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            logginButtonTapped()
        }
        return true
    }
}

//MARK: - LoginButtonDelegate
extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start(completion: { _, result, error in
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            
            print("\(result)")
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("Failed to make facebook graph request")
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firtsName: firstName,
                                                                        lastName: lastName,
                                                                        emailAddress: email))
                }
            })
        })
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
            guard let self = self else { return }
            
            guard authResult != nil, error == nil else {
               print("Facebook credential login failed, MFA may be neede")
                return
            }
            
            print("Successfully logged user in")
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
}
