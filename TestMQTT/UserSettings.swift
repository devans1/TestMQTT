//
//  UserSettings.swift
//  TestMQTT
//
//  Created by Adam Fowler on 30/06/2021.
//
import MQTTNIO
import SwiftUI

class UserSettings: ObservableObject {
    @Published var hostname: String {
        didSet { UserDefaults.standard.set(self.hostname, forKey: "hostname") }
    }
    @Published var port: Int {
        didSet { UserDefaults.standard.set(self.port, forKey: "port") }
    }
    @Published var clientIdentifier: String {
        didSet { UserDefaults.standard.set(self.clientIdentifier, forKey: "clientIdentifier") }
    }
    @Published var version: MQTTClient.Version {
        didSet {
            switch version {
            case .v3_1_1:
                UserDefaults.standard.set(0, forKey: "version")
            case .v5_0:
                UserDefaults.standard.set(1, forKey: "version")
            }
        }
    }
    @Published var useTLS: Bool {
        didSet { UserDefaults.standard.set(self.useTLS, forKey: "useTLS") }
    }
    @Published var useWebSocket: Bool {
        didSet { UserDefaults.standard.set(self.useWebSocket, forKey: "useWebSocket") }
    }
    @Published var webSocketURL: String {
        didSet { UserDefaults.standard.set(self.webSocketURL, forKey: "webSocketURL") }
    }
    @Published var authentication: Bool {
        didSet { UserDefaults.standard.set(self.authentication, forKey: "authentication") }
    }
    @Published var username: String {
        didSet { UserDefaults.standard.set(self.username, forKey: "username") }
    }
    @Published var cleanSession: Bool {
        didSet { UserDefaults.standard.set(self.cleanSession, forKey: "cleanSession") }
    }

    init() {
        UserDefaults.standard.register(defaults: [
            "port": 1883,
            "version": 0,
            "useWebSocket": false,
            "authentication": false,
            "cleanSession": true
        ])

        self.hostname = UserDefaults.standard.string(forKey: "hostname") ?? ""
        self.clientIdentifier = UserDefaults.standard.string(forKey: "clientIdentifier") ?? ""
        self.port = UserDefaults.standard.integer(forKey: "port")
        switch UserDefaults.standard.integer(forKey: "version") {
        case 1:
            self.version = .v5_0
        default:
            self.version = .v3_1_1
        }
        #if DEBUG // don't release with TLS to avoid US export laws
        self.useTLS = UserDefaults.standard.bool(forKey: "useTLS")
        #else
        self.useTLS = false
        #endif
        self.useWebSocket = UserDefaults.standard.bool(forKey: "useWebSocket")
        self.webSocketURL = UserDefaults.standard.string(forKey: "webSocketURL") ?? "/mqtt"
        self.authentication = UserDefaults.standard.bool(forKey: "authentication")
        self.username = UserDefaults.standard.string(forKey: "username") ?? ""
        self.cleanSession = UserDefaults.standard.bool(forKey: "cleanSession")
    }
}
