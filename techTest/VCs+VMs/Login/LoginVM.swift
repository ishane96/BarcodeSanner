//
//  LoginVM.swift
//  techTest
//
//  Created by Achintha kahawalage on 2022-11-03.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginVM{
    
    var ref: DatabaseReference!
    
    func login(completion: @escaping CompletionHandler){
        ref = Database.database().reference()
        
        Auth.auth().signIn(withEmail: "techcheck@ikhokha.com", password: "password"){ [weak self] authResult, error in
            guard let strongSelf = self else {return}
            
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "")
            }
        }
    }
}
