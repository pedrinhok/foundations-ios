import UIKit

class MyMatchesViewController: UIViewController {
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
