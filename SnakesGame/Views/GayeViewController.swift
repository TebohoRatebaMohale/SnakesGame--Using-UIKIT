//
//  GayeViewController.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/04/26.
//

import UIKit
import AVFoundation

class GayeViewController: UIViewController {
    
    @IBOutlet weak var snakeImage: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet var button: UIButton!
    
    var player: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func playButtonClicked(_ sender: UIButton) {
        let nextController = SnakeGameViewController()
        nextController.modalPresentationStyle = .fullScreen
        
        present(nextController, animated: true)
    }
    
    @IBAction func SettingsButtonClicked(_ sender: UIButton) {
        
        let next1Controller = TebohoSettingsViewController()
        next1Controller.modalPresentationStyle = .fullScreen
        present(next1Controller, animated: true)
    }
    
    @IBAction func didTapButton() {
        
        if let player = player, player.isPlaying {
            button.setTitle("Stop", for: .normal)
            player.stop()
        } else {
            button.setTitle("Play", for: .normal)
            let urlString = Bundle.main.path(forResource: "audio", ofType: "mp3")
            
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else {
                    return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                
                guard let player = player else {
                    return
                }
                
                player.numberOfLoops = -1 // Set the number of loops to infinite for continuous playback
                player.play()
            } catch {
                print("Something went wrong")
            }
        }
    }
    
    
}
