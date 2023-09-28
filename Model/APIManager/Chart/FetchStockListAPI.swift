//
//  FetchStockListAPI.swift
//  MCOS
//
//  Created by Burhan Cankurt on 30.09.23.
//

import UIKit

class FetchStockListAPI: UIViewController {
    
    // Speichern der abgerufenen StockListen
    var stockListArray: [StockListStruct]?
    
    // Netzwerkabfrage
    func fetchStockList(completion: @escaping([StockListStruct]?) -> Void) {
        print("FetchstockListAPI wurde aufgerufen")
        guard let url = URL(string: "https://financialmodelingprep.com/api/v3/stock/list?apikey=87508d18defb2ad368deda0763edaaab") else {return}
        // Starte Netzwerkabfrage "URL" als Parameter
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Fehler:\(error)")
                return
            }
            guard let data = data else { return }
            do {
                let stockListData = try JSONDecoder().decode([StockListStruct].self, from: data)
                self.stockListArray = stockListData
                completion(stockListData)  // Hier rufst du den Abschlussblock auf
            } catch let jsonError {
                print("Fehler beim Decodieren StockList Netzwerkarbfrage: \(jsonError)")
                completion(nil)  // Auch hier solltest du den Abschlussblock aufrufen, aber mit `nil`
            }
        }
        // Starte Netzwerkabfrage
        task.resume()
    }
}
