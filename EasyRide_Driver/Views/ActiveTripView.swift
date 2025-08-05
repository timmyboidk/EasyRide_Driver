//
//  ActiveTripView.swift
//  EasyRide_Driver
//
//  Created by Tim Yu on 2025/8/5.
//
import SwiftUI
import MapKit

struct ActiveTripView: View {
    @State var viewModel: ActiveTripViewModel
    private let passengerName = "John Appleseed"
    private let passengerPhoneNumber = "555-123-4567"

    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: viewModel.order.pickupLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))))
                .frame(height: 250).cornerRadius(20)

            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Passenger: \(passengerName)").font(.title2).fontWeight(.bold).foregroundColor(.white)
                        Text("Status: \(viewModel.order.status.displayName)").font(.subheadline).foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: callPassenger) {
                        Image(systemName: "phone.fill").font(.title2).padding(12).background(Color.green).foregroundColor(.white).clipShape(Circle())
                    }
                    Button(action: messagePassenger) {
                        Image(systemName: "message.fill").font(.title2).padding(12).background(Color.blue).foregroundColor(.white).clipShape(Circle())
                    }
                }
                Divider().background(Color.gray)
                InfoRow(icon: "arrow.up.circle.fill", title: "Pickup", value: viewModel.order.pickupLocation.address)
                InfoRow(icon: "arrow.down.circle.fill", title: "Dropoff", value: viewModel.order.destination?.address ?? "Charter Ride")
            }
            .padding().background(Color.gray.opacity(0.2)).cornerRadius(20)

            Spacer()
            actionButton
        }
        .padding()
    }
    
    @ViewBuilder
    private var actionButton: some View {
        switch viewModel.order.status {
            case .matched: createActionButton(title: "Confirm Arrival at Pickup", color: .blue, systemImage: "location.fill") { await viewModel.updateStatus(to: .arrived) }
            case .arrived: createActionButton(title: "Start Trip", color: .green, systemImage: "play.fill") { await viewModel.updateStatus(to: .inProgress) }
            case .inProgress: createActionButton(title: "Complete Trip", color: .purple, systemImage: "checkmark.circle.fill") { await viewModel.updateStatus(to: .completed) }
            default: Text("Trip Status: \(viewModel.order.status.displayName)").foregroundColor(.gray)
        }
    }

    private func createActionButton(title: String, color: Color, systemImage: String, action: @escaping () async -> Void) -> some View {
        Button(action: { Task { await action() } }) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }.fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(color).foregroundColor(.white).cornerRadius(12)
        }
    }
    
    private func callPassenger() {
        guard let url = URL(string: "tel://\(passengerPhoneNumber)") else { return }
        UIApplication.shared.open(url)
    }

    private func messagePassenger() {
        print("Navigating to in-app chat...")
    }
}
