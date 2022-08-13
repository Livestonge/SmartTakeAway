//
//  MapViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 14/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var continueBt: UIButton!
    
    var restaurant: Restaurant?
    var restaurants: [Restaurant] = []
    var restaurantsProvider: RestaurantsProvider?
    lazy private var geocoder = CLGeocoder()
    private var locationManager: CLLocationManager?
    
    var hideContinueBt = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = "Find your restaurant"
        continueBt.isHidden = hideContinueBt
        continueBt.layer.cornerRadius = 20
      
        restaurantsProvider = RestaurantsProviding()
        restaurantsProvider?.delegate = self
        restaurantsProvider?.getRestaurants()
        self.restaurant = restaurants.first
      
        configureLocationManager()
        configureMapView()
        convertTolocations()
      
        continueBt.addTarget(self,
                             action: #selector(didTapContinueBt),
                             for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @objc
    func didTapContinueBt(){
      self.tabBarController?.selectedIndex = 1
    }
    private func configureMapView(){
        
        self.mapView.register(RestaurantView.self,
                              forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.mapView.delegate = self
    }
    
    private func configureLocationManager(){
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    private func convertTolocations(_ index: Int = 0){
      if index < restaurants.count{
          geocoder.geocodeAddressString(restaurants[index].adresse){ [weak self] (placemarks,error) in
                     
                     if let error = error{
                         print(error.localizedDescription)
                     }
                     guard let location = placemarks?.first?.location else {return}
                     self?.restaurants[index].longitude = location.coordinate.longitude
                     self?.restaurants[index].latitude = location.coordinate.latitude
                     self?.convertTolocations(index+1)
          }
      } else if index >= restaurants.count{
          
      self.mapView.addAnnotations(restaurants)
      self.centerTheMap()
      }
     
  }
    
    private func centerTheMap(){

        guard let restaurant = self.restaurant else {return}
        let regionRadius = 1000.0
        let region = MKCoordinateRegion(center: restaurant.coordinate,
                                               latitudinalMeters: regionRadius,
                                               longitudinalMeters: regionRadius)
        self.mapView.setRegion(region, animated: true)
        self.loadDirection(to: restaurant)
    }
    
    private func loadDirection(to restaurant: Restaurant){
        
        let sourceLocation = mapView.userLocation
        let request = MKDirections.Request()
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation.coordinate))
        let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))
        request.source = startMapItem
        request.destination = endMapItem
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        let direction = MKDirections(request: request)
        direction.calculate{ [weak self] (response, error) in
            
            guard error == nil, let route = response?.routes.first else {return}
            DispatchQueue.main.async{
                self?.mapView.addOverlay(route.polyline)
            }
        }
    }
}



extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            locationManager?.startUpdatingLocation()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  
          // Do Nothing......
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension MapViewController: MKMapViewDelegate{
  
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
      guard let restaurant = view.annotation as? Restaurant, let ctrl = self.tabBarController as? TabBarViewController else { return }
      ctrl.didSelect(restaurant: restaurant)
      
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Using the default system view to display the user`s location.
        if annotation is MKUserLocation{
            return nil
        }
        
        if annotation is Restaurant {
            // Creates a new view if there is not a view with the same identifier already on the queue.
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier:            MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
            
            annotationView.clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
            annotationView.annotation = annotation
           
            
            return annotationView
        }
        return nil
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard  overlay is MKPolyline else {return MKCircleRenderer()}
        let polyRender = MKPolylineRenderer(overlay: overlay)
        polyRender.lineWidth = 4.0
        polyRender.strokeColor = UIColor.yellow
        return polyRender
    
        
    }
    
}

extension MapViewController: RestaurantsProviderDelegate{

  func didReceive(restaurants: [Restaurant]) {
    self.restaurants = restaurants
  }
}
