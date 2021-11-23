//
//  HistoryView.swift
//  Speedy
//
//  Created by Jordi Bruin on 22/11/2021.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var history: HistoryManager
    
    @State var hoveringDownload: SpeedtestResult?
    @State var hoveringUpload: SpeedtestResult?
    
    var body: some View {
        VStack {
            downloadHeader
            downloadChart
            
            Divider()
            
            uploadHeader
            uploadChart
        }
    }
    
    var downloadHeader: some View {
        HStack {
            Text("Download")
                .font(.system(.body, design: .rounded))
                .bold()
            Spacer()
            
            Text(hoveringDownload != nil ? "\(hoveringDownload!.speedStringFor(speed: hoveringDownload!.networkQuality.downloadSpeed))" : "1000")
                .padding(4)
                .background(Color.speedyGreen)
                .cornerRadius(20)
                .foregroundColor(.white)
                .font(.system(.body, design: .rounded))
                .font(.caption)
                .opacity(hoveringDownload != nil ? 1 : 0)
            
        }
        .padding(8)
    }
    
    
    var downloadChart: some View {
        HStack {
            ForEach(history.speedTestHistory.suffix(10)) { result in
//            ForEach(1...10, id: \.self) { index in
                ZStack(alignment: .bottom) {
                    Color(.controlBackgroundColor)
                        .frame(width: 16, height: 60)
                    
                    Color.speedyGreen
                        .frame(width: 16, height: heightForBar(result: result))
                        .cornerRadius(8)
                        .opacity(opacityFor(result: result))
                        .onHover { hovering in
                            if hovering {
                                hoveringDownload = result
                            } else {
                                hoveringDownload = nil
                            }
                        }
                        
                }
            }
        }
        .padding(.horizontal)
    }
    
    var uploadHeader: some View {
        HStack {
            Text("Upload")
                .font(.system(.body, design: .rounded))
                .bold()
            Spacer()
            
            Text(hoveringUpload != nil ? "\(hoveringUpload!.speedStringFor(speed: hoveringUpload!.networkQuality.uploadSpeed))" : "1000")
                .padding(4)
                .background(Color.speedyGreen)
                .cornerRadius(20)
                .foregroundColor(.white)
                .font(.system(.body, design: .rounded))
                .font(.caption)
                .opacity(hoveringUpload != nil ? 1 : 0)
            
        }
        .padding(8)
    }
    
    
    var uploadChart: some View {
        HStack {
            ForEach(history.speedTestHistory.suffix(10)) { result in
                ZStack(alignment: .bottom) {
                    Color(.controlBackgroundColor)
                        .frame(width: 16, height: 60)
                    
                    Color.speedyGreen
                        .frame(width: 16, height: heightForUploadBar(result: result))
                        .cornerRadius(8)
                        .opacity(opacityUploadFor(result: result))
                        .onHover { hovering in
                            if hovering {
                                hoveringUpload = result
                            } else {
                                hoveringUpload = nil
                            }
                        }
                }
            }
        }
        .padding(.horizontal)
    }
    
    func opacityFor(result: SpeedtestResult) -> Double {
        
        print("test opacity for: \(result.id.uuidString)")
        guard let hovering = hoveringDownload else { return 0.5 }
        if result.id == hovering.id {
            return 1
        } else {
            return 0.5
        }
    }
    func opacityUploadFor(result: SpeedtestResult) -> Double {
        
        print("test opacity for: \(result.id.uuidString)")
        guard let hovering = hoveringUpload else { return 0.5 }
        if result.id == hovering.id {
            return 1
        } else {
            return 0.5
        }
    }
    
    func heightForBar(result: SpeedtestResult) -> CGFloat {
        var largest: Double = 0
        
        history.speedTestHistory.suffix(10).map { test in
            if test.networkQuality.downloadSpeed > largest {
                largest = test.networkQuality.downloadSpeed
            }
        }
        
        return result.networkQuality.downloadSpeed / largest * 60
    }
    
    func heightForUploadBar(result: SpeedtestResult) -> CGFloat {
        var largest: Double = 0
        
        history.speedTestHistory.suffix(10).map { test in
            if test.networkQuality.uploadSpeed > largest {
                largest = test.networkQuality.uploadSpeed
            }
        }
        
        return result.networkQuality.uploadSpeed / largest * 60
    }
    
    @ViewBuilder
    func overlay(result: SpeedtestResult?) -> some View {
        if result != nil {
            Text("Result")
                .padding(6)
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.caption)
        } else {
            Text("Nothing")
                .padding(6)
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
    
    func speedTestCount() -> Int {
        return history.speedTestHistory.suffix(10).count
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: HistoryManager())
    }
}
