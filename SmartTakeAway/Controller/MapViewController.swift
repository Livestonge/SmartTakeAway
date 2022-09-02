//
//  MapViewController.swift
//  Fadira2
//
//  Created by awaleh moussa hassan on 14/03/2020.
//  Copyright © 2020 awaleh moussa hassan. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet var mapView: MKMapView!

    // MARK: Proprieties

    // The currently selected restaurant
    var restaurant: Restaurant?
    // Variable for holding the list of restaurant to show on the map.
    var restaurants: [Restaurant] = []
    // An object that provides the restaurants to show.
    var restaurantsProvider: RestaurantsProvider?
    // An object for positionning the restaurants on the map.
    private lazy var geocoder = CLGeocoder()
    // An object for handling the delivery of locations to the map.
    private var locationManager: CLLocationManager?

    // MARK: ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Find your restaurant"
        // Dependencies Injections
        restaurantsProvider = RestaurantsProviding()
        restaurantsProvider?.delegate = self
        restaurantsProvider?.getRestaurants()
        restaurant = restaurants.first

        configureLocationManager()
        configureMapView()
        convertTolocations()
    }

    // MARK: Methods

    private func configureMapView() {
        // Registering the restaurant view.
        mapView.register(RestaurantView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.delegate = self
    }

    private func configureLocationManager() {
        // Intiatiate a CoreLocationManager instance
        locationManager = CLLocationManager()
        // Attributes the current viewController as the delegate of this location manager instance.
        locationManager?.delegate = self
        // Ask the system for location updates
        locationManager?.startUpdatingLocation()
        // Sets the precision
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    private func convertTolocations(_ index: Int = 0) {
        if index < restaurants.count {
            // Ask the geocoder variable to retrieve the coordinate of a restaurant based on his adress.
            geocoder.geocodeAddressString(restaurants[index].adresse) { [weak self] placemarks, error in
                // In the case of an error, we print the error to the console.
                if let error = error {
                    print(error.localizedDescription)
                }
                // Checks if we got valid location
                guard let location = placemarks?.first?.location else { return }
                // Assign the location to the appropriate restaurant
                self?.restaurants[index].longitude = location.coordinate.longitude
                self?.restaurants[index].latitude = location.coordinate.latitude
                // Use regression to go through the list.
                self?.convertTolocations(index + 1)
            }
        } else if index >= restaurants.count {
            // When all the restaurants in the list are all updated with coordinates. we add them to map.
            mapView.addAnnotations(restaurants)
            // Centers the map.
            centerTheMap()
        }
    }

    private func centerTheMap() {
        // Centers the map around the selected restaurant.
        guard let restaurant = restaurant else { return }
        let regionRadius = 1000.0
        let region = MKCoordinateRegion(center: restaurant.coordinate,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
        loadDirection(to: restaurant)
    }

    // Load the direction to a restaurant
    private func loadDirection(to restaurant: Restaurant) {
        let sourceLocation = mapView.userLocation
        let request = MKDirections.Request()
        let startMapItem = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation.coordinate))
        let endMapItem = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))
        request.source = startMapItem
        request.destination = endMapItem
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        let direction = MKDirections(request: request)
        direction.calculate { [weak self] response, error in

            guard error == nil, let route = response?.routes.first else { return }
            DispatchQueue.main.async {
                self?.mapView.addOverlay(route.polyline)
            }
        }
    }
}

// MARK: CoreLocation Protocol Conformance

extension MapViewController: CLLocationManagerDelegate {
    // Gets called when the user updates his authorization status
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Checks the value of the status parameter.
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Asks for the locations
            locationManager?.startUpdatingLocation()
        } else {
            // Request an anthorization only when the user is using the application
            locationManager?.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_: CLLocationManager, didUpdateLocations _: [CLLocation]) {
        // Do Nothing......
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: Map View Protocol Conformance

extension MapViewController: MKMapViewDelegate {
    // Called when the user taps on the map.
    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        // Checks if the selected view on the map is a restaurant.
        guard let restaurant = view.annotation as? Restaurant, let ctrl = tabBarController as? TabBarViewController else { return }
        // Provides the selected restaurant to the tabbar controller
        ctrl.didSelect(restaurant: restaurant)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Using the default system view to display the user`s location.
        if annotation is MKUserLocation {
            return nil
        }

        if annotation is Restaurant {
            // Creates a new view if there is not a view with the same identifier already on the queue.
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)

            annotationView.clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
            annotationView.annotation = annotation

            return annotationView
        }
        return nil
    }

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKPolyline else { return MKCircleRenderer() }
        let polyRender = MKPolylineRenderer(overlay: overlay)
        polyRender.lineWidth = 4.0
        polyRender.strokeColor = UIColor.yellow
        return polyRender
    }
}

// MARK: RestaurantsProviderDelegate Protocol Conformance

extension MapViewController: RestaurantsProviderDelegate {
    func didReceive(restaurants: [Restaurant]) {
        // Receives from the provider a list of restaurants to display.
        self.restaurants = restaurants
    }
}
