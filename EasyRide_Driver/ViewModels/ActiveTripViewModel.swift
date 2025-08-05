import SwiftUI
import MapKit

// --- ViewModel: ActiveTripViewModel.swift ---
@Observable
class ActiveTripViewModel {
    private let apiService: APIService
    var order: Order
    
    init(order: Order, apiService: APIService = EasyRideAPIService.shared) {
        self.order = order
        self.apiService = apiService
    }
    
    /// API Endpoint: `PUT /{orderId}/status`
    @MainActor
    func updateStatus(to newStatus: OrderStatus) async {
        print("Driver updating status to \(newStatus.displayName)...")
        self.order.status = newStatus
        // TODO: Add API call to sync status with backend
    }
}
