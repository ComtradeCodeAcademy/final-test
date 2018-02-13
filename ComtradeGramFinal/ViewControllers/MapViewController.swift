//
//  ViewController.swift
//  ComtradeGramFinal
//
//  Created by Predrag Jevtic on 1/10/18.
//  Copyright © 2018 com.comtrade.Gram. All rights reserved.
//

import UIKit
import SwiftInstagram
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var post: InstagramMedia?
    
    @IBOutlet weak var mapView: MKMapView!
    let distanceSpan: Double = 500
    let postPin = MKPointAnnotation()
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager!.requestAlwaysAuthorization()
        locationManager!.distanceFilter = 50
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.requestWhenInUseAuthorization()
        }
        
    }
    
    //https://stackoverflow.com/questions/35685006/how-i-can-center-the-map-on-users-location-in-swift
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.post?.location?.coordinates.latitude)
        self.updatePostLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to initialize GPS: ", error.description)
    }
    
    
    // present user location on map
    // get post location latitude and longitude and present it's pointer
    // add annotation view with title: postName and description
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("button tapped")
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let userLocation = locations[0] as! CLLocation
        
        locationManager?.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let span = MKCoordinateSpanMake(1.0, 1.0)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: false)
        
    }
    
    func updatePostLocation() {
        if let mapView = self.mapView {
            let location = self.post?.location
            let center = self.post?.location?.coordinates
            
            let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
            
            mapView.removeAnnotation(self.postPin)

            
    
            //set region on the map
            mapView.setRegion(region, animated: true)
            
            if let coordinates = location?.coordinates {
                postPin.coordinate = coordinates
                mapView.addAnnotation(postPin)
            }

            
//            var annotation = MKPointAnnotation.init()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: 11.12, longitude: 12.11)
//            mapView.addAnnotation(annotation)
        
        
        
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, self.distanceSpan, self.distanceSpan)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
}























//
//
////
////  ViewController.swift
////  ComtradeGramFinal
////
////  Created by Predrag Jevtic on 1/10/18.
////  Copyright © 2018 com.comtrade.Gram. All rights reserved.
////
//
//import UIKit
//import SwiftInstagram
//import LocationPicker
//import CoreLocation
//
//class MapViewController: UIViewController {
//
//    var post: InstagramMedia?
//
//    let locationPicker = LocationPickerViewController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view, typically from a nib.
//
//
//
//        // you can optionally set initial location
////                _ = CLLocation(latitude: 44.834561, longitude: 20.411077)
////        let initialLocation = Location(name: "Comtrade-Code", location: Location)
////        locationPicker.location = initialLocation
//
//        // button placed on right bottom corner
//        locationPicker.showCurrentLocationButton = true // default: true
//
//        // default: navigation bar's `barTintColor` or `.whiteColor()`
//        locationPicker.currentLocationButtonBackground = .red
//
//        // ignored if initial location is given, shows that location instead
//        locationPicker.showCurrentLocationInitially = true // default: true
//
//        locationPicker.mapType = .standard // default: .Hybrid
//
//        // for searching, see `MKLocalSearchRequest`'s `region` property
//        locationPicker.useCurrentLocationAsHint = true // default: false
//
//        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
//
//        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
//
//        // optional region distance to be used for creation region when user selects place from search results
//        locationPicker.resultRegionDistance = 600 // default: 600
//
//        locationPicker.completion = { location in
//            // do some awesome stuff with location
//
//        }
//
//        navigationController?.pushViewController(locationPicker, animated: true)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
//
