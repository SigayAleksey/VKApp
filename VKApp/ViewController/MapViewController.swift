//
//  MapViewController.swift
//  VKApp
//
//  Created by Алексей Сигай on 13.05.2018.
//  Copyright © 2018 Sigay Aleksey. All rights reserved.
//

import MapKit
import CoreLocation

protocol PassCoordinatesDelegate {
    func passCoordinates(coordinates: CLLocation?)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let mapScale: Double = 10_000
    var previousLocation: CLLocation?
    var delegate: PassCoordinatesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: mapScale, longitudinalMeters: mapScale)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    @IBAction func saveLocation(_ sender: Any) {
        delegate?.passCoordinates(coordinates: getCenterLocation(for: mapView))
        navigationController?.popToRootViewController(animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geocoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                // TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                // TODO: Show alert informing the user
                return
            }
            
            var sreetName = ""
            var houseNumber = ""
            if placemark.thoroughfare != nil {
                sreetName = placemark.thoroughfare!
            }
            if placemark.subThoroughfare != nil {
                houseNumber = placemark.subThoroughfare!
            }
            
            // Address transfer
            DispatchQueue.main.async {
                self.addressLabel.text = "\(sreetName) \(houseNumber)"
            }
        }
    }
}
