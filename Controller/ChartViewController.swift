//
//  ChartViewController.swift
//  MCOS
//
//  Created by Burhan Cankurt on 16.09.23.
//

import CorePlot
import UIKit

class ChartViewController: UIViewController, CPTBarPlotDataSource, CALayerDelegate, CPTAxisDelegate {
    
    //@IBOutlet weak var viewChildChartViewController: UILabel!
    
    var searchStock = "AAPL" //Hier kommt der Input dann vom SearchController aktuell pseudo AAPL
    var stockProfileManager: StockProfileManager?
    var stockDataManager: StockDataManager?
    var startPulsingLastPoint: PulsingManager?
    var chartDataLoadManager: ChartDataManager?
    
    var plotData: [StockDataPoint] = []
    var chartStockProfileArray: [StockProfile] = []
        
    @IBOutlet var graphView: CPTGraphHostingView!
    @IBOutlet var stockCourse: UILabel!
    @IBOutlet var stockProfileSymbol: UILabel!
    @IBOutlet var stockProfileRange: UILabel! // aktualisieren bei jedem Datenpunkt
    @IBOutlet var stockProfileChanges: UILabel! // aktualisieren bei jedem Datenpunkt
    @IBOutlet var stockProfileCompanyName: UILabel!
    @IBOutlet var stockProfileCurrency: UILabel!
    @IBOutlet var stockProfileImage: UIImageView!
    
    var updateTimer: Timer?
    var pulsingTimer: Timer?
    var lastPointSymbolSize: CGSize = CGSize(width: 13.0, height: 13.0)

    @IBAction func timeFrameButtonTapped(_ sender: UIButton) {
        presentTimeFrameSelector(in: self) { [weak self] timeFrame in
            self?.chartDataLoadManager?.loadChartData(with: timeFrame)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stockProfileManager = StockProfileManager(controller: self)
        stockProfileManager?.loadStockProfile()
        stockDataManager = StockDataManager(controller: self)
        stockDataManager?.updateLastDataPoint()
        startPulsingLastPoint = PulsingManager(controller: self)
        startPulsingLastPoint?.startPulsingLastPoint()
        chartDataLoadManager = ChartDataManager(controller: self) // Beachten Sie die Namensänderung
        chartDataLoadManager?.loadChartData(with: .oneMinutes) // Einheitlicher Zeitrahmen

        updateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: stockDataManager!, selector: #selector(StockDataManager.updateLastDataPoint), userInfo: nil, repeats: true)
        if let startPulsingLastPoint = startPulsingLastPoint {
            pulsingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: startPulsingLastPoint, selector: #selector(PulsingManager.startPulsingLastPoint), userInfo: nil, repeats: true)
        }
    }

    func initializeGraph() {
        configureGraphView(for: graphView, plotData: plotData, delegate: self, traitCollection: self.traitCollection) // Übergeben Sie die Farbe als zusätzlichen Parameter
        configurePlot(for: graphView, dataSource: self, delegate: self)
    }
    
    // Veränderungen im Viewcontroller registrieren
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            initializeGraph() // Graphen neu initialisieren, wenn sich der Farbmodus ändert
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
        pulsingTimer?.invalidate()
        pulsingTimer = nil
    }
}

extension ChartViewController: CPTScatterPlotDataSource, CPTScatterPlotDelegate {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        if plot.identifier as? String == "last-point-plot" {
            return 1 // Nur ein Punkt für den speziellen Plot
        }
        return UInt(self.plotData.count)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        if plot.identifier as? String == "last-point-plot" {
            guard let lastDataPoint = self.plotData.last else { return nil }
            switch CPTScatterPlotField(rawValue: Int(field))! {
            case .X:
                return NSNumber(value: self.plotData.count - 1)
            case .Y:
                return NSNumber(value: lastDataPoint.close)
            default:
                return nil
            }
        }
        
        switch CPTScatterPlotField(rawValue: Int(field))! {
        case .X:
            return NSNumber(value: Int(record))
        case .Y:
            let yValue = self.plotData[Int(record)].close
            return yValue as NSNumber
        default:
            return nil
        }
    }

    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        if idx == self.plotData.count - 1 {  // Überprüfen, ob es der letzte Datenpunkt ist
            let plotSymbol = CPTPlotSymbol.ellipse()
            plotSymbol.fill = CPTFill(color: CPTColor.purple())
            plotSymbol.size = lastPointSymbolSize  // Verwenden Sie die Instanzvariable
            return plotSymbol
        }
        return nil  // Für andere Datenpunkte kein spezielles Symbol
    }
}

