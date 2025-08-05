import SwiftUI

@main
struct EasyRideDriverApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            // This structure determines if the user sees the login screen
            // or the main app interface based on their authentication status.
            if appState.isAuthenticated {
                DriverMainView()
                    .environment(appState)
            } else {
                // You can reuse LoginView.swift and AuthenticationViewModel.swift
                // from your passenger app project.
                LoginView(appState: appState)
                    .environment(appState)
            }
        }
    }
}
