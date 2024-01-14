//
//  Audio.swift
//  CinemaTix
//
//  Created by Eky on 12/12/23.
//

import Foundation
import AVFoundation

class Audio {
    
    private var audioPlayer: AVAudioPlayer?
    
    func loadNotification() {
        if let path = Bundle.main.path(forResource: "NotifSound", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Error setting up audio session: \(error.localizedDescription)")
            }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        }
    }
    
    func playAudio() {
        audioPlayer?.play()
    }
}
