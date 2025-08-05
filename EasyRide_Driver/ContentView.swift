import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()
    // State to manage the visibility of the initial boot screen animation.
    @State private var showingBootScreen = true

    var body: some View {
        Group {
            if showingBootScreen {
                // Show the animated boot screen first.
                // The 'onComplete' closure transitions to the main app content.
                BootScreenView {
                    showingBootScreen = false
                }
            } else if appState.isAuthenticated {
                // If the user is authenticated, show the main driver interface.
                DriverMainView()
            } else {
                // If the user is not authenticated, show the login screen.
                // The LoginView is reused from the shared codebase.
                LoginView(appState: appState)
            }
        }
        // Provide the global AppState to all child views.
        .environment(appState)
        // Apply smooth animations to the transitions between boot, login, and main views.
        .animation(.easeInOut(duration: 0.3), value: showingBootScreen)
        .animation(.easeInOut(duration: 0.3), value: appState.isAuthenticated)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
