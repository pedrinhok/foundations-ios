import UIKit

class NewMatchViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var type: StandardTextField!
    @IBOutlet weak var vacancies: StandardTextField!
    @IBOutlet weak var price: StandardTextField!
    @IBOutlet weak var desc: StandardTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        type.delegate = self
        vacancies.delegate = self
        price.delegate = self
        desc.delegate = self

        match = Match()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        type.text = match.type
        vacancies.text = match.vacancies
        price.text = match.price
        desc.text = match.desc
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "gotoLocation":
            guard let vc = segue.destination as? LocationViewController else { return }
            vc.match = match
            return

        case "gotoSchedule":
            guard let vc = segue.destination as? ScheduleViewController else { return }
            vc.match = match
            return

        case .none, .some(_):
            return
        }
    }

    @IBAction func unwindNewMatch(segue: UIStoryboardSegue) {}

    @IBAction func clickLocation(_ sender: StandardButton) {
        performSegue(withIdentifier: "gotoLocation", sender: nil)
    }

    @IBAction func clickSchedule(_ sender: StandardButton) {
        performSegue(withIdentifier: "gotoSchedule", sender: nil)
    }

}

extension NewMatchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
