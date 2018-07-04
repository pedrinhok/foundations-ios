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

        name.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(selectPosition))
        map.addGestureRecognizer(tap)

        construct()
    }

    func construct() {
        guard let location = match.location else { return }

        var c: CLLocationCoordinate2D
        if let x = location.x, let y = location.y {
            c = CLLocationCoordinate2D(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y))
        } else {
            guard let current = locationManager.location else { return }
            c = current.coordinate
        }
        updateAddress(c)
        map.removeAnnotations(map.annotations)
        annotation.coordinate = c
        map.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: c, span: span)
        map.setRegion(region, animated: true)

        name.text = location.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "unwindNewMatch":
            guard let vc = segue.destination as? NewMatchViewController else { return }
            vc.match = match
            return

        case .none, .some(_):
            return
        }
    }

    @objc func selectPosition(tap: UITapGestureRecognizer) {
        let p = tap.location(in: map)
        let coord = map.convert(p, toCoordinateFrom: map)
        updateAddress(coord)
        map.removeAnnotations(map.annotations)
        annotation.coordinate = coord
        map.addAnnotation(annotation)
    }

    func updateAddress(_ coord: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first {
                    self.address.text = placemark.name
                }
            }
        }
    }

    @IBAction func clickUpdate(_ sender: StandardButton) {
        match.location!.name = name.text
        match.location!.x = Double(annotation.coordinate.latitude)
        match.location!.y = Double(annotation.coordinate.longitude)
        performSegue(withIdentifier: "unwindNewMatch", sender: nil)
    }

}

extension LocationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
