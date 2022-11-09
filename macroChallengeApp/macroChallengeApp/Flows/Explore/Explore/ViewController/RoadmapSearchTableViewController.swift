import UIKit

class RoadmapSearchTableViewController: UITableViewController {
    var matchingRoadmaps: [RoadmapDTO] = []
    var roadmaps: [RoadmapDTO] = []
    let designSystem = DefaultDesignSystem.shared
    lazy var userCurrency: String = {
        let userC = self.getUserCurrency()
        return userC
    }()
    weak var coordinator: ExploreCoordinator?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        self.view.backgroundColor = designSystem.palette.backgroundPrimary
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        if currencySymbol == "$" {
            return "U$"
        } else {
            return currencySymbol ?? "U$"
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingRoadmaps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            preconditionFailure("Cell not found")
        }
        
        let roadmap = matchingRoadmaps[indexPath.row]
        cell.title.text = roadmap.name
        if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: roadmap.imageId)) {
            cell.cover.image = cachedImage
        } else {
            cell.cover.image = UIImage(named: "beach0")
        }
        cell.caption.text = "\(roadmap.peopleCount) viajante • \(roadmap.dayCount) dias • \(userCurrency) \(roadmap.budget) mil/pessoa"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            coordinator?.previewRoadmap(roadmapId: matchingRoadmaps[indexPath.row].id)
        } else {
            coordinator?.previewRoadmap(roadmapId: roadmaps[indexPath.row].id)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

extension RoadmapSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
            self.isSearching = true
        } else {
            searchController.searchBar.showsBookmarkButton = true
            self.isSearching = false
        }
        
        guard let searchBarText = searchController.searchBar.text?.lowercased() else { return }
                
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
        })
        
        matchingRoadmaps = roadmaps.filter({ roadmap in
            return roadmap.name.lowercased().contains(searchBarText)
        })
        
        self.tableView.reloadData()
    }
    
}
