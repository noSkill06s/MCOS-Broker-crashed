//
//  ChartViewController.swift
//  MCOS
//
//  Created by Burhan Cankurt on 16.09.23.
//

import CorePlot
import UIKit

class ChartViewController: UIViewController, UITextFieldDelegate, CPTBarPlotDataSource, CALayerDelegate, CPTAxisDelegate {
    
    var stockTimeManager: StockTimeManager?
    var currentChartTimeFrame: TimeFrame = .oneMinutes // Start Timeframe
    var searchStock = "AAPL"
    var stockProfileManager: StockProfileManager?
    var stockDataManager: StockDataManager?
    var startPulsingLastPoint: PulsingManager?
    var chartDataLoadManager: ChartDataManager?
    
    var plotData: [StockDataPoint] = []
    var chartStockProfileArray: [StockProfile] = []
    
    @IBOutlet var graphView: CPTGraphHostingView!
    @IBOutlet var stockCourse: UILabel!
    @IBOutlet var stockProfileSymbol: UILabel!
    @IBOutlet var stockProfileRange: UILabel!
    @IBOutlet var stockProfileChanges: UILabel!
    @IBOutlet var stockProfileCompanyName: UILabel!
    @IBOutlet var stockProfileCurrency: UILabel!
    @IBOutlet var stockProfileImage: UIImageView!
    @IBOutlet weak var kaufenButton: UIButton!
    @IBOutlet weak var planenButton: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var analyseButton: UIButton!
    @IBOutlet weak var timeFrameButton: UIButton!
    @IBOutlet weak var watchlistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockProfileManager = StockProfileManager(controller: self)
        stockProfileManager?.loadStockProfile()
        stockDataManager = StockDataManager(controller: self)
        stockDataManager?.updateLastDataPoint()
        startPulsingLastPoint = PulsingManager(controller: self)
        startPulsingLastPoint?.startPulsingLastPoint()
        chartDataLoadManager = ChartDataManager(controller: self)
        chartDataLoadManager?.loadChartData(with: currentChartTimeFrame)
        let initialTimeFrameLabel = timeFrameToReadableString(currentChartTimeFrame)
        timeFrameButton.setTitle("Timeframe: \(initialTimeFrameLabel)", for: .normal)
        
        // Erstellen der benutzerdefinierten Farbe
        let customBorderColorLight = UIColor(red: 9.0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        let customBorderColorHeavy = UIColor(red: 9.0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        let customBackgroundColorLight = UIColor(red: 9.0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 0.01)
        
        
        let customGreenBorderColorHeavy = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)

        let customGreenBackgroundColorLight = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 0.3)
        
        
        graphView.layer.borderColor = customBorderColorLight.cgColor
        graphView.layer.borderWidth = 1.0
        graphView.layer.cornerRadius = 5.0
        graphView.clipsToBounds = true
        
        kaufenButton.layer.borderColor = customGreenBorderColorHeavy.cgColor
        kaufenButton.layer.backgroundColor = customGreenBackgroundColorLight.cgColor
        kaufenButton.layer.borderWidth = 1.0
        kaufenButton.layer.cornerRadius = 5.0
        kaufenButton.clipsToBounds = true
        
        planenButton.layer.borderColor = customBorderColorHeavy.cgColor
        planenButton.layer.backgroundColor = customBorderColorLight.cgColor
        planenButton.layer.borderWidth = 1.0
        planenButton.layer.cornerRadius = 5.0
        planenButton.clipsToBounds = true
        
        textField.layer.borderColor = customBorderColorLight.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.clipsToBounds = true
        textField.delegate = self
        
        analyseButton.layer.borderColor = customBorderColorHeavy.cgColor
        analyseButton.layer.backgroundColor = customBorderColorLight.cgColor
        analyseButton.layer.borderWidth = 1.0
        analyseButton.layer.cornerRadius = 5.0
        analyseButton.clipsToBounds = true
        
        timeFrameButton.layer.borderColor = customBorderColorHeavy.cgColor
        timeFrameButton.layer.backgroundColor = customBorderColorLight.cgColor
        timeFrameButton.layer.borderWidth = 1.0
        timeFrameButton.layer.cornerRadius = 5.0
        timeFrameButton.clipsToBounds = true
        
        let starImage = UIImage(systemName: "star")
        watchlistButton.setImage(starImage, for: .normal)
        watchlistButton.tintColor = UIColor.white  // Optional: Setzen Sie die Tint-Farbe
        watchlistButton.isHighlighted = true  // Optional: Setzen Sie den hervorgehobenen Zustand
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            initializeGraph()
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stockTimeManager = StockTimeManager(stockDataManager: stockDataManager, pulsingManager: startPulsingLastPoint)
        stockTimeManager?.startTimers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stockTimeManager?.stopTimers()
    }
    
    func initializeGraph() {
        configureGraphView(for: graphView, plotData: plotData, delegate: self, traitCollection: self.traitCollection)
        configurePlot(for: graphView, dataSource: self, delegate: self)
    }
    
    @IBAction func timeFrameButtonTapped(_ sender: UIButton) {
        presentTimeFrameSelector(in: self) { [weak self] timeFrame in
            guard let self = self else { return }
            
            self.currentChartTimeFrame = timeFrame
            self.chartDataLoadManager?.loadChartData(with: timeFrame)
            
            // Button-Titel auf den ausgewählten TimeFrame aktualisieren
            let timeFrameLabel = self.timeFrameToReadableString(timeFrame)
            sender.setTitle("Timeframe: \(timeFrameLabel)", for: .normal)
        }
    }

    func timeFrameToReadableString(_ timeFrame: TimeFrame) -> String {
        switch timeFrame {
        case .oneMinutes:
            return "1Min Chart"
        case .fiveMinutes:
            return "5Min Chart"
        case .fifteenMinutes:
            return "15Min Chart"
        case .thirtyMinutes:
            return "30Min Chart"
        case .oneHour:
            return "1Std Chart"
        case .fourHours:
            return "4Std Chart"
        case .oneDay:
            return "1T Chart"
        case .oneWeek:
            return "1W Chart"
        case .oneMonth:
            return "1M Chart"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            searchViewController.delegate = self
            self.navigationController?.pushViewController(searchViewController, animated: true)
        }
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
            plotSymbol.fill = CPTFill(color: CPTColor.blue())
            
            // Abrufen der `lastPointSymbolSize` aus der `StockTimeManager`-Instanz
            let symbolSize = stockTimeManager?.lastPointSymbolSize ?? CGSize(width: 13.0, height: 13.0)
            
            plotSymbol.size = symbolSize  // Verwenden Sie die Instanzvariable
            return plotSymbol
        }
        return nil  // Für andere Datenpunkte kein spezielles Symbol
    }
}

extension ChartViewController: StockSelectionDelegate {
    func stockWasSelected(_ stockSymbol: String) {
        self.searchStock = stockSymbol
        // Aktualisieren Sie den Chart mit dem neuen Symbol
        self.stockDataManager?.updateLastDataPoint()
        self.stockProfileManager?.loadStockProfile()
        self.chartDataLoadManager?.loadChartData(with: currentChartTimeFrame)
    }
}

