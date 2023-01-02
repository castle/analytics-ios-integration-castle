//
//  CastleDestination.swift
//  CastleDestination
//
//  Created by Alexander Simson on 2022-12-19.
//

// MIT License
//
// Copyright (c) 2021 Segment
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Segment
import Castle

/**
 An implementation of the Example Analytics device mode destination as a plugin.
 */

public class CastleDestination: DestinationPlugin {
    public let timeline = Timeline()
    public let type = PluginType.destination
    public let key = "Castle"
    public var analytics: Analytics? = nil
    
    private var castleSettings: CastleSettings?
        
    public init() { }

    public func update(settings: Settings, type: UpdateType) {
        // Skip if you have a singleton and don't want to keep updating via settings.
        guard type == .initial else { return }
        
        // Grab the settings and assign them for potential later usage.
        // Note: Since integrationSettings is generic, strongly type the variable.
        guard let tempSettings: CastleSettings = settings.integrationSettings(forPlugin: self) else { return }
        castleSettings = tempSettings
        
        let configuration = CastleConfiguration(publishableKey: castleSettings!.publishableKey)
        configuration.isDebugLoggingEnabled = true
        Castle.configure(configuration)
        
        Castle.userJwt("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImVjMjQ0ZjMwLTM0MzItNGJiYy04OGYxLTFlM2ZjMDFiYzFmZSIsImVtYWlsIjoidGVzdEBleGFtcGxlLmNvbSIsInJlZ2lzdGVyZWRfYXQiOiIyMDIyLTAxLTAxVDA5OjA2OjE0LjgwM1oifQ.eAwehcXZDBBrJClaE0bkO9XAr4U3vqKUpyZ-d3SxnH0")
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        
        if let _ = event.traits?.dictionaryValue {
            // TODO: Do something with traits if they exist
        }
        
        // TODO: Do something with userId & traits in partner SDK
        
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
        
        var returnEvent = event
        
        // !!!: Sample of how to convert property keys
        if let mappedProperties = try? event.properties?.mapTransform(CastleDestination.eventNameMap,
                                                                      valueTransform: CastleDestination.eventValueConversion) {
            returnEvent.properties = mappedProperties
        }
                
        // TODO: Do something with event & properties in partner SDK from returnEvent
        Castle.custom(name: returnEvent.event)
        
        return returnEvent
    }
    
    public func screen(event: ScreenEvent) -> ScreenEvent? {
        
        if let _ = event.properties?.dictionaryValue {
            // TODO: Do something with properties if they exist
        }

        // TODO: Do something with name, category & properties in partner SDK
        if let name = event.name {
            Castle.screen(name: name)
        }
        
        return event
    }
    
    public func group(event: GroupEvent) -> GroupEvent? {
        return event
    }
    
    public func alias(event: AliasEvent) -> AliasEvent? {
        return event
    }
    
    public func reset() {
        Castle.reset()
    }
}

// Example of versioning for your plugin
extension CastleDestination: VersionedPlugin {
    public static func version() -> String {
        return __destination_version
    }
}

// Example of what settings may look like.
private struct CastleSettings: Codable {
    let publishableKey: String
}

// Rules for converting keys and values to the proper formats that bridge
// from Segment to the Partner SDK. These are only examples.
private extension CastleDestination {
    
    static var eventNameMap = ["ADD_TO_CART": "Product Added",
                               "PRODUCT_TAPPED": "Product Tapped"]
    
    static var eventValueConversion: ((_ key: String, _ value: Any) -> Any) = { (key, value) in
        if let valueString = value as? String {
            return valueString
                .replacingOccurrences(of: "-", with: "_")
                .replacingOccurrences(of: " ", with: "_")
        } else {
            return value
        }
    }
}
