//tirando os comentários já tem dois pontos de futebol em Poa ali. Tinha colocado também o framework //para
//mapas e a solicitação de autorização do usuário para localização, mas isso é em outra parte do xcode

import UIKit
import MapKit


class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var mapas: MKMapView!
    // @IBOutlet var mapas: MKMapView!
    var gerenciadorLocal = CLLocationManager()
    
    //-30.000728, -51.191491 A BOMBONERA AV.CEARA
    //-29.996852, -51.194481 HD SPORT CENTER RUA LAURO MULLER
    //Rua Dona Margarida -29.999477, -51.193902
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Responsável por gerenciar objeto gerenciador é a própria classe
        gerenciadorLocal.delegate = self
        gerenciadorLocal.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocal.requestWhenInUseAuthorization()
        gerenciadorLocal.startUpdatingLocation()
        
        
        //
        //        let latitude: CLLocationDegrees = -29.999477
        //        let longitude: CLLocationDegrees = -51.193902
        //
        //
        //        let deltaLatitude: CLLocationDegree s = 0.02
        //        let deltaLongitude: CLLocationDegrees = 0.02
        //
        //        let localizacao: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        //
        //        let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpanMake(deltaLatitude, deltaLongitude)
        //
        //        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao,areaVisualizacao)
        //        mapas.setRegion(regiao, animated: true)
        //
        //
        //        let quadra1 = MKPointAnnotation()
        //        quadra1.coordinate.latitude = -30.000728
        //        quadra1.coordinate.longitude = -51.191491
        //        quadra1.title = "A BOMBONERA"
        //        quadra1.subtitle = "Uma grande quadra"
        //
        //        let quadra2 = MKPointAnnotation()
        //        quadra2.coordinate.latitude = -29.996852
        //        quadra2.coordinate.longitude = -51.194481
        //        quadra2.title = "HD SPORT"
        //        quadra2.subtitle = "Ao lado do trensurb!"
        //
        //        mapas.addAnnotation(quadra1)
        //        mapas.addAnnotation(quadra2)
        //
        //
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


