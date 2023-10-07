//
//  APISerivceProfile.swift
//  MCOS
//
//  Created by Burhan Cankurt on 06.10.23.
//

import Foundation

class APIServiceProfile {
    static let shared = APIServiceProfile() // Singleton
    
    private init() { }
    
    func fetchAPIServiceProfile(for symbol: String, completion: @escaping (Result<StockProfile, Error>) -> Void) {
        // apiKey: Der API-Schlüssel für den API-Zugriff
        let apiKey = "87508d18defb2ad368deda0763edaaab"
        
        // url: Die vollständige URL für den API-Aufruf
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(symbol)?apikey=\(apiKey)") else {
            // Fehlerbehandlung für ungültige URL
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        // task: Das URLSessionDataTask-Objekt, das den API-Aufruf ausführt
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // error: Fehler, der während des API-Aufrufs aufgetreten ist
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // data: Die vom API-Aufruf zurückgegebenen Daten
            if let data = data {
                do {
                    // decoder: Ein JSONDecoder-Objekt zum Dekodieren der JSON-Daten
                    let decoder = JSONDecoder()
                    
                    // stockProfile: Das dekodierte StockProfile-Objekt
                    let stockProfile = try decoder.decode([StockProfile].self, from: data)
                    
                    // Das erste StockProfile-Objekt aus dem Array
                    guard let profile = stockProfile.first else {
                        completion(.failure(NSError(domain: "No profile found", code: -1, userInfo: nil)))
                        return
                    }
                    
                    // Erfolgreiche Rückgabe des StockProfile-Objekts
                    completion(.success(profile))
                } catch {
                    // Fehlerbehandlung für Dekodierungsfehler
                    completion(.failure(error))
                }
            }
        }
        
        // Startet den API-Aufruf
        task.resume()
    }
}
