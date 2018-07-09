import UIKit

import MapKit

class LocationViewController: UIViewController {

    var match: Match!

    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var ann = MKPointAnnotation()

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

    func construct() {
        var c: CLLocationCoordinate2D
        if let x = match.x, let y = match.y {
            c = CLLocationCoordinate2D(latitude: CLLocationDegrees(x), longitude: CLLocationDegrees(y))
        } else {
            guard let current = locationManager.location else { return }
            c = current.coordinate
        }
        updateAddress(c)
        map.removeAnnotations(map.annotations)
        ann.coordinate = c
        map.addAnnotation(ann)
        let span = MKCoordinateSpanMake(0.008, 0.008)
        let region = MKCoordinateRegion(center: c, span: span)
        map.setRegion(region, animated: true)
        
        name.text = match.location
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

    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Wops", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }

    @IBAction func clickUpdate(_ sender: StandardButton) {

        guard let name = name.text, name != "" else {
            showMessage("You must set the name!")
            return
        }
        match.location = name

        let c = ann.coordinate
        match.x = Double(c.latitude)
        match.y = Double(c.longitude)

        performSegue(withIdentifier: "unwindNewMatch", sender: nil)
    }

    @objc func selectPosition(tap: UITapGestureRecognizer) {
        let p = tap.location(in: map)
        let c = map.convert(p, toCoordinateFrom: map)
        updateAddress(c)
        map.removeAnnotations(map.annotations)
        ann.coordinate = c
        map.addAnnotation(ann)
    }

}

extension LocationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
