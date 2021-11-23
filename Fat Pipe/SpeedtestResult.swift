//
//  SpeedtestResult.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import Foundation
import CoreWLAN

struct NetworkQualityResult: Codable, Hashable {
    let downloadSpeed: Double
    let uploadSpeed: Double
    let responsiveNess: Int
    
    init(json: Data) {
        let decoder = JSONDecoder()

        if let networkQuality = try? decoder.decode(NetworkQualityResult.self, from: json) {
            self = networkQuality
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
    
    init(downloadSpeed: Double, uploadSpeed: Double, responsiveNess: Int) {
        self.downloadSpeed = downloadSpeed
        self.uploadSpeed = uploadSpeed
        self.responsiveNess = responsiveNess
    }
    static let example = NetworkQualityResult(downloadSpeed: 100, uploadSpeed: 140, responsiveNess: 2)
}

struct SpeedtestResult: Identifiable, Codable, Hashable {
    
    let id: UUID
    let networkQuality: NetworkQualityResult
    let wifiName: String
    let wifiHardwareName: String
    
    
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
        
    init(json: Data) {
        let quality = NetworkQualityResult(json: json)
        self.networkQuality = quality
        
        self.wifiName = CWWiFiClient.shared().interface(withName: nil)?.ssid() ?? ""
        self.wifiHardwareName = CWWiFiClient.shared().interface(withName: nil)?.hardwareAddress() ?? ""
        
        self.id = UUID()
    }
    
    enum CodingKeys: String, CodingKey {
        case networkQuality, wifiName, wifiHardwareName, id
    }
    
    init(id: UUID, quality: NetworkQualityResult, name: String, hardwareName: String) {
        self.networkQuality = quality
        self.wifiName = name
        self.wifiHardwareName = hardwareName
        self.id = id
    }
    
    static let example = SpeedtestResult(id: UUID(), quality: NetworkQualityResult(downloadSpeed: 100, uploadSpeed: 140, responsiveNess: 2), name: "Wifi naam", hardwareName: "abc")
}

//let dict = myString.toJSON() as? [String:AnyObject]

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

