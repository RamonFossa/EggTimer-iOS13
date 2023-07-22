//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    
    var isCounting = false
    var selectedButton: UIButton?
    var countNumberMax = 0
    var countNumber = 0
    
    let eggTimes: [String: Int] = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let hardness = sender.currentTitle else { return }
        guard let eggTime = eggTimes[hardness] else { return }
        if !isCounting {
            selectedButton = sender
            self.isCounting = true
            self.countNumber = eggTime
            self.countNumberMax = eggTime
            self.progressView.progress = 1.0
            countDown()
        }
        //        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown()), userInfo: nil, repeats: true) Outra mandeira de fazer um timeLoop
    }
    
    func countDown() {
        if self.countNumber <= 0 {
            self.titleLabel.text = ("It's done!")
            self.isCounting = false
            self.progressView.progress = 0.0
            self.playAlarm()
            return
        }
        
        self.titleLabel.text = ("\(self.countNumber) seconds...")
        self.progressView.progress = Float(countNumber) / Float(countNumberMax)
        self.countNumber -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.countDown()
        }
    }
    
    func playAlarm() {
        playSound(soundURL: "alarm_sound")
    }
    
    func playSound(soundURL: String) {
        let url = Bundle.main.url(forResource: soundURL, withExtension: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
