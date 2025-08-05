import SwiftUI
import MapKit

// A card for displaying an available order in the dashboard list.
struct OrderRequestCardView: View {
    let order: Order
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(order.serviceType.displayName).font(.headline).fontWeight(.bold).foregroundColor(.white)
                Spacer()
                Text(String(format: "$%.2f", order.estimatedPrice)).font(.title3).fontWeight(.bold).foregroundColor(.green)
            }
            InfoRow(icon: "arrow.up.circle.fill", title: "From", value: order.pickupLocation.address)
            InfoRow(icon: "arrow.down.circle.fill", title: "To", value: order.destination?.address ?? "Charter Ride")
            Text("\(order.passengerCount) passenger(s)").font(.caption).foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 4).background(Color.gray.opacity(0.3)).cornerRadius(8)
        }.padding(.vertical, 8)
    }
}

// A reusable view for displaying a piece of information with an icon.
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon).foregroundColor(.gray).frame(width: 25)
            Text(title).foregroundColor(.white).font(.headline)
            Spacer()
            Text(value).foregroundColor(.gray).multilineTextAlignment(.trailing).lineLimit(2)
        }
    }
}

// A card for displaying the driver's current wallet balance.
struct WalletCardView: View {
    let wallet: Wallet
    let onAddFunds: () -> Void // Represents "Payout" in the driver app
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Current Balance").font(.headline).foregroundColor(.gray)
                    Text(wallet.formattedBalance).font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "wallet.pass.fill").font(.largeTitle).foregroundColor(.white)
            }
            Button(action: onAddFunds) {
                Text("Request Payout").fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
        }.padding().background(Color.gray.opacity(0.2)).cornerRadius(12)
    }
}

// A row for displaying a single payment transaction.
struct TransactionRow: View {
    let transaction: PaymentTransaction
    var body: some View {
        HStack {
            Image(systemName: transaction.type.icon).font(.title2).foregroundColor(Color(transaction.type.color))
            VStack(alignment: .leading) {
                Text(transaction.description).foregroundColor(.white)
                Text(transaction.createdAt, style: .date).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            Text(transaction.formattedAmount).foregroundColor(transaction.amount > 0 ? .green : .white)
        }
    }
}
