//
//  SpeedtestResult.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import Foundation

struct SpeedtestResult {
    let downloadSpeed: Double
    let uploadSpeed: Double
    
    let downloadFlows: Int
    let uploadFlows: Int
    
    let responsiveNess: String
    let responsiveNessScore: Int
    
    init(outputString: String) {
        
        let elements = outputString.components(separatedBy: "\r")
        
        let uploadCapacityElements = elements[2].components(separatedBy: " ")
        self.uploadSpeed = Double(uploadCapacityElements[2]) ?? 99
        
        let downloadCapacityElements = elements[3].components(separatedBy: " ")
        self.downloadSpeed = Double(downloadCapacityElements[2]) ?? 99
        
        let uploadFlowsElements = elements[4].components(separatedBy: " ")
        self.uploadFlows = Int(uploadFlowsElements[2]) ?? 99
        
        let downloadFlowsElements = elements[5].components(separatedBy: " ")
        self.downloadFlows = Int(downloadFlowsElements[2]) ?? 99
        
        let responsiveNessElements = elements[6].components(separatedBy: " ")
        self.responsiveNess = responsiveNessElements[1]
        
        let responsiveNessScoreElements = elements[6].components(separatedBy: "(")
        print(responsiveNessScoreElements)
        let second = responsiveNessScoreElements[1].components(separatedBy: " ")
        print(second)
        
        print(Int(second[0]) ?? 99)
        self.responsiveNessScore = Int(second[0]) ?? 99
    }
}
