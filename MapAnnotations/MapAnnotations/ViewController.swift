//
//  ViewController.swift
//  MapAnnotations
//
//  Created by catie on 4/20/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //we can implement delegate protocol
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
        configureLocationService()
    }
    
    private func configureLocationService(){
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: locationManager)
        }
        else{
            //give error alert to use with the issue
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager){
        //start updating
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(zoomRegion, animated: true)
        
    }

    private func addAnnotations(){
        
        //initialized them
        let appleParkAnnotation = MKPointAnnotation()
        appleParkAnnotation.title = "Apple Park"
        appleParkAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.3327, longitude: -122.0053)
        
        let ortegaParkAnnotation = MKPointAnnotation()
        ortegaParkAnnotation.title = "Ortega Park"
        ortegaParkAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.3422, longitude: -122.0256)
        
        //now we add them
        mapView.addAnnotation(appleParkAnnotation)
        mapView.addAnnotation(ortegaParkAnnotation)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Will return to this
        //print("Did get latest location")
        
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
        
        currentCoordinate = latestLocation.coordinate
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //Will return to this for request of user location
       // print("The status changed")
        
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
        }
    }
}
extension ViewController: MKMapViewDelegate{
    //derives from UIView so we can use those
    //like image property
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView ==  nil {
            annotationView  = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let title = annotation.title, title == "Apple Park" || title == "Ortega Park"{
            let  pinImage = UIImage(named: "pin")
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView?.image = resizedImage
            
        }
        else{
            return nil
        }
        //else{
        //    annotationView?.image = UIImage(named: "pin")
        //}
        //User location can be refered to as mapView.userLocation
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //will work with if they are selected
        print("Annotation was selected \(view.annotation?.title)")
    }
}
