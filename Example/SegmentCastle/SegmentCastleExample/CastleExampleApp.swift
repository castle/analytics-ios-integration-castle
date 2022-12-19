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
        let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
        analytics.add(plugin: CastleDestination())
        return analytics
    }
}
