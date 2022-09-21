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
    
    private lazy var fetchResultController: NSFetchedResultsController<RoadmapLocal> = {
        let request: NSFetchRequest<RoadmapLocal> = RoadmapLocal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RoadmapLocal.name, ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: RoadmapRepository.shared.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .backgroundPrimary
        self.setupProfileView()
        
        profileView.bindColletionView(delegate: self, dataSource: self)
        profileView.myRoadmapCollectionView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
        
        profileView.addButton.addTarget(self, action: #selector(addAction), for: .touchDown)
        
        do {
            try fetchResultController.performFetch()
            self.roadmaps = fetchResultController.fetchedObjects ?? []
        } catch {
            fatalError("Não foi possível atualizar conteúdo")
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
        profileView.roadmaps = newRoadmaps
        profileView.myRoadmapCollectionView.reloadData()
    }
}
