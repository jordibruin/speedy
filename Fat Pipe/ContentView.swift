//
//  ContentView.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import SwiftUI
import CoreWLAN



struct ContentView: View {
    
    @State var result: SpeedtestResult?
    @State var testing: Bool = false
        
    @State var showMenu: Bool = false
    
    @StateObject var history = HistoryManager()
    @State var showHistory: Bool = false
    
    var body: some View {
        ZStack {
            Color(.controlBackgroundColor)
            
            VStack {
                header
                
                if showHistory {
//                    HistoryView(history: history)
                    Text("TEST")
                } else {
                    content
                }
            }
        }
    }
    
    var header: some View {
        HStack {
            if result != nil && !testing {
                Button {
                    result = nil
                } label: {
                    Image(systemName: "gobackward")
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            
            Button {
                showHistory.toggle()
            } label: {
                HStack {
                    Image(systemName: "chart.bar.fill")
                    Text(CWWiFiClient.shared().interface(withName: nil)?.ssid() ?? "")
                        .bold()
                }
            }
            .buttonStyle(.plain)
            
            
            Spacer()
            
            Button {
                showMenu.toggle()
            } label: {
                Image(systemName: "gearshape.fill")
                    .popover(isPresented: $showMenu) {
                        Button {
                            NSApplication.shared.terminate(self)
                        } label: {
                            Text("Quit Speedy")
                        }
                        
                        .buttonStyle(.bordered)
                    }
            }
            .buttonStyle(.plain)
        }
        
        .padding(12)
    }
    
    
    var content: some View {
        VStack {
            
            if testing || result != nil {
                resultsView
                    .padding(.top, 8)
            } else {
                Image(systemName: "speedometer")
                    .font(.system(size: 80))
                    .foregroundColor(.speedyGreen)
                    .symbolRenderingMode(.hierarchical)
            }
            
            Spacer()
            
            if !testing && result == nil {
                VStack(spacing: 2) {
                    Text("Perform Network Quality test through Apple servers")
                    Text("[More info](https://danpetrov.xyz/macos/2021/11/14/analysing-network-quality-macos.html)")
                        .opacity(0.8)
                }
                .multilineTextAlignment(.center)
                .font(.system(.subheadline, design: .rounded))
                .padding(.bottom, 4)
            }
            
            Spacer()
            
            Button {
                //                let result = SpeedtestResult(outputString: "\r==== SUMMARY ====                                                                                         \rUpload capacity: 35.337 Mbps\rDownload capacity: 263.145 Mbps\rUpload flows: 12\rDownload flows: 20\rResponsiveness: High (1553 RPM)\n")
                //
                //                self.result = result
                //                performNetworkTest()
                if testing {
                    stopTest()
                } else {
                    startTest()
                    
                }
            } label: {
                HStack {
                    Spacer()
                    Text(testing ? "Cancel" : result != nil ? "Test Again" : "Start Speedtest")
                        .bold()
                    
                    Spacer()
                }
                .padding(8)
                .background(testing ? Color.red.opacity(0.5) : Color.speedyGreen.opacity(0.5))
                .cornerRadius(8)
            }
            //            .disabled(testing)
            .buttonStyle(.plain)
        }
        .padding()
    }
    
    var resultsView: some View {
        VStack(spacing: 8) {
            VStack(spacing: 0) {
                Text("DOWNLOAD")
                    .font(.system(.caption, design: .rounded))
                
                if testing {
                    ProgressView()
                        .scaleEffect(0.5)
                        .tint(.speedyGreen)
                } else {
                    if let result = result {
                        Text(result.speedStringFor(speed: result.networkQuality.downloadSpeed))
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                            .foregroundColor(.speedyGreen)
                    }
                }
            }
            
            VStack(spacing: 0) {
                Text("UPLOAD")
                    .font(.system(.caption, design: .rounded))
                
                if testing {
                    ProgressView()
                        .scaleEffect(0.5)
                        .tint(.speedyGreen)
                } else {
                    if let result = result {
                        Text(result.speedStringFor(speed: result.networkQuality.uploadSpeed))
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                            .foregroundColor(.speedyGreen)
                    }
                }
            }
            
            VStack(spacing: 0) {
                Text("RESPONSIVENESS")
                    .font(.system(.caption, design: .rounded))
                
                if testing {
                    ProgressView()
                        .scaleEffect(0.5)
                        .tint(.speedyGreen)
                } else {
                    Text("\(result?.networkQuality.responsiveNess ?? 0)")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .foregroundColor(.speedyGreen)
                }
            }
        }
    }
    
    //    func performNetworkTest() {
    //        testing = true
    //        DispatchQueue.global(qos: .background).async {
    //            guard let shortcutRunResult = self.run("osascript -e 'do shell script \"networkquality\"'") else { return }
    //
    //            testing = false
    //
    //            if shouldIgnoreNextResults { result = nil }
    //
    //            guard let speedTestResults = self.checkResultOfTerminalCommand(output: shortcutRunResult) else {
    //                print("No test results")
    //                return
    //            }
    //
    //            self.result = speedTestResults
    //        }
    //    }
    //
    //    func checkResultOfTerminalCommand(output: String) -> SpeedtestResult? {
    //        if output.contains("User cancelled") {
    //            print("User cancelled")
    //            return nil
    //        } else {
    //            return SpeedtestResult(outputString: output)
    //        }
    //    }
    
    
    // MARK: JSON
    
    func startTest() {
        
        
//        let result = SpeedtestResult(id: UUID(), quality: NetworkQualityResult(downloadSpeed: Double.random(in: 180000000...240000000), uploadSpeed: Double.random(in: 80000000...140000000), responsiveNess: Int.random(in: 43...590)), name: "TEST", hardwareName: "TEstd")
//        history.speedTestHistory.append(result)
//        return;
        
//        shouldIgnoreNextResults = false
        testing = true
        DispatchQueue.global(qos: .background).async {
            guard let shortcutRunResult = self.run("osascript -e 'do shell script \"networkquality -c\"'") else { return }

            testing = false

//            if shouldIgnoreNextResults {
//                result = nil
//                return
//            }
            
            if process == nil {
                print("process is nil")
                result = nil
                return;
            } else {
                print("process still available")
                print("succesful test")
            }
//            if let proc = process, proc.isRunning {
//                print("process is running")
//            } else {
//                print("process not running")
//            }
//            if shortcutRunResult == "" {
//                print("test stopped?")
//                process?.isRunning
//            }
//            print(shortcutRunResult)
            guard let speedTestResults = self.checkResultOfJSONTerminalCommand(output: shortcutRunResult) else {
                print("No test results")
                testing = false
                return
            }

            self.result = speedTestResults

//            history.speedTestHistory.append(speedTestResults)
        }
    }
    
    func checkResultOfJSONTerminalCommand(output: String) -> SpeedtestResult? {
        if output.contains("timed out") {
            print("Time out")
            return nil
        } else if output.contains("User cancelled") {
            print("User cancelled")
            return nil
        } else {
            if let data = try? Data(output.utf8) {
                return SpeedtestResult(json: data)
            }
            
        }
    }
    
    @State private var process: Process?
    
    func stopTest() {
        
        if let process = process, process.isRunning {
            process.terminate()
            self.process = nil
        }
        
        result = nil
        testing = false
//        shouldIgnoreNextResults = true
    }
    
    func run(_ cmd: String) -> String? {
        let pipe = Pipe()
        let newProcess = Process()
        
        process = newProcess
        
        process!.launchPath = "/bin/sh"
        process!.arguments = ["-c", String(format:"%@", cmd)]
        process!.standardOutput = pipe
        process!.standardError = pipe
        
        let fileHandle = pipe.fileHandleForReading
        
        fileHandle.waitForDataInBackgroundAndNotify()
        
        process!.launch()
        return String(data: fileHandle.availableData, encoding: .utf8)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
