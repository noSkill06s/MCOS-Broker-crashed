//
//  HomeViewController.swift
//  MCOS
//
//  Created by Burhan Cankurt on 16.09.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Einbindung Pickerview
    @IBOutlet var pickerview: UIPickerView!
    
    // Initialisierung der Child-ViewControllers aus dem Storyboard
    var childDepotViewController: DepotViewController!
    var childWatchlistViewController: WatchlistViewController!
    var childChartViewController: ChartViewController!
    var childTCRViewController: TCRViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pickerview Initialisierung
        pickerview.delegate = self
        pickerview.dataSource = self
        
        setupChildViewControllers(for: self)
    }
}

// MARK: - UIPickerViewDataSource
extension HomeViewController: UIPickerViewDataSource {
    // Pickerview anzahl Spalten
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Pickverview anzahl Zeilen
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4  // Weil Sie 4 verschiedene Child-ViewControllers haben
    }
}

// MARK: - UIPickerViewDelegate
extension HomeViewController: UIPickerViewDelegate {
    // Pickerview zeilen Namen
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let options = ["Depot", "Watchlist", "Chart", "TCR"]
        return options[row]
    }

    // Pickerview ausgewählte Zeile
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Hier bestimmen Sie, welcher Child-ViewController angezeigt wird, basierend auf der ausgewählten Zeile.
        switch row {
        case 0:
            childDepotViewController.view.isHidden = false
            childWatchlistViewController.view.isHidden = true
            childChartViewController.view.isHidden = true
            childTCRViewController.view.isHidden = true
        case 1:
            childDepotViewController.view.isHidden = true
            childWatchlistViewController.view.isHidden = false
            childChartViewController.view.isHidden = true
            childTCRViewController.view.isHidden = true
        case 2:
            childDepotViewController.view.isHidden = true
            childWatchlistViewController.view.isHidden = true
            childChartViewController.view.isHidden = false
            childTCRViewController.view.isHidden = true
        case 3:
            childDepotViewController.view.isHidden = true
            childWatchlistViewController.view.isHidden = true
            childChartViewController.view.isHidden = true
            childTCRViewController.view.isHidden = false
        default:
            break
        }
    }
}


