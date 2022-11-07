//
//  EditProfileViewController.swift
//  macroChallengeApp
//
//  Created by Carolina Ortega on 20/09/22.
//

import Foundation
import UIKit
import SnapKit
import PhotosUI

class EditProfileViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let editProfileView = EditProfileView()
    var userLocal: [UserLocal] = []
    let network: NetworkMonitor = NetworkMonitor.shared
    var imagePicker: ImagePicker!
    var access = false

    override func viewDidLoad() {
        super.viewDidLoad()
        network.startMonitoring()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.setupEditProfileView()
        editProfileView.imageProfile.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        editProfileView.editButton.addTarget(self, action: #selector(editPhoto), for: .touchUpInside)
        self.userLocal = UserRepository.shared.getUser()
        self.changeToUserInfo(user: userLocal[0])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized(), style: .plain, target: self, action: #selector(saveProfile))
    }
    
    @objc func saveProfile() {
        network.startMonitoring()
        if !network.isReachable {
            let action = UIAlertController(title: "You are offiline. Can't save", message: nil, preferredStyle: .actionSheet)
            action.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [] _ in
            }))
            present(action, animated: true)
        } else {
            if let newName = editProfileView.nameTextField.text, let newUsernameApp = editProfileView.usernameTextField.text {
                UserRepository.shared.updateName(user: self.userLocal[0], name: newName)
                UserRepository.shared.updateUsernameApp(user: self.userLocal[0], username: newUsernameApp)
                DataManager.shared.putUser(userObj: self.userLocal[0])
            }
            coordinator?.backPage()
        }
    }
    
    func changeToUserInfo(user: UserLocal) {
        let path = user.photoId ?? "icon"
        let imageNew = UIImage(contentsOfFile: SaveImagecontroller.getFilePath(fileName: path))
        self.editProfileView.imageProfile.setBackgroundImage(imageNew, for: .normal) 
        self.editProfileView.setupImage(image: imageNew ?? UIImage(named: "icon")!)
        self.editProfileView.nameTextField.text = user.name
        self.editProfileView.usernameTextField.text = user.usernameApp
    }
    
    @objc func editPhoto(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status != .denied {
                        self.access = true

                    } else {
                        self.access = false
                    }
                })
            } else {
            let authorization = PHPhotoLibrary.authorizationStatus()
            if authorization != .denied {
                self.imagePicker.present(from: (sender as? UIView)!, title: "Que tal alterar sua foto de perfil?".localized())
            } else {
                print("Nao permitido")
            }
        }
    }
}

extension EditProfileViewController {
    func setupEditProfileView() {
        view.addSubview(editProfileView)
        setupConstraints()
    }
    func setupConstraints() {
        editProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let imageNew = image {
            self.editProfileView.setupImage(image: imageNew)
            UserRepository.shared.updatePhotoId(user: userLocal[0],
                                                photoId: SaveImagecontroller.saveToFiles(image: imageNew))
        }
    }
}
