//
//  SettingsViewController.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/05/09.
//

import UIKit

class TebohoSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Settings"
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = closeButton
        
        // Add settings options here...
        let soundEffectsSwitch = UISwitch()
        soundEffectsSwitch.isOn = true
//        soundEffectsSwitch.addTarget(self, action: #selector(soundEffectsSwitchValueChanged), for: .valueChanged)
        view.addSubview(soundEffectsSwitch)

        // Set up constraints for soundEffectsSwitch
        soundEffectsSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            soundEffectsSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            soundEffectsSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsViewController = TebohoSettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
