import UIKit

class NewMatchViewController: UIViewController {

    var match: Match!

    @IBOutlet weak var location: CustomButton!
    @IBOutlet weak var schedule: CustomButton!
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
        construct()
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

    func construct() {
        if let text = match.location {
            location.setTitle(text, for: .normal)
            location.setTitle(text, for: .selected)
        }
        if let day = match.day {
            schedule.setTitle(day, for: .normal)
            schedule.setTitle(day, for: .selected)
        }
        type.text = match.type
        vacancies.text = match.vacancies
        price.text = match.price
        desc.text = match.desc
    }

    func showMessage(title: String, message: String, completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true)
            if let completion = completion { completion() }
        }
        alert.addAction(action)

        present(alert, animated: true)
    }

    @IBAction func unwindNewMatch(segue: UIStoryboardSegue) {}

    @IBAction func clickLocation(_ sender: CustomButton) {
        performSegue(withIdentifier: "gotoLocation", sender: nil)
    }

    @IBAction func clickSchedule(_ sender: CustomButton) {
        performSegue(withIdentifier: "gotoSchedule", sender: nil)
    }

    @IBAction func clickCreate(_ sender: StandardButton) {

        guard let location = match.location, location != "" else {
            showMessage(title: "Wops", message: "You must set the location!")
            return
        }
        guard let x = match.x, x != 0.0 else {
            showMessage(title: "Wops", message: "You must set the location!")
            return
        }
        guard let y = match.y, y != 0.0 else {
            showMessage(title: "Wops", message: "You must set the location!")
            return
        }

        guard let day = match.day, day != "" else {
            showMessage(title: "Wops", message: "You must set the schedule!")
            return
        }
        guard let start = match.start, start != "" else {
            showMessage(title: "Wops", message: "You must set the schedule!")
            return
        }
        guard let finish = match.finish, finish != "" else {
            showMessage(title: "Wops", message: "You must set the schedule!")
            return
        }

        guard let type = type.text, type != "" else {
            showMessage(title: "Wops", message: "You must set the match type!")
            return
        }
        match.type = type

        guard let vacancies = vacancies.text, vacancies != "" else {
            showMessage(title: "Wops", message: "You must set the vacancies!")
            return
        }
        guard let vacanciesInt = Int(vacancies), vacanciesInt > 0 else {
            showMessage(title: "Wops", message: "You must set a valid vacancies (>= 1)!")
            return
        }
        match.vacancies = vacancies

        guard let price = price.text, price != "" else {
            showMessage(title: "Wops", message: "You must set the price!")
            return
        }
        guard let priceInt = Int(price), priceInt >= 0 else {
            showMessage(title: "Wops", message: "You must set a valid price (>= 0)!")
            return
        }
        match.price = price

        guard let desc = desc.text, desc != "" else {
            showMessage(title: "Wops", message: "You must set the description!")
            return
        }
        match.desc = desc

        MatchService.create(match) { (error) in
            if let error = error {
                self.showMessage(title: "Wops", message: error)
            } else {
                self.showMessage(title: "Match successfully created!", message: "") {
                    self.performSegue(withIdentifier: "unwindHome", sender: nil)
                }
            }
        }

    }

}

extension NewMatchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
