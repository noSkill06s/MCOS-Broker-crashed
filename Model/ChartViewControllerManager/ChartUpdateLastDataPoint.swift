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
                
                DispatchQueue.main.async {
                    self?.viewController?.graphView.hostedGraph?.reloadData()
                    
                    // Anpassen der Y-Achse nach dem Aktualisieren des letzten Datenpunkts
                    guard let viewControllerUnwrapped = self?.viewController,
                          let graph = viewControllerUnwrapped.graphView.hostedGraph else {
                        print("ViewController oder Graph ist nicht verfügbar.")
                        return
                    }
                    adjustYAxisRange(for: viewControllerUnwrapped.plotData, graph: graph)

                    if let lastDataPoint = self?.viewController?.plotData.last,
                       let firstDataPoint = self?.viewController?.plotData.first {
                        let range = "\(firstDataPoint.close) - \(lastDataPoint.close)"
                        self?.viewController?.stockProfileRange.text = "   " + range
                        
                        let change = lastDataPoint.close - firstDataPoint.close
                        self?.viewController?.stockProfileChanges.text = String(format: "%.2f", change)
                        self?.viewController?.stockCourse.text = "\(lastDataPoint.close)"
                    }
                }
                
            case .failure(let error):
                if let dataError = error as? DataError, dataError == .unchanged {
                    return
                } else {
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
}

// Chart Preisskala Adjustierung (dramatischer Anstieg oder Fall)
func adjustYAxisRange(for plotData: [StockDataPoint], graph: CPTGraph) {
    guard let yAxis = (graph.axisSet as? CPTXYAxisSet)?.yAxis else { return }
    let yMin = plotData.min(by: { $0.close < $1.close })?.close ?? 0
    let yMax = plotData.max(by: { $0.close < $1.close })?.close ?? 0
    let yRange = yMax - yMin
    let paddingPercentage = 0.05
    let yMinAdjusted = yMin - (yRange * paddingPercentage)
    let yMaxAdjusted = yMax + (yRange * paddingPercentage)
    yAxis.visibleRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMinAdjusted), lengthDecimal: CPTDecimalFromDouble(yMaxAdjusted - yMinAdjusted))
}
