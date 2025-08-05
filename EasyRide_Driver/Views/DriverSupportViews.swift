import SwiftUI

// --- ViewModel: DriverEarningsViewModel.swift ---
@Observable
class DriverEarningsViewModel {
    var wallet: Wallet?
    var transactions: [PaymentTransaction] = []
    var isLoading = false
    
    /// API Endpoints: `GET /api/payment/wallet`, `GET /api/payment/transactions`
    @MainActor
    func fetchEarnings() async {
        isLoading = true
        // MOCK DATA - Replace with API calls
        self.wallet = Wallet(balance: 1234.56, currency: "USD")
        self.transactions = [
            PaymentTransaction(amount: 65.50, type: .payment, status: .completed, description: "Trip to SFO"),
            PaymentTransaction(amount: 120.00, type: .payment, status: .completed, description: "Trip to San Jose"),
            PaymentTransaction(amount: 500.00, type: .topUp, status: .completed, description: "Weekly Payout")
        ]
        isLoading = false
    }
}

// --- View: DriverEarningsView.swift ---
struct DriverEarningsView: View {
    @State private var viewModel = DriverEarningsViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    if viewModel.isLoading { ProgressView() }
                    else if let wallet = viewModel.wallet {
                        WalletCardView(wallet: wallet, onAddFunds: { print("Payout initiated") }).padding()
                        List {
                            Section(header: Text("Recent Transactions").foregroundColor(.gray)) {
                                ForEach(viewModel.transactions) { TransactionRow(transaction: $0) }
                            }
                        }.scrollContentBackground(.hidden)
                    }
                }
                .onAppear { if viewModel.wallet == nil { Task { await viewModel.fetchEarnings() } } }
                .navigationTitle("Earnings")
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
        }
    }
}

// --- View: DriverOrderHistoryView.swift ---
struct DriverOrderHistoryView: View {
    // This view would use its own ViewModel to fetch history from `GET /history`
    @State private var orderHistory: [Order] = Order.mockAvailableOrders

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                List(orderHistory) { order in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Trip to \(order.destination?.address ?? "Charter")").font(.headline).foregroundColor(.white)
                        Text(order.createdAt, style: .date).font(.caption).foregroundColor(.gray)
                    }
                }.scrollContentBackground(.hidden)
                .navigationTitle("Trip History")
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
        }
    }
}

// --- View: DriverProfileView.swift ---
struct DriverProfileView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 30) {
                    Image(systemName: "person.crop.circle.fill").font(.system(size: 120)).foregroundColor(.gray.opacity(0.5))
                    Text(appState.currentUser?.name ?? "Driver Name").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                    List {
                        Section(header: Text("Settings").foregroundColor(.gray)) {
                            Label("Manage Vehicle", systemImage: "car.fill")
                            Label("Account Details", systemImage: "person.text.rectangle.fill")
                            Label("Payout Methods", systemImage: "creditcard.fill")
                        }
                    }.frame(height: 220).scrollContentBackground(.hidden)
                    Button("Logout") { appState.signOut() }
                        .foregroundColor(.red).padding().background(Color.gray.opacity(0.2)).cornerRadius(12)
                    Spacer()
                }
                .padding(.top, 40)
                .navigationTitle("Profile")
                .toolbar(.hidden)
            }
        }
    }
}
