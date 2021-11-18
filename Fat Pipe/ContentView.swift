//
//  ContentView.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var result: SpeedtestResult?
    @State var testing: Bool = false
    
    @State var shouldIgnoreNextResults = false
    
    @State var showMenu: Bool = false
    
    var body: some View {
        ZStack {
            Color(.controlBackgroundColor)
            
            content
            
            VStack {
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
                
                Spacer()
            }
            .padding(12)
        }
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
                    Text(testing ? "Stop Testing" : result != nil ? "Test Again" : "Start Speedtest")
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
        .padding(.top, 8)
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
                        Text(result.speedStringFor(speed: result.downloadSpeed))
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
                        Text(result.speedStringFor(speed: result.uploadSpeed))
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
                    Text("\(result?.responsiveNess ?? 0)")
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
        shouldIgnoreNextResults = false
        testing = true
        DispatchQueue.global(qos: .background).async {
            guard let shortcutRunResult = self.run("osascript -e 'do shell script \"networkquality -c\"'") else { return }
            
            testing = false
            
            if shouldIgnoreNextResults {
                result = nil
                return
            }
            
            guard let speedTestResults = self.checkResultOfJSONTerminalCommand(output: shortcutRunResult) else {
                print("No test results")
                testing = false
                return
            }
            
            self.result = speedTestResults
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
    
    func stopTest() {
        result = nil
        testing = false
        shouldIgnoreNextResults = true
    }
    
    func run(_ cmd: String) -> String? {
        let pipe = Pipe()
        let process = Process()
        process.launchPath = "/bin/sh"
        process.arguments = ["-c", String(format:"%@", cmd)]
        process.standardOutput = pipe
        process.standardError = pipe
        
        let fileHandle = pipe.fileHandleForReading
        
        fileHandle.waitForDataInBackgroundAndNotify()
        
        process.launch()
        return String(data: fileHandle.availableData, encoding: .utf8)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
