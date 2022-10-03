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
    
    // MARK: Cloud User
    var user: User?
    
    private lazy var fetchResultController: NSFetchedResultsController<RoadmapLocal> = {
        let request: NSFetchRequest<RoadmapLocal> = RoadmapLocal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RoadmapLocal.createdAt, ascending: false)]
        // let sectionSortDescriptor = NSSortDescriptor()
        // request.sortDescriptors = [sectionSortDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: RoadmapRepository.shared.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()

    override func viewDidLoad() {
        // long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        profileView.myRoadmapCollectionView.addGestureRecognizer(longPress)

        self.roadmaps = RoadmapRepository.shared.getRoadmap()
        profileView.roadmaps = self.roadmaps

        super.viewDidLoad()
        profileView.myRoadmapCollectionView.reloadData()
        self.view.backgroundColor = .backgroundPrimary
        self.setupProfileView()
        profileView.bindColletionView(delegate: self, dataSource: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
        self.setContextMenu()
        do {
            try fetchResultController.performFetch()
            self.roadmaps = fetchResultController.fetchedObjects ?? []
        } catch {
            fatalError("Não foi possível atualizar conteúdo")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileView.myRoadmapCollectionView.reloadData()
    }
    
    @objc func profileSettings() {
        coordinator?.settings()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // let newRoadmaps = RoadmapRepository.shared.getRoadmap()
        guard let newRoadmaps = controller.fetchedObjects as? [RoadmapLocal] else { return }
        self.roadmaps = newRoadmaps
        profileView.setup()
        profileView.roadmaps = newRoadmaps
        profileView.myRoadmapCollectionView.reloadData()
        if let user = user {
            // criar funcao para alimentar coreData com os dados da nuvem
        }
    }
    // MARK: Manage Data Cloud
    func getDataCloud() {
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
}
