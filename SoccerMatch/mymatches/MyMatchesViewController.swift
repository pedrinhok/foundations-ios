import UIKit

class MyMatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var matchesView: UITableView!
    
    var matches = ["MATCHES CREATED BY ME", "MATCHES I WANNA PLAY"]
    
    override func viewDidLoad() {
        matchesView.delegate = self
        matchesView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return matches[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = matchesView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        cell.layer.cornerRadius = 8 // ?? arredondar arestas 
        
        return cell
    }
    
    @IBOutlet weak var labelTest: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var matches: String = ""
        
        SubscribeService.get() { (data) in
            
            for subscription in data {
                
                MatchService.getMatch(matchId: subscription) { (match) in
                    guard let match = match else { return }
                    
                    guard let desc = match.desc else { return }
                    matches += "\(desc) "
                    self.labelTest.text = matches
                }
            }
        }
    }
}
