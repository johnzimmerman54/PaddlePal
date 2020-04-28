//
//  TripDetailViewController.swift
//  Paddle Pal Pro
//
//  Created by Warren Zimmerman on 3/6/20.
//  Copyright © 2020 Warren Zimmerman. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Mapbox

class TripDetailViewController: UIViewController, MGLMapViewDelegate {
    
    let realm = try! Realm()
    var myTrip: Trip?
    
    var activeUser : User? {
        didSet {
            if let email = activeUser?.email {
                print("trips user email: \(email)")
                //startTrip()
            }
        }
    }
    //MARK: - Map View

    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.outdoorsStyleURL)

        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        mapView.delegate = self

        // The user location annotation takes its color from the map view's tint color.
        mapView.tintColor = .red
        mapView.attributionButton.tintColor = .lightGray

        // Enable the always-on heading indicator for the user location annotation.
        mapView.showsUserHeadingIndicator = true

        view.addSubview(mapView)
    }
    
    //GeoJson format for each coord
    //    {
    //      "type": "Feature",
    //      "properties": {
    //        "NAME": "Red",
    //        "TYPE": "Rail line"
    //      },
    //      "geometry": {
    //        "type": "LineString",
    //        "coordinates": [
    //          [
    //            -77.020294,
    //            38.979839
    //          ],
    //          [
    //            -77.020057,
    //            38.979409
    //          ]
    //        ]
    //    }
    //    }
    
    //Start button - begin recording coords
    
    
    
    // Pause button - pause recording coords and save trip data
    
    
    
    //Stop button - end recording coords and save trip data
    
    
    
    
 
}
