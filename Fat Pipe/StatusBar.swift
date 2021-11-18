//
//  StatusBar.swift
//  Fat Pipe
//
//  Created by Jordi Bruin on 16/11/2021.
//

import Foundation

//
//  StatusBar.swift
//  Cooldown
//
//  Created by Jordi Bruin on 05/11/2021.
//

import SwiftUI
import Foundation
import AppKit



class StatusBarDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    
    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 250)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.becomeFirstResponder()
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            if let image = NSImage(systemSymbolName: "speedometer",
                                   accessibilityDescription: "Speedy") {
                    
                var config = NSImage.SymbolConfiguration(textStyle: .title2,
                                                         scale: .medium)
//                config = config.applying(.init(paletteColors: [NSColor(.speedyGreen), .black]))
                button.image = image.withSymbolConfiguration(config)
            }
            
            button.action = #selector(togglePopover(_:))
            button.toolTip = "Open Speedy"
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        }
    }
}


