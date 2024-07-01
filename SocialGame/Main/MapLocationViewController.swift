//
//  MapLocationViewController.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 20/02/24.
//

import UIKit
import MapKit
import CoreLocation

struct Game {
    let gameId: String
    let categoryName: String
    let creatorName: String
    let latitude: Double
    let longitude: Double
}


class MapLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    
    var locationManger = CLLocationManager()
    var games: [Game] = []
    var strCategoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.mapVw.delegate = self
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation() // Start updating location
        
        self.setUp()
        self.setupUserTrackingButton()
    }
    
    
    func setUp() {
        // Iterate through your 'games' array and add pins to the map
//        for game in games {
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: game.latitude, longitude: game.longitude)
//            annotation.title = game.categoryName
//            annotation.subtitle = game.creatorName
//            self.mapVw.addAnnotation(annotation)
//        }
        
        // Iterate through your 'games' array and add custom image annotations to the map
        for game in games {
            let annotation = CustomAnnotation(game: game)
            self.mapVw.addAnnotation(annotation)
        }
        
        // Set the initial region to focus on user's location
        if let userLocation = locationManger.location?.coordinate {
            let initialRegion = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            self.mapVw.setRegion(initialRegion, animated: true)
        }
    }
    
    // Implement MKMapViewDelegate to customize the appearance of the custom image annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil // Return nil for default blue dot for user location
        }
        
        guard annotation is CustomAnnotation else {
            return nil
        }
        
        // Use a custom MKAnnotationView with an UIImageView to display the image
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customImagePin")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: self.games[0].categoryName) // Replace with the name of your custom image
        
        return annotationView
    }
    
//    // Implement MKMapViewDelegate if you want to customize the appearance of the pins
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "customPin")
//        annotationView.canShowCallout = true
//        return annotationView
//    }
    
    // CLLocationManagerDelegate method to handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first?.coordinate {
            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            self.mapVw.setRegion(region, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.locationManger.stopUpdatingLocation()
        })
        
    }
    
    func setupUserTrackingButton() {
        let button = MKUserTrackingButton(mapView: mapVw)
        button.frame = CGRect(origin: CGPoint(x: 15, y: 15), size: CGSize(width: 30, height: 30))
        mapVw.addSubview(button)
        
        let item = MKUserTrackingBarButtonItem(mapView: mapVw)
        navigationItem.rightBarButtonItem = item
    }

    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
   
}


// CustomAnnotation class to store additional information for each annotation
class CustomAnnotation: NSObject, MKAnnotation {
    let game: Game
    
    init(game: Game) {
        self.game = game
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: game.latitude, longitude: game.longitude)
    }
    
    var title: String? {
        return game.categoryName
    }
    
    var subtitle: String? {
        return game.creatorName
    }
}
