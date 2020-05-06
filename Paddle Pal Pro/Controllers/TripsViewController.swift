//
//  TripViewController.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/4/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import ChameleonFramework

class TripsViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var tripList: Results<Trip>?
    var userTrip: Trip?
    
    var activeUser : User? {
        didSet {
            if let email = activeUser?.email {
                print("trips user email: \(email)")
                loadTrips()
            }
        }
    }
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = K.appName
        
        tableView.separatorStyle = .none
    }
    
    //MARK: - TableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let trip = tripList?[indexPath.row] {
            cell.textLabel?.text = trip.tripName
            
            guard let tripColor = UIColor(hexString: trip.color) else {fatalError()}
            
            cell.backgroundColor = tripColor
            
            cell.textLabel?.textColor = ContrastColorOf(tripColor, returnFlat: true)
        } else {
            cell.textLabel?.text = "No Trips Started Yet"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.tripDetailSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TripDetailViewController
        
        destinationVC.activeUser = activeUser
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.userTrip = tripList?[indexPath.row]
        }
        
    }
    
    //MARK: - Load Trip from List
    
    
    
    //MARK: - Create Trip
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Trip Name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Let's Go!", style: .default) { (action) in
            //add item button clicked
            let newTrip = Trip()
            newTrip.tripName = textField.text!
            newTrip.color = UIColor.randomFlat().hexValue()
            newTrip.date = Date()
            newTrip.tripUser = self.activeUser!.email
            self.save(trip: newTrip)
        }
        
        alert.addTextField{ (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add New Category"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(trip: Trip) {
        do {
            try realm.write {
                realm.add(trip)
            }
        } catch {
            print("Error saving trip, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadTrips() {
        tripList = realm.objects(Trip.self).filter("tripUser == %@", String(activeUser!.email))
        
        tableView.reloadData()
    }
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signoutError as NSError {
            print("Error signing out: %@", signoutError)
        }
        
    }
    
    
}
