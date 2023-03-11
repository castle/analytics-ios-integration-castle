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
    private var userJwt: String
        
    public init(userJwt: String) {
        self.userJwt = userJwt
    }

    public func update(settings: Settings, type: UpdateType) {
        // Skip if you have a singleton and don't want to keep updating via settings.
        guard type == .initial else { return }
        
        // Grab the settings and assign them for potential later usage.
        // Note: Since integrationSettings is generic, strongly type the variable.
        guard let tempSettings: CastleSettings = settings.integrationSettings(forPlugin: self) else {
            analytics?.log(message: "Could not load Castle settings")
            return
        }
        
        castleSettings = tempSettings
        
        let configuration = CastleConfiguration(publishableKey: castleSettings!.publishableKey)
        configuration.isDebugLoggingEnabled = true
        Castle.configure(configuration)
        
        Castle.userJwt(userJwt)
    }
    
    public func identify(event: IdentifyEvent) -> IdentifyEvent? {
        // Since we don't have a corresponding event we won't do anything here
        return event
    }
    
    public func track(event: TrackEvent) -> TrackEvent? {
        let properties = filteredProperties(properties: event.properties?.dictionaryValue)
        Castle.custom(name: event.event, properties: properties)
        return event
    }
    
    public func screen(event: ScreenEvent) -> ScreenEvent? {
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

/// Versioning
extension CastleDestination: VersionedPlugin {
    public static func version() -> String {
        return __destination_version
    }
}

/// Settings
private struct CastleSettings: Codable {
    let publishableKey: String
}

// Rules for converting keys and values to the proper formats that bridge
// from Segment to the Partner SDK. These are only examples.
private extension CastleDestination {
    
    func isValidProperty(property: Any) -> Bool {
        // If the value if of any other type than NSNumber, NSString or NSNull: validation failed
        if !(property is NSNumber ||
             property is String ||
             property is NSNull ||
             property is [String: Any] ||
             property is [Any])
        {
            analytics?.log(message: "Properties dictionary contains invalid data. Fount object with type: \(property)")
            return false
        }
        // No data in the traits dictionary was caught by the validation i.e. it's valid
        return true
    }
    
    func filteredProperties(properties: [String : Any]?) -> [AnyHashable : Any] {
        // Check if dictionary is nil
        guard let dictionary = properties else {
            return [:]
        }

        var validProperties: [AnyHashable : Any] = [:]
        for key in dictionary.keys {
            guard let value = dictionary[key] else { continue }
            if isValidProperty(property: value) {
                validProperties[key] = value
            }
        }
        return validProperties
    }
}
