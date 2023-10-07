//
//  WatchlistTimeManagerViewController.swift
//  MCOS
//
//  Created by Burhan Cankurt on 05.10.23.
//

import UIKit

class WatchlistTimeManager {
    var apiManagerProfile: APIManagerProfile?
    
    var updateTimer: Timer?
    
    init(apiManagerProfile: APIManagerProfile?) {
        self.apiManagerProfile = apiManagerProfile
    }

    func startTimers() {
        updateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWatchlistProfiles), userInfo: nil, repeats: true)
    }

    func stopTimers() {
        updateTimer?.invalidate()
    }

    @objc func updateWatchlistProfiles() {
        // Hier rufen Sie die Methode zum Aktualisieren der Profile auf
    }
}
