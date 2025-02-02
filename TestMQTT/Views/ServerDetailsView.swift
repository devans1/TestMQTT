//
//  ContentView.swift
//  TestMQTT
//
//  Created by Adam Fowler on 27/06/2021.
//

import MQTTNIO
import SwiftUI

struct ServerDetailsView: View {
    @EnvironmentObject var settings: UserSettings
    @State var password: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section() {
                    HStack {
                        Text("Identifier")
                        TextField(
                            "Enter client identifier",
                            text: $settings.clientIdentifier
                        )
                        .textFieldStyle(BasicTextFieldStyle())
                    }
                    HStack {
                        Text("Host")
                        TextField("Enter server name", text: $settings.hostname)
                            .textFieldStyle(BasicTextFieldStyle())
                    }
                    let portBinding = Binding<String>(
                        get: { String(self.$settings.port.wrappedValue) },
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                self.$settings.port.wrappedValue = value.intValue
                            }
                        }
                    )
                    HStack {
                        Text("Port")
                        TextField("Port", text: portBinding)
                            .textFieldStyle(BasicTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    let versionBinding = Binding<Int>(
                        get: {
                            switch self.settings.version {
                            case .v3_1_1:
                                return 0
                            case .v5_0:
                                return 1
                            }
                        },
                        set: {
                            switch $0 {
                            case 0:
                                self.settings.version = .v3_1_1
                            case 1:
                                self.settings.version = .v5_0
                            default:
                                break
                            }
                        }
                    )
                    Picker(
                        selection: versionBinding,
                        label: Text("Version"),
                        content: {
                            Text("3.1.1").tag(0)
                            Text("5.0").tag(1)
                        }
                    ).pickerStyle(SegmentedPickerStyle())
                    #if DEBUG // don't release with TLS to avoid US export laws
                    Toggle("TLS", isOn: $settings.useTLS)
                    #endif
                    Toggle("WebSocket", isOn: $settings.useWebSocket)
                    if settings.useWebSocket {
                        HStack {
                            Text("WebSocket URL")
                            TextField("Enter URL", text: $settings.webSocketURL)
                                .textFieldStyle(BasicTextFieldStyle())
                        }
                    }
                }
                Section {
                    Toggle("Authentication", isOn: $settings.authentication)
                    if settings.authentication {
                        HStack {
                            Text("Username")
                            TextField("Enter username", text: $settings.username)
                                .textFieldStyle(BasicTextFieldStyle())
                        }
                        HStack {
                            Text("Password")
                            SecureField("Enter password", text: $password)
                                .textFieldStyle(BasicTextFieldStyle())
                        }
                    }
                }
                Section {
                    Toggle("Clean Session", isOn: $settings.cleanSession)
                    NavigationLink (
                        destination: ServerView(
                            serverDetails: .init(
                                identifier: settings.clientIdentifier,
                                hostname: settings.hostname,
                                port: settings.port,
                                version: settings.version,
                                cleanSession: settings.cleanSession,
                                useTLS: settings.useTLS,
                                useWebSocket: settings.useWebSocket,
                                webSocketUrl: settings.webSocketURL,
                                username: settings.authentication ? settings.username : nil,
                                password: settings.authentication ? password : nil
                            )
                        )
                    ) {
                        Text("Connect")
                    }
                    .disabled(settings.hostname.count == 0)
                }
            }
            .navigationBarTitle(Text("MQTT Server Details"))
        }
    }

    struct TextFieldPreferenceKey: PreferenceKey {
        static func reduce(value: inout Anchor<CGPoint>?, nextValue: () -> Anchor<CGPoint>?) {
            value = nextValue()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ServerDetailsView()
            .environmentObject(UserSettings())
    }
}
