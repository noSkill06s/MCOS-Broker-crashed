//
//  ChartStartPulsingLastPoint.swift
//  ChartViewController
//
//  Created by Burhan Cankurt on 10.09.23.
//

import Foundation

class PulsingManager {
    
    weak var viewController: ChartViewController? // Referenz zum Haupt-ViewController
    var shouldDisplayPoint: Bool = true  // Instanzvariable
    
    init(controller: ChartViewController) {
        self.viewController = controller
    }
    
    @objc func startPulsingLastPoint() {
        guard let viewController = self.viewController else {
            return
        }
        // Umschalten zwischen Sichtbar und Unsichtbar
        shouldDisplayPoint.toggle()

        // Setzen Sie die Größe entsprechend
        let newSize = shouldDisplayPoint ? CGSize(width: 13.0, height: 13.0) : CGSize(width: 0.0, height: 0.0)
        viewController.stockTimeManager?.lastPointSymbolSize = newSize
        DispatchQueue.main.async {
            viewController.graphView.hostedGraph?.reloadData()
        }
    }
}

