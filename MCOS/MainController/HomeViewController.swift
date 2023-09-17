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
    
    // Instantiierung der Child-ViewControllers aus dem Storyboard
    let childDepotViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepotViewController") as! DepotViewController
    let childWatchlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WatchlistViewController") as! WatchlistViewController
    let childChartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
    let childTCRViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TCRViewController") as! TCRViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pickerview Initialisierung
        pickerview.delegate = self
        pickerview.dataSource = self
        
        // Schritt 1: Childs hinzufügen
        addChild(childDepotViewController)
        addChild(childWatchlistViewController)
        addChild(childChartViewController)
        addChild(childTCRViewController)
        
        // Schritt 2: Views hinzufügen
        view.addSubview(childDepotViewController.view)
        view.addSubview(childWatchlistViewController.view)
        view.addSubview(childChartViewController.view)
        view.addSubview(childTCRViewController.view)
        
        // Schritt 3: didMove aufrufen
        childDepotViewController.didMove(toParent: self)
        childWatchlistViewController.didMove(toParent: self)
        childChartViewController.didMove(toParent: self)
        childTCRViewController.didMove(toParent: self)
        
        // Schritt 4: Anfangszustand festlegen
        childDepotViewController.view.isHidden = false
        childWatchlistViewController.view.isHidden = true
        childChartViewController.view.isHidden = true
        childTCRViewController.view.isHidden = true
        
        // Schritt 5: Layout festlegen
        childDepotViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
        childWatchlistViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
        childChartViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
        childTCRViewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 2)
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


