//
//  LoginViewController.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class LoginViewController: UIViewController {
    
    let realm = try! Realm()
    var userResult: Results<User>?
    var user: User?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.loginSegue {
            let destinationVC = segue.destination as! TripsViewController
            destinationVC.activeUser = user
        }
    }
    
    //MARK: - Login Methods
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print("Authentification failed, \(e)")
                    // Need user alert message
                    
                } else {
                    self.user = User()
                    self.user?.email = email
                    self.user?.id = self.userResult?.count ?? 0
                    do {
                        try self.realm.write {
                            self.realm.add(self.user!, update: .modified)
                        }
                    } catch {
                        print("Error saving user, \(error)")
                    }
                    
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
}
