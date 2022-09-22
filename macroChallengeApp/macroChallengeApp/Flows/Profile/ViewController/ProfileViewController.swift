//
//  ProfileViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, NSFetchedResultsControllerDelegate {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let profileView = ProfileView()
    var roadmaps: [RoadmapLocal] = []
    var isConected = false
    
    private lazy var fetchResultController: NSFetchedResultsController<RoadmapLocal> = {
        let request: NSFetchRequest<RoadmapLocal> = RoadmapLocal.fetchRequest()
        //request.sortDescriptors = [NSSortDescriptor(keyPath: \RoadmapLocal.createdAt, ascending: false)]
        let sectionSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sectionSortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: RoadmapRepository.shared.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupProfileView()
        
        profileView.bindColletionView(delegate: self, dataSource: self)
        profileView.myRoadmapCollectionView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
        
        profileView.addButton.addTarget(self, action: #selector(addAction), for: .touchDown)
        profileView.myRoadmapCollectionView.reloadData()
        do {
            try fetchResultController.performFetch()
            self.roadmaps = fetchResultController.fetchedObjects ?? []
        } catch {
            fatalError("Não foi possível atualizar conteúdo")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            DataManager.shared.getUser(username: userID, { user in
                self.user = user
                self.profileView.getName().text = user.name
                self.profileView.getUsernameApp().text = "@\(user.usernameApp)"
                self.profileView.getTable().reloadData()
                self.profileView.getImage().image = UIImage(named: user.photoId)
            })
        }
    }
    
    @objc func profileSettings() {
        coordinator?.settings()
    }
    
    @objc func addAction() {
        coordinator?.newRoadmap()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let newRoadmaps = RoadmapRepository.shared.getRoadmap()
        self.roadmaps = newRoadmaps
        self.roadmaps = newRoadmaps.reversed()
        profileView.roadmaps = newRoadmaps
        profileView.myRoadmapCollectionView.reloadData()
    }
}
