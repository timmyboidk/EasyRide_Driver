import SwiftUI

struct DriverMainView: View {
    @Environment(AppState.self) private var appState

    init() {
        // Corrected the typo from UITabarAppearance to UITabBarAppearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // Corrected the syntax for setting the background color
        appearance.backgroundColor = UIColor.black

        // Corrected the syntax for setting the item colors
        let itemAppearance = UITabBarItemAppearance()
        // Selected state
        itemAppearance.selected.iconColor = UIColor.white
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        // Normal (unselected) state
        itemAppearance.normal.iconColor = UIColor.gray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        // Apply the corrected appearance object
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            DriverDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "car.circle.fill")
                }

            DriverEarningsView()
                .tabItem {
                    Label("Earnings", systemImage: "dollarsign.circle.fill")
                }

            DriverOrderHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }

            DriverProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(.white)
    }
}
