//
//  ProfileViewController.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit
import CoreData

protocol SignOutDelegate: AnyObject {
    func reloadScreenStatus()
}

class ProfileViewController: UIViewController, NSFetchedResultsControllerDelegate {
    weak var coordinator: ProfileCoordinator?
    weak var exploreCoordinator: ExploreCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let profileView = ProfileView()
    var roadmaps: [RoadmapLocal] = []
    var dataManager = DataManager.shared
    let network: NetworkMonitor = NetworkMonitor.shared
    
    private lazy var fetchResultController: NSFetchedResultsController<RoadmapLocal> = {
        let request: NSFetchRequest<RoadmapLocal> = RoadmapLocal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RoadmapLocal.createdAt, ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: RoadmapRepository.shared.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()

    override func loadView() {
        view = profileView
    }
    override func viewDidLoad() {
        self.roadmaps = RoadmapRepository.shared.getRoadmap()
        profileView.roadmaps = self.roadmaps
        
        super.viewDidLoad()
        
        self.network.startMonitoring()
        self.setupProfileView()
        self.setContextMenu()
        
        do {
            try fetchResultController.performFetch()
            self.roadmaps = fetchResultController.fetchedObjects ?? []
        } catch {
            fatalError("Não foi possível atualizar conteúdo")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        if !UserDefaults.standard.bool(forKey: "isUserLoggedIn") { coordinator?.startLogin() }
        let user = UserRepository.shared.getUser()
        if user.isEmpty {
            self.profileView.getName().text = "Usuário"
            self.profileView.getUsernameApp().text = "Usuário"
            self.getDataCloud()
        } else {
            self.changeToUserInfo(user: user[0])
        }
    }
    
    @objc func profileSettings() {
        coordinator?.settings(profileVC: self)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // let newRoadmaps = RoadmapRepository.shared.getRoadmap()
        guard let newRoadmaps = controller.fetchedObjects as? [RoadmapLocal] else { return }
        self.roadmaps = newRoadmaps
        profileView.setup()
        profileView.roadmaps = newRoadmaps
        profileView.myRoadmapCollectionView.reloadData()
        profileView.myRoadmapCollectionView.layoutIfNeeded()
        profileView.updateConstraintsCollection()
    }
    
    // MARK: Manage Data Cloud
    func getDataCloud() {
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            DataManager.shared.getUser(username: userID, { user in
                let userLocal = UserRepository.shared.createUser(user: user)
                self.changeToUserInfo(user: userLocal)
            })
        }
    }
    
    func changeToUserInfo(user: UserLocal) {
        self.profileView.getName().text = user.name
        self.profileView.getUsernameApp().text = "@" + user.usernameApp!
        self.profileView.getTable().reloadData()
        let path = user.photoId
        let imageNew = UIImage(contentsOfFile: SaveImagecontroller.getFilePath(fileName: path ?? "icon"))
        self.profileView.setupImage(image: imageNew ?? UIImage(named: "icon")!)
    }
}

extension ProfileViewController: SignOutDelegate {
    func reloadScreenStatus() {
        self.coordinator?.backPage()
    }
}
