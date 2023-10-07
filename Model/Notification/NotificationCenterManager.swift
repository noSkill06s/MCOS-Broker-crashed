//
//  NotificationCenterManager.swift
//  MCOS
//
//  Created by Burhan Cankurt on 05.10.23.
//

// NotificationCenterManager.swift

import Foundation

class NotificationCenterManager {
    
    static let shared = NotificationCenterManager()
    
    private init() {} // Singleton

    // Benutzerdefinierte Benachrichtigungs-Name
    let watchlistUpdated = Notification.Name("watchlistUpdated")

    // Methode zum Senden von Benachrichtigungen
    func postWatchlistUpdated() {
        NotificationCenter.default.post(name: watchlistUpdated, object: nil)
    }

    // Methode zum Empfangen von Benachrichtigungen
    func observeWatchlistUpdates(in object: Any, using block: @escaping () -> Void) {
        NotificationCenter.default.addObserver(forName: watchlistUpdated, object: nil, queue: .main) { _ in
            block()
        }
    }
}

