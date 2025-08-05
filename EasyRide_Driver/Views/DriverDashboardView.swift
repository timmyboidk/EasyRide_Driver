import SwiftUI

struct DriverDashboardView: View {
    @State private var viewModel: DriverDashboardViewModel
    @Environment(AppState.self) private var appState

    init() {
        _viewModel = State(initialValue: DriverDashboardViewModel(appState: AppState()))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // This now correctly passes only the viewModel.
                    if let activeOrder = viewModel.activeOrder {
                        ActiveTripView(viewModel: ActiveTripViewModel(order: activeOrder))
                    } else {
                        dashboardContent
                    }
                }
                .navigationTitle("Dashboard")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .onAppear {
                    // This ensures the ViewModel uses the one true AppState from the environment.
                    viewModel = DriverDashboardViewModel(appState: appState)
                }
            }
        }
    }

    @ViewBuilder
    private var dashboardContent: some View {
        VStack {
            Toggle(isOn: $viewModel.isOnline) {
                Text(viewModel.isOnline ? "You are Online" : "You are Offline")
                    .font(.headline)
                    .foregroundColor(viewModel.isOnline ? .green : .gray)
            }
            .onChange(of: viewModel.isOnline) { _, _ in Task { await viewModel.toggleOnlineStatus() } }
            .padding([.horizontal, .top])

            if viewModel.isLoading {
                ProgressView("Searching for Rides...").frame(maxHeight: .infinity)
            } else if viewModel.isOnline {
                if viewModel.availableOrders.isEmpty {
                    Text("Waiting for ride requests...").foregroundColor(.gray).frame(maxHeight: .infinity)
                } else {
                    availableOrdersList
                }
            } else {
                Text("Go online to start receiving requests.").foregroundColor(.gray).frame(maxHeight: .infinity)
            }
        }
    }

    private var availableOrdersList: some View {
        List {
            ForEach(viewModel.availableOrders) { order in
                NavigationLink(destination: DriverOrderDetailView(order: order, onAccept: { acceptedOrder in
                    Task { await viewModel.acceptOrder(acceptedOrder) }
                })) {
                    OrderRequestCardView(order: order)
                }
                .listRowBackground(Color.black).listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable { await viewModel.fetchAvailableOrders() }
    }
}
