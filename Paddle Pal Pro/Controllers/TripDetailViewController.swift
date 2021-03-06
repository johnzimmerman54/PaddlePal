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
import CoreLocation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class TripDetailViewController: UIViewController, MGLMapViewDelegate {
    
    //MARK: - Local Data Verification
    let realm = try! Realm()
    
    var activeUser : User? {
        didSet {
            if let email = activeUser?.email {
                print("active user: \(email)")
            }
        }
    }
    
    var userTrip : Trip? {
        didSet {
            if let tripName = userTrip?.tripName {
                print("trip name: \(tripName)")
            }
            
            if let tripUser = userTrip?.tripUser {
                print("trip user: \(tripUser)")
            }
            
            if let tripDate = userTrip?.date {
                print("trip date: \(tripDate)")
            }
        }
    }

    
    //MARK: - Map View

    var mapView: NavigationMapView!
    var tripActive = false
    var startPoint: CLLocationCoordinate2D?
    var lastPoint: CLLocationCoordinate2D?
    var currentPoint: CLLocationCoordinate2D?
    var endPoint: CLLocationCoordinate2D?
    var tripCoords = [CLLocationCoordinate2D]()
    
    //MARK: - Stopwatch
    var startButton: UIButton!
    var saveButton: UIButton!
    var stopWatch: UITextField!
    var timer = Timer()
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var fractionsString: String?
    var secondsString: String?
    var minutesString: String?
    var hoursString: String?
    var totalTime = "00:00:00.00"
    
    
    // sample trip
    //
    var tripRoute: Route?
    var directionsRoute: Route?
    let disneyLandCoordinate = CLLocationCoordinate2D(latitude: 33.8121, longitude: -117.9190)
    
    let testCoord1 = CLLocationCoordinate2D(latitude: 45.472633, longitude: -122.669394)
    let testCoord2 = CLLocationCoordinate2D(latitude: 45.472226, longitude: -122.664364)
    let testCoord3 = CLLocationCoordinate2D(latitude: 45.477586, longitude: -122.663132)
    //
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        
        // The user location annotation takes its color from the map view's tint color.
        mapView.tintColor = #colorLiteral(red: 0.08740200847, green: 0.2417854965, blue: 0.2595755458, alpha: 1)
        mapView.attributionButton.tintColor = #colorLiteral(red: 0.08740200847, green: 0.2417854965, blue: 0.2595755458, alpha: 1)
        
        //Trip Vars
        print("userTrip: \(userTrip!.tripName)")
        
        setupStartButton()
        setupStopWatch()
    }
    
    //MARK: - Map Buttons Start / Save
    func setupStartButton() {
        startButton = UIButton(frame: CGRect(x: view.frame.width/2 - 100, y: view.frame.height - 155, width: 200, height: 65))
        startButton.backgroundColor = UIColor(red: 249/255, green: 234/255, blue: 96/255, alpha: 1)
        startButton.setTitleColor(UIColor(red: 22/255, green: 62/255, blue: 66/255, alpha: 1), for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Arial", size: 28)
        startButton.setTitle("Start Trip", for: .normal)
        startButton.layer.cornerRadius = 20
        startButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        startButton.layer.shadowRadius = 20
        startButton.layer.shadowOpacity = 0.5
        startButton.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    func setupSaveButton() {
        saveButton = UIButton(frame: CGRect(x: view.frame.width/2 - 100, y: view.frame.height - 85, width: 200, height: 65))
        saveButton.backgroundColor = UIColor(red: 249/255, green: 234/255, blue: 96/255, alpha: 1)
        saveButton.setTitleColor(UIColor(red: 22/255, green: 62/255, blue: 66/255, alpha: 1), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Arial", size: 28)
        saveButton.setTitle("Save Trip", for: .normal)
        saveButton.layer.cornerRadius = 20
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        saveButton.layer.shadowRadius = 20
        saveButton.layer.shadowOpacity = 0.5
        saveButton.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    func setupStopWatch() {
        stopWatch = UITextField(frame: CGRect(x: 0, y: 90, width: view.frame.width, height: 65))
        stopWatch.allowsEditingTextAttributes = false
        stopWatch.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
        stopWatch.text = String(totalTime)
        stopWatch.font = UIFont(name: "Arial", size: 24)
        stopWatch.textAlignment = NSTextAlignment.center
        view.addSubview(stopWatch)
    }
    
    @objc func startButtonPressed(_ sender: UIButton) {
        
        if tripActive == false {
            timer.invalidate()
            //mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
            
            startButton.setTitle("Pause", for: .normal)
            tripActive = true
            if mapView.userLocation?.location != nil {
                startPoint = CLLocationCoordinate2D(latitude: mapView.userLocation!.location!.coordinate.latitude, longitude: mapView.userLocation!.location!.coordinate.longitude)
                // Add user location start point to trip coordinates
                tripCoords.append(contentsOf: [startPoint!])
                drawTrip()
            } else {
                print("User location not available. - startButtonPressed()")
            }
            
            // Start Timer starts Trip Recording
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tictock), userInfo: nil, repeats: true)
            
        } else {
            tripActive = false
            startButton.setTitle("Resume", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(tictock), userInfo: nil, repeats: false)
            
            setupSaveButton()
        }
        
        
    }
    
    //MARK: Save Button Pressed
    @objc func saveButtonPressed(_ sender: UIButton) {
          //Get Temp Trip
          timer.invalidate()
        
        
            
          
          //Save to User Record
          // save tripCoords to GeoJSON
          //saveGeoJSON(tripCoords: tripCoords)
        
          //Display Trip
          // read GeoJSON
          
          
          //Upload Trip
          
          
      }

    
    //MARK: Save geoJSON
//    func saveGeoJSON(tripCoords: [CLLocationCoordinate2D]) {
//        // GeoJSON sample trip collection
//        let geoJsonCoords = """
//            {
//              "type": "FeatureCollection",
//                {
//                  "type": "Feature",
//                  "properties": {
//                    "NAME": "<tripName>",
//                    "TYPE": "Route"
//                  },
//                  "geometry": {
//                    "type": "LineString",
//                    "coordinates": [
//
//                    // parse tripCoords
//                      [
//                        45.472633,
//                        -122.669394
//                      ],
//                      [
//                        45.472226,
//                        -122.664364
//                      ],
//                      [
//                        45.477586,
//                        -122.663132
//                      ],
//                    ]
//                  },
//                  "id": "e0369f23e7e33d9f11a695f0bf6a2498"
//                }
//            }
//            """
//
//        do {
//            let geoJsonData = geoJsonCoords.data(using: .utf8)!
//            let geoJsonModel = try JSONDecoder().decode(FeatureCollection.self, from: geoJsonData)
//        } catch {
//            print("Error during encoding geoJSON")
//        }
//
//
//        // Parse trip coordinates to geojson file and save
//        let fileName = userTrip!.tripUser + userTrip!.tripName
//
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("geojson")
        
        
        //tripCoords.forEach(tripCoords) {
            
         //   do {
         //       try str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
         //   } catch {
                 //failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
         //   }
        
        //}
    //}
    
    
    // MARK: - Customizing calculateRoute() to track all trip coords
    func recordRoute(from lastCoor: CLLocationCoordinate2D, to nextCoor: CLLocationCoordinate2D) {
        
        let lastPoint = CLLocation(latitude: lastCoor.latitude, longitude: lastCoor.longitude)
        let nextPoint = CLLocation(latitude: nextCoor.latitude, longitude: nextCoor.longitude)
        // calculate distance between points
        let distanceInMeters = lastPoint.distance(from: nextPoint)

        // add next trip coordinate if greater than 3 meters from last
        if distanceInMeters > 3 {
            // set new point
            tripCoords.append(nextCoor)
        } else {
            return
        }
        
    }
    
    //MARK: Draw Trip
    
    func drawTrip() {
        guard tripCoords.count > 0 else { return }
        //var routeCoordinates = tripCoords
        lastPoint = tripCoords.last
        
        // Get User Location
        if mapView.userLocation != nil {
            currentPoint = CLLocationCoordinate2D(latitude: mapView.userLocation!.coordinate.latitude, longitude: mapView.userLocation!.coordinate.longitude)
            
            // Compare User Location to last Coordinant and record if > 10 meters
            recordRoute(from: lastPoint!, to: currentPoint!)
        } else {
            print("User location not available. - drawTrip()")
        }
        
        // Find coordinant bounds sw (lower left) and ne (upper right)
        // compare all coords to choose west most point
        // latitude < to south, > to north
        // longitude < to east, > to west
        var northMost = CLLocationDegrees(currentPoint!.latitude)
        var eastMost = CLLocationDegrees(currentPoint!.longitude)
        var southMost = CLLocationDegrees(currentPoint!.latitude)
        var westMost = CLLocationDegrees(currentPoint!.longitude)
        
        for coord in tripCoords
        {
            if northMost < coord.latitude {
                northMost = coord.latitude
            }
            
            if eastMost > coord.longitude {
                eastMost = coord.longitude
            }
            
            if southMost > coord.latitude {
                southMost = coord.latitude
            }

            if westMost < coord.longitude {
                westMost = coord.longitude
            }

        }
        
        let swPoint = CLLocationCoordinate2DMake(southMost, westMost)
        let nePoint = CLLocationCoordinate2DMake(northMost, eastMost)
        
        let coordinateBounds = MGLCoordinateBounds(sw: swPoint, ne: nePoint)
        let insets = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
        self.mapView.setCamera(routeCam, animated: true)
        
        //draw route
        let annotationStart = MGLPointAnnotation()
        annotationStart.coordinate = testCoord1
        annotationStart.title = "Start"
        mapView.addAnnotation(annotationStart)
        
        let polyline = MGLPolylineFeature(coordinates: &tripCoords, count: UInt(tripCoords.count))
        
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3.0)
            
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
        
    }
    
   
    
    // MARK: - stopwatch count and record trip
    @objc func tictock() {
        if tripActive {
            //record time and mark coord every 10 seconds
            fractions += 1
            if fractions > 99 {
                seconds += 1
                fractions = 0
                // Draw Route every second
                if mapView.userLocation != nil {
                    drawTrip()
                }
            }
            if seconds > 59 {
                minutes += 1
                seconds = 0
            }
            if minutes > 59 {
                hours += 1
                minutes = 0
            }
            //Running time
            fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
            secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
            hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
            totalTime = "\(hoursString!):\(minutesString!):\(secondsString!).\(fractionsString!)"
            stopWatch.text = totalTime
        }
        else {
            timer.invalidate()
            
        }
    }
    
//    func calculateRoute(from originCoor: CLLocationCoordinate2D, to destinationCoor: CLLocationCoordinate2D, completion: @escaping (Route?, Error?) -> Void) {
//
//        let origin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
//        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
//
//        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
//
//        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in self.directionsRoute = routes?.first
//            self.drawRoute(route: self.directionsRoute!)
//
//            //draw line
////            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
////            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
////            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
////            self.mapView.setCamera(routeCam, animated: true)
//
//        })
//    }
//
//    func drawRoute(route: Route) {
//        guard route.coordinateCount > 0 else { return }
//        var routeCoordinates = route.coordinates!
//        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
//
//        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
//            source.shape = polyline
//        } else {
//            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
//
//            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
//            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
//            lineStyle.lineWidth = NSExpression(forConstantValue: 4.0)
//
//            mapView.style?.addSource(source)
//            mapView.style?.addLayer(lineStyle)
//        }
//
//    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
//    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
//        let navigationVC = NavigationViewController(for: directionsRoute!)
//        present(navigationVC, animated: true, completion: nil)
//    }
    

     

     

}
