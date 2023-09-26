//
//  ChartUpdateLastDataPoint.swift
//  ChartViewController
//
//  Created by Burhan Cankurt on 10.09.23.
//

import CorePlot
import UIKit

class StockDataManager {
    
    weak var viewController: ChartViewController? // Referenz zum Haupt-ViewController

    init(controller: ChartViewController) {
        self.viewController = controller
    }

    @objc func updateLastDataPoint() {
        let fetcher = StockDataFetcher()
        loadChartDataGlobal(with: .fifteenMinutes, searchStock: viewController?.searchStock ?? "", fetcher: fetcher) { [weak self] result in
            switch result {
            case .success(let data):
                guard let lastDataPoint = data.last else { return }
                
                if self?.viewController?.plotData.last?.date == lastDataPoint.date {
                    self?.viewController?.plotData[self!.viewController!.plotData.count - 1] = lastDataPoint
                } else {
                    self?.viewController?.plotData.append(lastDataPoint)
                    if let plotDataCount = self?.viewController?.plotData.count, plotDataCount > 48 {
                        self?.viewController?.plotData.remove(at: 0)
                    }
                }
                
            case .failure(let error):
                if let dataError = error as? DataError, dataError == .unchanged {
                    // Nichts tun, wenn die Daten unverändert sind
                } else {
                }
            }
            
            // Always update yRange
            if let graph = self?.viewController?.graphView.hostedGraph as? CPTXYGraph,
               let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace {
                if let yMinAdjusted = self?.viewController?.plotData.min(by: { $0.close < $1.close })?.close,
                   let yMaxAdjusted = self?.viewController?.plotData.max(by: { $0.close < $1.close })?.close {
                    let yRangePadding = (yMaxAdjusted - yMinAdjusted) * 0.05
                    plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMinAdjusted - yRangePadding), lengthDecimal: CPTDecimalFromDouble(yMaxAdjusted + yRangePadding - yMinAdjusted))
                }
            }
            
            DispatchQueue.main.async {
                self?.viewController?.graphView.hostedGraph?.reloadData()
                if let lastDataPoint = self?.viewController?.plotData.last,
                   let firstDataPoint = self?.viewController?.plotData.first {
                    let range = "\(firstDataPoint.close) - \(lastDataPoint.close)"
                    self?.viewController?.stockProfileRange.text = "   " + range
                    let change = lastDataPoint.close - firstDataPoint.close
                    self?.viewController?.stockProfileChanges.text = String(format: "%.2f", change)
                    self?.viewController?.stockCourse.text = "\(lastDataPoint.close)"
                }
            }
        }
    }
}

