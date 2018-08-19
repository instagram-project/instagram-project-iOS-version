//
//  Authentication.swift
//  Instagram-Project
//
//  Created by Eugene Posikyra on 16.08.2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import Foundation






struct Login {
    let email: String
    let password: String
}

struct Register {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
    
    init(name: String, email: String, password: String, confirmPassword: String) {
        self.name = name
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
    }
    
}
