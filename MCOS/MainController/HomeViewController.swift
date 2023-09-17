//
//  HomeViewController.swift
//  MCOS
//
//  Created by Burhan Cankurt on 16.09.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Instantiierung der Child-ViewControllers aus dem Storyboard
    let childDepotViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepotViewController") as! DepotViewController
    let childWatchlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WatchlistViewController") as! WatchlistViewController
    let childChartViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
    let childTCRViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TCRViewController") as! TCRViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        childDepotViewController.view.isHidden = true
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



