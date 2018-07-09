import UIKit

class MyMatchesViewController: UIViewController {

    var matchesCreated: [Match] = []

    @IBOutlet weak var collectionCreated: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        collectionCreated.dataSource = self

        getMatches()
    }

    func getMatches() {
        MatchService.myCreated { (matches) in
            for match in matches {
                self.matchesCreated.append(match)
            }
            self.collectionCreated.reloadSections(IndexSet(integer: 0))
        }
    }

}

extension MyMatchesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (collectionView.tag) {
        case 0:
            return matchesCreated.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (collectionView.tag) {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCreatedCell", for: indexPath) as! MatchCollectionCell
            
            let match = matchesCreated[indexPath.row]
            
            cell.desc.text = match.desc
            
            return cell
        default:
            return MatchCollectionCell()
        }
    }

}
