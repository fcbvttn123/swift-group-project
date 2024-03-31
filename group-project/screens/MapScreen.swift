import UIKit
// Created by David
import CoreLocation
import MapKit

class MapScreen: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    // Created by David
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 43.655787, longitude: -79.739534)
    let regionRadius: CLLocationDistance = 1000
    var routeSteps  = ["Enter a destination to see the steps"] as NSMutableArray

    @IBOutlet var myMapView : MKMapView!
    @IBOutlet var tbLocEntered: UITextField!
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0;
        return renderer
    }
    
    @IBAction func findNewLocation(sender : Any) {
        let locEnteredText = tbLocEntered.text
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locEnteredText!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                self.centerMapOnLocation(location: newLocation)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = placemark.name
                self.myMapView.addAnnotation(dropPin)
                self.myMapView.selectAnnotation( dropPin, animated: true)
                
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate,  addressDictionary: nil))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                request.requestsAlternateRoutes = false
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate (completionHandler: {
                    [unowned self] response, error in
                    
                    for route in (response?.routes)! {
                        self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                        self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        self.routeSteps.removeAllObjects()
                        for step in route.steps {
                            self.routeSteps.add(step.instructions)
                            
                            //self.myTableView.reloadData();
                        }
                        
                    }
                })
            }
        })
    }
    
    // Created by David
    // This code is used for keyboard configure for text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Created by David
        // This code is used for map
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Starting at Sheridan College"
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation( dropPin, animated: true)
    }

}
