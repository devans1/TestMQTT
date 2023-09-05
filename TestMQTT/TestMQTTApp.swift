//
//  TestMQTTApp.swift
//  TestMQTT
//
//  Created by Adam Fowler on 27/06/2021.
//

import SwiftUI

@main
struct TestMQTTApp: App {
    @StateObject var settings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            ServerDetailsView()
                .environmentObject(settings)
        }
    }
}
