//
//  SpeedtestResult.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import Foundation

struct SpeedtestResult: Codable {
    let downloadSpeed: Double
    let uploadSpeed: Double
    let responsiveNess: Int
    
    
    func speedStringFor(speed: Double) -> String {
                
        var realSpeed: Double = 0
        var speedValue: String = "Mbps"
        
        if speed > 999999999 {
            speedValue = "Gbps"
            realSpeed = speed / 1000000000
        } else if speed > 999999 {
            speedValue = "Mbps"
            realSpeed = speed / 1000000
        } else {
            speedValue = "Kbps"
            realSpeed = speed / 1000
        }
        
        return String(format: "%.2f \(speedValue)", realSpeed)
    }
    
    init(outputString: String) {
        
        let elements = outputString.components(separatedBy: "\r")
        
        let uploadCapacityElements = elements[2].components(separatedBy: " ")
        self.uploadSpeed = Double(uploadCapacityElements[2]) ?? 99
        
        let downloadCapacityElements = elements[3].components(separatedBy: " ")
        self.downloadSpeed = Double(downloadCapacityElements[2]) ?? 99
        
//        let uploadFlowsElements = elements[4].components(separatedBy: " ")
//        self.uploadFlows = Int(uploadFlowsElements[2]) ?? 99
//
//        let downloadFlowsElements = elements[5].components(separatedBy: " ")
//        self.downloadFlows = Int(downloadFlowsElements[2]) ?? 99
        
//        let responsiveNessElements = elements[6].components(separatedBy: " ")
//        self.responsiveNess = responsiveNessElements[1]
        
        let responsiveNessScoreElements = elements[6].components(separatedBy: "(")
        let second = responsiveNessScoreElements[1].components(separatedBy: " ")
        
        self.responsiveNess = Int(second[0]) ?? 99
    }
    
    init(json: Data) {
        let decoder = JSONDecoder()

        if let result = try? decoder.decode(SpeedtestResult.self, from: json) {
            self = result
        } else {
            self.downloadSpeed = 1
            self.uploadSpeed = 1
            self.responsiveNess = 1
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case uploadSpeed = "ul_throughput"
        case downloadSpeed = "dl_throughput"
        case responsiveNess = "responsiveness"
    }
}

//let dict = myString.toJSON() as? [String:AnyObject]

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

