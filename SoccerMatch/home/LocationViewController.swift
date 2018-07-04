import UIKit

import MapKit

class LocationViewController: UIViewController {

    var match: Match!
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var annotation = MKPointAnnotation()

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var address: StandardTextField!
    @IBOutlet weak var name: StandardTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectPosition))
        map.addGestureRecognizer(tap)

        currentPosition()
    }

    func currentPosition() {
        guard let location = locationManager.location else { return }
        updateAddress(location)

        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }

    @objc func selectPosition(tap: UITapGestureRecognizer) {
        let point = tap.location(in: map)
        let coordinate = map.convert(point, toCoordinateFrom: map)

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        updateAddress(location)

        map.removeAnnotations(map.annotations)
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
    }

    func updateAddress(_ location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first {
                    self.address.text = placemark.name
                }
            }
        }
    }

}
