//
//  ContentView.swift
//  CastleExample
//
//  Created by Alexander Simson 2022-12-19.
//

import SwiftUI
import Segment

struct ContentView: View {
    let properties: [String: Any] = [
        "key": "value",
        "number": 1,
        "nsnumber": NSNumber(value: 2),
        "double": 3.2,
        "array": [
            "first": "first_value",
            "second": "second_value"
        ]
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    Analytics.main.track(name: "Track")
                    Analytics.main.track(name: "Track With Properties", properties: properties)
                }, label: {
                    Text("Track")
                }).padding(6)
                Button(action: {
                    Analytics.main.screen(title: "Screen appeared")
                    Analytics.main.screen(title: "Screen With Properties", properties: properties)
                }, label: {
                    Text("Screen")
                }).padding(6)
            }.padding(8)
            HStack {
                Button(action: {
                    Analytics.main.group(groupId: "12345-Group")
                    Analytics.main.log(message: "Started group")
                }, label: {
                    Text("Group")
                }).padding(6)
                Button(action: {
                    Analytics.main.identify(userId: "X-1234567890")
                }, label: {
                    Text("Identify")
                }).padding(6)
            }.padding(8)
        }.onAppear {
            Analytics.main.track(name: "onAppear")
            print("Executed Analytics onAppear()")
        }.onDisappear {
            Analytics.main.track(name: "onDisappear")
            print("Executed Analytics onDisappear()")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
