//
//  StockSelectionDelegate.swift
//  MCOS
//
//  Created by Burhan Cankurt on 04.10.23.
//

import Foundation

protocol StockSelectionDelegate: AnyObject {
    func stockWasSelected(_ stockSymbol: String)
}
