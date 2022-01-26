//
//  ProfileViewController.swift
//  chatMessages
//
//  Created by Grazielli Berti on 07/01/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    //MARK: - Variable
    let data = ["Log Out"]
    //let reuseIdentifier = "profileTableViewCell"
    let cellHeight: CGFloat = 50
    
    //MARK: - View
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = creatTableHeader()
        
        setuView()
        setupConstrains()
    }
    
    func creatTableHeader() -> UIView? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
//
//        let safeEmail = DatabaseManager.safeEmail(emailAdress: email)
//        let filename = safeEmail + "_profile_picture.png"
//        let path = "images/"+filename
        
       
        let headerView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: self.view.width,
                                            height: 300))
        headerView.backgroundColor = .link
            
        let imageView = UIImageView(frame: CGRect(x: (view.width-150)/2,
                                                      y: 75,
                                                      width: 150,
                                                      height: 150))
       
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        
        headerView.addSubview(imageView)
        return headerView
    }
    
    fileprivate func setuView() {
        view.addSubview(tableView)
    }
    
    fileprivate func setupConstrains() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive,
                                      handler: { _ in
                                        do {
                                            try FirebaseAuth.Auth.auth().signOut()
                                            let vc = LoginViewController()
                                            let nav = UINavigationController(rootViewController: vc)
                                            nav.modalPresentationStyle = .fullScreen
                                            self.present(nav, animated: true)
                                        } catch {
                                            print("Failed to log out")
                                        }
       }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil)
        )
        
        present(alert, animated: true)
        
    }
}
