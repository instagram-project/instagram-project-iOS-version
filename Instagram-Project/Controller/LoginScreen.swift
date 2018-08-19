//
//  LoginScreen.swift
//  Instagram-Project
//
//  Created by Eugene Posikyra on 15.08.2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class LoginScreen: UIViewController {
    
    let serverURL = "http://138.197.150.20/login"
    
    @IBOutlet weak var usermail: UITextField!
    @IBOutlet weak var userpassword: UITextField!
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let user = usermail.text
        let password = userpassword.text
        if (user?.isEmpty)! || (password?.isEmpty)!
        {
            showMessage(userMessage: "Не все поля были заполнены")
            return
        }
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        let loginParams: Parameters = ["email": usermail.text!, "password": userpassword.text!]
        
 
        Alamofire.request(serverURL, method: .post, parameters: loginParams, encoding: JSONEncoding.default).responseJSON { response in
            guard response.error == nil else {
                self.showMessage(userMessage: "something went wrong!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.usermail.text = ""
                    self.userpassword.text = ""
                    self.reloadInputViews()
                })
                return
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
              
                print("Data: \(utf8Text)")
                print(loginParams)
                
                
                print(utf8Text)
                
                let accessJsonData = self.convertToDictionary(text: utf8Text)
                
                guard (accessJsonData?.keys.contains("value")) != nil else {
                    
                    self.showMessage(userMessage: "Something went wrong!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self.usermail.text = ""
                        self.userpassword.text = ""
                        self.reloadInputViews()
                    })
                    return
                    
                }
                
                let token = accessJsonData!["value"] as! String
                let email = accessJsonData!["email"] as! String
                let name = accessJsonData!["name"] as! String
                let saveAccessToken: Bool = KeychainWrapper.standard.set(token, forKey: "token")
                let saveEmail: Bool = KeychainWrapper.standard.set(email, forKey: "email")
                let saveName: Bool = KeychainWrapper.standard.set(name, forKey: "name")
                print("The access token save result: \(saveAccessToken)")
                print("The userId save result \(saveEmail)")
                print("user name is \(saveName)")
                
            }
            
        }
       
  self.removeActivityIndicator(activityIndicator: activityIndicator)
        self.showMessage(userMessage: "You successfully signed in!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.performSegue(withIdentifier: "goToProfile", sender: sender)
        })
        //performSegue(withIdentifier: "goToProfile", sender: sender)
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: sender)
    }

    override func viewWillAppear(_ animated: Bool) {
        usermail.text = ""
        userpassword.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "token")
        if accessToken != nil {
            performSegue(withIdentifier: "goToProfile", sender: self)
        }
    }
    

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
            
        }
        return nil
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
            activityIndicator.removeFromSuperview()
            
        }
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
