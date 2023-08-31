//
//  SoundManager.swift
//  MiniGames
//
//  Created by Teboho Mohale on 2023/05/12.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer: AVAudioPlayer?
    
    enum soundEffect {
        case checkCollision
        case checkFoodCollision
    }
    
    static func playSound(_ effect:soundEffect) {
        var soundFilename = ""
        
        switch effect {
        case .checkCollision:
            soundFilename = "cardflip"
        case .checkFoodCollision:
            soundFilename = "shuffle"
        }
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        guard bundlePath != nil else{
            print("Couldn't play sound file \(soundFilename) in the bundle")
            return
        }
        //create URL
        let soundURL = URL(fileURLWithPath: bundlePath!)
        do{
            //create audio player
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
            
        }catch{
            print("Couldn't create the audio player object for sound file \(soundFilename)")
            
        }
        
        
    }
}
