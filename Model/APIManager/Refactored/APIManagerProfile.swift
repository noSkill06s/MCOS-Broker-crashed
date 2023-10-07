//
//  APIManagerProfile.swift
//  MCOS
//
//  Created by Burhan Cankurt on 06.10.23.
//

import Foundation

class APIManagerProfile {

    weak var delegate: StockProfileUpdatable? // Protokoll-Referenz statt spezifischer ViewController

    init(delegate: StockProfileUpdatable) {
        self.delegate = delegate
    }

    func fetchAPIManagerProfile(for symbol: String, completion: @escaping (Result<StockProfile, Error>) -> Void) {
        APIServiceProfile.shared.fetchAPIServiceProfile(for: symbol) { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.delegate?.updateProfileData(profile)
                }
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
            }
        }
    }
}
