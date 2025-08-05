import Foundation
import Observation

@Observable
class DriverDashboardViewModel {
    private let apiService: APIService
    @ObservationIgnored private var appState: AppState
    
    var availableOrders: [Order] = []
    var activeOrder: Order? {
        didSet {
            // Keep the global app state in sync
            appState.activeOrder = activeOrder
        }
    }
    var isLoading: Bool = false
    var isOnline: Bool = false
    var errorMessage: String?

    // The ViewModel is now initialized with the appState from the environment.
    init(apiService: APIService = EasyRideAPIService.shared, appState: AppState) {
        self.apiService = apiService
        self.appState = appState
        // Load the active order from the global state on launch
        self.activeOrder = appState.activeOrder
    }
    
    /// Toggles the driver's online status and fetches orders if going online.
    /// API Endpoint: `POST /api/matching/driver/status`
    @MainActor
    func toggleOnlineStatus() async {
        isOnline.toggle()
        // In a real app, you would make an API call here.
        // try? await apiService.requestWithoutResponse(.updateDriverStatus(isOnline))
        
        if isOnline && activeOrder == nil {
            await fetchAvailableOrders()
        } else {
            availableOrders = []
        }
    }
    
    /// Fetches a list of available orders for the driver.
    /// API Endpoint: `GET /api/matching/driver/orders`
    @MainActor
    func fetchAvailableOrders() async {
        guard isOnline else { return }
        isLoading = true
        errorMessage = nil
        do {
            // MOCK DATA - Replace with your actual API call.
            try await Task.sleep(nanoseconds: 1_000_000_000)
            self.availableOrders = Order.mockAvailableOrders
        } catch {
            errorMessage = "Failed to fetch orders: \(error.localizedDescription)"
        }
        isLoading = false
    }

    /// Accepts an order and sets it as the active trip.
    /// API Endpoint: `POST /api/matching/driver/grab`
    @MainActor
    func acceptOrder(_ order: Order) async {
        isLoading = true
        do {
            // MOCK ACTION - Replace with your actual API call.
            // try await apiService.requestWithoutResponse(.acceptOrder(orderId: order.id))
            var acceptedOrder = order
            acceptedOrder.status = .matched // Update status locally
            self.activeOrder = acceptedOrder
            self.availableOrders = [] // Clear the list of available orders
        } catch {
            errorMessage = "Could not accept order. It may have been taken by another driver."
            await fetchAvailableOrders() // Refresh the list
        }
        isLoading = false
    }
}
