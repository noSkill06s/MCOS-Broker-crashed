//
//  ChartConfigurePlot.swift
//  ChartViewController
//
//  Created by Burhan Cankurt on 08.08.23.
//

import CorePlot
import UIKit

func configurePlot(for graphView: CPTGraphHostingView, dataSource: CPTScatterPlotDataSource, delegate: CPTScatterPlotDelegate) {
   // Hauptplot
   let mainPlot = CPTScatterPlot()

   // Benutzerdefinierte Hellblaue Farbe
    let customColor = CPTColor(componentRed: 9.0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 0.3) // Alpha auf 0.5 für halbtransparent
    let fill = CPTFill(color: customColor)
    mainPlot.areaFill = fill
    mainPlot.areaBaseValue = NSNumber(value: 0.0) // Startet die Füllung bei y=0

    let customLineColor = CPTColor(componentRed: 9.0/255.0, green: 132.0/255.0, blue: 255.0/255.0, alpha: 1.0) // Alpha auf 1.0 für vollständige Deckkraft
    let mainPlotLineStyle = CPTMutableLineStyle()
    mainPlotLineStyle.lineJoin = .round
    mainPlotLineStyle.lineCap = .round
    mainPlotLineStyle.lineWidth = 2
    mainPlotLineStyle.lineColor = customLineColor
    mainPlot.dataLineStyle = mainPlotLineStyle
    mainPlot.curvedInterpolationOption = .catmullCustomAlpha
    mainPlot.interpolation = .linear
    mainPlot.identifier = "main-plot" as NSCoding & NSCopying & NSObjectProtocol

    
    // Zusätzlicher Plot für den letzten Datenpunkt
    let lastPointPlot = CPTScatterPlot()
    let lastPointPlotLineStyle = CPTMutableLineStyle()
    lastPointPlotLineStyle.lineJoin = .round
    lastPointPlotLineStyle.lineCap = .round
    lastPointPlotLineStyle.lineWidth = 4 // Größere Linienbreite
    lastPointPlotLineStyle.lineColor = CPTColor.blue() // Rote Farbe für den letzten Punkt
    lastPointPlot.dataLineStyle = lastPointPlotLineStyle
    lastPointPlot.curvedInterpolationOption = .catmullCustomAlpha
    lastPointPlot.interpolation = .linear
    lastPointPlot.identifier = "last-point-plot" as NSCoding & NSCopying & NSObjectProtocol
    
    guard let graph = graphView.hostedGraph else { return }
    
    // Datenquelle und Delegate für beide Plots festlegen
    mainPlot.dataSource = dataSource
    mainPlot.delegate = delegate
    lastPointPlot.dataSource = dataSource
    lastPointPlot.delegate = delegate
    
    // Beide Plots zum Graphen hinzufügen
    graph.add(mainPlot, to: graph.defaultPlotSpace)
    graph.add(lastPointPlot, to: graph.defaultPlotSpace)
}





