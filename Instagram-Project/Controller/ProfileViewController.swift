//
//  ProfileViewController.swift
//  Instagram-Project
//
//  Created by Eugene Posikyra on 19.08.2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var displayNameText: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemberInfo()
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        KeychainWrapper.standard.removeObject(forKey: "token")
        KeychainWrapper.standard.removeObject(forKey: "email")
        KeychainWrapper.standard.removeObject(forKey: "name")
        showMessage(userMessage: "You logged out")
        performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    
    func loadMemberInfo() {
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "token")
        let userEmail: String? = KeychainWrapper.standard.string(forKey: "email")
        let accessName: String? = KeychainWrapper.standard.string(forKey: "name")
        
        
        usernameText.text = userEmail
        displayNameText.text = accessName
        let imageURL = "http://178.128.239.249/user/avatar?token={\(String(describing: accessToken!))}"
        Alamofire.request(imageURL, method: .get).responseImage { response in
            guard let image = response.result.value else {
                print(imageURL)
                print("no image")
                self.userImage.image = #imageLiteral(resourceName: "placeholder-face-big")
                return
            }
            self.userImage.image = image
            print("got the image")
            print(imageURL)
        }
        print(accessToken)
        print(userEmail)
    }
    
    func showMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Внимание!", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                print("ok button pressed")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
