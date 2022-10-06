import UIKit

class RoadmapSearchTableViewController: UITableViewController {
    var matchingRoadmaps: [RoadmapDTO] = []
    var roadmaps: [RoadmapDTO] = []
    let designSystem = DefaultDesignSystem.shared
    weak var coordinator: ExploreCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        self.view.backgroundColor = designSystem.palette.backgroundPrimary
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
        cell.cover.image = UIImage(named: roadmap.imageId)
        cell.caption.text = "\(roadmap.peopleCount) viajante • \(roadmap.dayCount) dias • R$ \(roadmap.budget) mil/pessoa"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.previewRoadmap(roadmapId: roadmaps[indexPath.row].id)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

extension RoadmapSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchController.searchBar.showsBookmarkButton = false
        } else {
            searchController.searchBar.showsBookmarkButton = true
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
