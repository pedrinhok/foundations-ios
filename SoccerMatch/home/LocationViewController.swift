import UIKit

import MapKit

class LocationViewController: UIViewController {

    var match: Match!
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var address: StandardTextField!
    @IBOutlet weak var name: StandardTextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        currentPosition()
    }

    func currentPosition() {
        guard let location = locationManager.location else { return }

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first {
                    self.address.text = placemark.name
                }
            }
        }

        var region = MKCoordinateRegion()
        region.center.latitude = location.coordinate.latitude
        region.center.longitude = location.coordinate.longitude
        region.span.longitudeDelta = 0.015

        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }

}
