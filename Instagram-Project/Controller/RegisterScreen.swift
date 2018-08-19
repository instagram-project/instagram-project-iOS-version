//
//  RegisterScreen.swift
//  Instagram-Project
//
//  Created by Eugene Posikyra on 15.08.2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RegisterScreen: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        
        let serverURL = "http://138.197.150.20/register"
        
        if (userName.text?.isEmpty)! ||
            (userEmail.text?.isEmpty)! ||
            (password.text?.isEmpty)! {
            showMessage(userMessage: "Все поля должны быть заполнены!")
            return
        }
        if ((password.text?.elementsEqual(confirmPassword.text!))! != true) {
            showMessage(userMessage: "Пароли не совпадают!")
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        

        let registerParams: Parameters = ["name": userName.text!, "email": userEmail.text!, "password": password.text!, "confirmPassword": confirmPassword.text!]
        
        
        Alamofire.request(serverURL, method: .post, parameters: registerParams, encoding: JSONEncoding.default).responseJSON { response in
        
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
                print(registerParams)
                self.showMessage(userMessage: "\(utf8Text)")
            } else {
                self.showMessage(userMessage: "Something went wrong!")
                return
            }
        }
        removeActivityIndicator(activityIndicator: activityIndicator)
    }
    @IBAction func backToLoginButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
