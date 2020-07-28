//
//  ViewController.swift
//  CircularTimerExamples
//
//  Created by Fábio Maciel de Sousa on 22/07/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import UIKit
import CircularTimer

class ViewController: UIViewController {
    @IBOutlet weak var timer: CircleTimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.timeTracker = timer
        }
        timer.setTimerValue(120)
    }

    @IBAction func start(_ sender: Any) {
        timer.startTimer()
    }
    
    @IBAction func pause(_ sender: Any) {
        timer.pauseTimer()
    }
    
    @IBAction func stop(_ sender: Any) {
        timer.stopTimer()
    }
    
}

