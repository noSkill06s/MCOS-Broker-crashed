//
//  SearchViewController.swift
//  MCOS
//
//  Created by Burhan Cankurt on 30.09.23.
//

import UIKit

class SearchViewController: UIViewController {
    
    weak var delegate: StockSelectionDelegate?
    
    // Array zum Speichern der StockList
    var stockListArray: [StockListStruct] = []
    
    // Array zum Speichern der gefilterten Ergebnisse
    var filteredStockListArray:[StockListStruct] = []
    
    // Einbindung von Searchbar und TableView
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Button: Zurück zur Chartansicht (wechselt wieder zum ChartViewController)
    @IBAction func showChart(_ sender: Any) {
        if let homeViewController = storyboard?.instantiateViewController(identifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Delegate and DataSource before API call
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let fetchStockListAPI = FetchStockListAPI()
        fetchStockListAPI.fetchStockList { [weak self] stockList in
            guard let self = self else { return }
            if let stockList = stockList {
                self.stockListArray = stockList
                self.filteredStockListArray = stockList
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Fehler beim Laden der Daten")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStockListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let stock = filteredStockListArray[indexPath.row]
        cell.textLabel?.text = stock.symbol
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStock = filteredStockListArray[indexPath.row]
        if let symbol = selectedStock.symbol {
            delegate?.stockWasSelected(symbol)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredStockListArray = stockListArray
        } else {
            filteredStockListArray = stockListArray.filter { stock in
                return (stock.symbol?.lowercased().contains(searchText.lowercased()) ?? false) ||
                       (stock.name?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
        tableView.reloadData()
    }
}


