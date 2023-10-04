//
//  ChildViewControllerManager.swift
//  MCOS
//
//  Created by Burhan Cankurt on 20.09.23.
//

import UIKit

func setupChildViewControllers(for parentVC: HomeViewController) {
    
    // Schritt 1: Instantiierung der Child-ViewControllers aus dem Storyboard
    if let depotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DepotViewController") as? DepotViewController {
        parentVC.childDepotViewController = depotVC
    } else {
        fatalError("Failed to instantiate DepotViewController from storyboard")
    }
    
    if let watchlistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WatchlistViewController") as? WatchlistViewController {
        parentVC.childWatchlistViewController = watchlistVC
    } else {
        fatalError("Failed to instantiate WatchlistViewController from storyboard")
    }
    
    if let chartVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController {
        parentVC.childChartViewController = chartVC
    } else {
        fatalError("Failed to instantiate ChartViewController from storyboard")
    }
    
    if let tcrVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TCRViewController") as? TCRViewController {
        parentVC.childTCRViewController = tcrVC
    } else {
        fatalError("Failed to instantiate TCRViewController from storyboard")
    }
    
    // Schritt 1: Childs hinzufügen
    parentVC.addChild(parentVC.childDepotViewController)
    parentVC.addChild(parentVC.childWatchlistViewController)
    parentVC.addChild(parentVC.childChartViewController)
    parentVC.addChild(parentVC.childTCRViewController)
    
    // Schritt 2: Views hinzufügen
    parentVC.view.addSubview(parentVC.childDepotViewController.view)
    parentVC.view.addSubview(parentVC.childWatchlistViewController.view)
    parentVC.view.addSubview(parentVC.childChartViewController.view)
    parentVC.view.addSubview(parentVC.childTCRViewController.view)
    
    // Schritt 3: didMove aufrufen
    parentVC.childDepotViewController.didMove(toParent: parentVC)
    parentVC.childWatchlistViewController.didMove(toParent: parentVC)
    parentVC.childChartViewController.didMove(toParent: parentVC)
    parentVC.childTCRViewController.didMove(toParent: parentVC)
        
    // Schritt 4: ChildViewController View festlegen
    let safeAreaTopInset = parentVC.view.safeAreaInsets.top
    let height = (parentVC.view.bounds.height - safeAreaTopInset) * 0.85

    let yPosition = safeAreaTopInset

    // Schritt 5: Größe und Position für childDepotViewController
    parentVC.childDepotViewController.view.frame = CGRect(
        x: 0,
        y: yPosition,
        width: parentVC.view.bounds.width,
        height: height
    )

    // Schritt 6: Größe und Position für childWatchlistViewController
    parentVC.childWatchlistViewController.view.frame = CGRect(
        x: 0,
        y: yPosition,
        width: parentVC.view.bounds.width,
        height: height
    )

    // Schritt 6: Größe und Position für childChartViewController
    parentVC.childChartViewController.view.frame = CGRect(
        x: 0,
        y: yPosition,
        width: parentVC.view.bounds.width,
        height: height
    )

    // Schritt 6: Größe und Position für childTCRViewController
    parentVC.childTCRViewController.view.frame = CGRect(
        x: 0,
        y: yPosition,
        width: parentVC.view.bounds.width,
        height: height
    )

}


