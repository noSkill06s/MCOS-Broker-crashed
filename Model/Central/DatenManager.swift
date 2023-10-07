//
//  DataManager.swift
//  MCOS
//
//  Created by Burhan Cankurt on 05.10.23.
//

import Foundation

class DatenManager {
    static let shared = DatenManager() // Singleton Instanz
    
    var watchlistArray: [String] = [] // Zentrales Array für die Watchlist
    
    private init() {
        // Privater Initializer, damit keine weitere Instanz erstellt werden kann
    }
    // Weitere Methoden und Variablen können hier hinzugefügt werden
}
