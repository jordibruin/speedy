//
//  Fat_PipeApp.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import SwiftUI

@main
struct Fat_PipeApp: App {
    
    @NSApplicationDelegateAdaptor(StatusBarDelegate.self) var appDelegate
    
    @StateObject var config = ConfigManager()
    
    var body: some Scene {
        WindowGroup {
            Color.clear
                .frame(width: 0, height: 0)
        }
        .windowStyle(HiddenTitleBarWindowStyle())

    }
        
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}
