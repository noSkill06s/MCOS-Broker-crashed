//
//  StockTimeManager.swift
//  MCOS
//
//  Created by Burhan Cankurt on 03.10.23.
//

import Foundation

class StockTimeManager {
    var stockDataManager: StockDataManager?
    var pulsingManager: PulsingManager?

    var updateTimer: Timer?
    var pulsingTimer: Timer?
    var lastPointSymbolSize: CGSize = CGSize(width: 13.0, height: 13.0)

    init(stockDataManager: StockDataManager?, pulsingManager: PulsingManager?) {
        self.stockDataManager = stockDataManager
        self.pulsingManager = pulsingManager
    }

    func startTimers() {
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: stockDataManager!, selector: #selector(StockDataManager.updateLastDataPoint), userInfo: nil, repeats: true)
        
        if let pulsingManager = pulsingManager {
            pulsingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: pulsingManager, selector: #selector(PulsingManager.startPulsingLastPoint), userInfo: nil, repeats: true)
        }
    }

    func stopTimers() {
        updateTimer?.invalidate()
        pulsingTimer?.invalidate()
    }
}


