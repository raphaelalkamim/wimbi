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
    var roadmaps: [RoadmapDTO] = []
    var dataManager = DataManager.shared
    let network: NetworkMonitor = NetworkMonitor.shared
    let tutorialEnable = UserDefaults.standard.bool(forKey: "tutorialProfile")
    var user = UserRepository.shared.getUser()

    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        self.getDataCloud()
        profileView.roadmaps = self.roadmaps
        
        super.viewDidLoad()
        
        self.network.startMonitoring()
        self.setupProfileView()

        profileView.userImage.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        profileView.bindColletionView(delegate: self, dataSource: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(profileSettings))
        self.setContextMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SignInWithAppleManager.shared.checkUserStatus()

        if !UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            coordinator?.startLogin()
            
        } else {
            profileView.tutorialTitle.addTarget(self, action: #selector(tutorial), for: .touchUpInside)
            if tutorialEnable == false {
                self.tutorialTimer()
            }
        }
        if user.isEmpty {
            self.profileView.getName().text = "Usuário"
            self.profileView.getUsernameApp().text = "Usuário"
            self.getDataCloud()
        } else {
            guard let user = user.first else { return }
            self.getDataCloud()
            self.changeToUserInfo(user: user)
        }
    }
    
    @objc func profileSettings() {
        coordinator?.settings(profileVC: self)
    }
    
    @objc func editProfile() {
        coordinator?.startEditProfile()
    }
    
    func tutorialTimer() {
        UserDefaults.standard.set(true, forKey: "tutorialProfile")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.profileView.tutorialView.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.profileView.tutorialView.removeFromSuperview()
        }
    }
    
    @objc func tutorial() {
        UserDefaults.standard.set(true, forKey: "tutorialProfile")
        profileView.tutorialView.removeFromSuperview()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.getDataCloud()
        profileView.setup()
        profileView.roadmaps = self.roadmaps
        profileView.myRoadmapCollectionView.reloadData()
        profileView.myRoadmapCollectionView.layoutIfNeeded()
        profileView.updateConstraintsCollection()
    }
    
    func changeToUserInfo(user: UserLocal) {
        self.profileView.getName().text = user.name
        self.profileView.getUsernameApp().text = "@" + (user.usernameApp ?? "newUser") 
        self.profileView.getTable().reloadData()
        if var path = user.photoId {
            let imageNew = UIImage(contentsOfFile: SaveImagecontroller.getFilePath(fileName: path))
            if imageNew == nil {
                if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: path)) {
                    self.profileView.setupImage(image: cachedImage)
                } else {
                    FirebaseManager.shared.getImage(category: 1, uuid: path) { image in
                        self.profileView.setupImage(image: image)
                        path = path.replacingOccurrences(of: ".jpeg", with: "")
                        _ = SaveImagecontroller.saveToFiles(image: image, UUID: path)
                    }
                }
            } else {
                self.profileView.setupImage(image: imageNew ?? UIImage(named: "icon")!)
            }
        }
    }
    
    // MARK: Manage Data Cloud
    func getDataCloud() {
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            DataManager.shared.getUser(username: userID, { user in
                let userLocal = UserRepository.shared.createUser(user: user)
                self.changeToUserInfo(user: userLocal)
                for roadmap in user.userRoadmap {
                    self.roadmaps.append(roadmap.roadmap)
                }
                
            })
        }
    }
}

extension ProfileViewController: SignOutDelegate {
    func reloadScreenStatus() {
        self.coordinator?.backPage()
    }
}
