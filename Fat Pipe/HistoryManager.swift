//
//  HistoryManager.swift
//  Speedy
//
//  Created by Jordi Bruin on 22/11/2021.
//

import Foundation
import SwiftUI

class HistoryManager: ObservableObject {
    
    @AppStorage("speedTestHistoryDatasss") var speedTestHistoryData: Data = Data()
    
    @Published var speedTestHistory: [SpeedtestResult] = [] {
        didSet {
            print("Updated history")
            guard let data = try? JSONEncoder().encode(speedTestHistoryData) else {
                print("Could not create data for speed test history")
                return
            }
            
            print(speedTestHistory)
            speedTestHistoryData = data
        }
}
    
    init() {
        
        
        
        // MARK: Translate Language
//        if let speedTestHistory = try? JSONDecoder().decode([SpeedtestResult].self, from: speedTestHistoryData) {
//            self.speedTestHistory = speedTestHistory
//        } else {
//            print("No history found")
//        }
        
    }
}
