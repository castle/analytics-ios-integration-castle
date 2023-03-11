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
        
        let castleDestination = CastleDestination(userJwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImVjMjQ0ZjMwLTM0MzItNGJiYy04OGYxLTFlM2ZjMDFiYzFmZSIsImVtYWlsIjoidGVzdEBleGFtcGxlLmNvbSIsInJlZ2lzdGVyZWRfYXQiOiIyMDIyLTAxLTAxVDA5OjA2OjE0LjgwM1oifQ.eAwehcXZDBBrJClaE0bkO9XAr4U3vqKUpyZ-d3SxnH0")
        analytics.add(plugin: castleDestination)
        return analytics
    }
}
