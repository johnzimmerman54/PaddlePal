//
//  RegisterViewController.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class RegisterViewController: UIViewController {
    
    let realm = try! Realm()
    var user: User?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TripsViewController
        destinationVC.activeUser = user
    }
    
    //MARK: - Register Pressed
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("Authentification failed, \(e)")
                    // Need user alert message
                    
                } else {
                    // Save new user for session
                    self.user = User()
                    self.user?.email = email
                    let userId = self.realm.objects(User.self).count
                    self.user?.id = userId
                    
                    print(email)
                    print("email: \(String(describing: self.user?.email)), id: \(String(describing: self.user?.id))")
                    
                    do {
                        try self.realm.write {
                            self.realm.add(self.user!, update: .modified)
                        }
                    } catch {
                        print("Error saving user, \(error)")
                    }
                    
                    
                    
                    
                    
                    if self.user?.email != nil {
                        do {
                            try self.realm.write {
                                self.realm.add(self.user!)
                            }
                        } catch {
                            print("Error logging in user, \(error)")
                            // Please correct your email
                            
                            // Please correct your password
                            
                        }
                    }
                    //Navigate to Trips Controller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
        
    }


}
