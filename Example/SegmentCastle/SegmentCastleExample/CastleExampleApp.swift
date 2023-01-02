//
//  CastleExampleApp.swift
//  CastleExample
//
//  Created by Alexander Simson on 2022-12-19.
//

import SwiftUI
import Segment
import SegmentCastle

@main
struct CastleExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Analytics {
    static var main: Analytics {
        Analytics.debugLogsEnabled = true
        
        let analytics = Analytics(configuration: Configuration(writeKey: "v3KSj7rwRNcE54vcZj5f3EQ6JUODhCIS")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true)
                    .autoAddSegmentDestination(true))
        
        analytics.add(plugin: CastleDestination())
        
        return analytics
    }
}
