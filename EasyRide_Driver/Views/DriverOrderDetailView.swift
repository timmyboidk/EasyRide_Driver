import SwiftUI
import MapKit

struct DriverOrderDetailView: View {
    let order: Order
    let onAccept: (Order) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                // Map showing pickup and dropoff for driver's consideration.
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: order.pickupLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )), annotationItems: [order.pickupLocation, order.destination].compactMap { $0 }) { location in
                    MapMarker(coordinate: location.coordinate, tint: location.id == order.pickupLocation.id ? .green : .red)
                }
                .frame(height: 300)
                .cornerRadius(12)
                .padding()

                // Detailed breakdown of the trip.
                VStack(alignment: .leading, spacing: 16) {
                    Text("Trip Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    InfoRow(icon: "arrow.up.circle.fill", title: "Pickup", value: order.pickupLocation.address)
                    InfoRow(icon: "arrow.down.circle.fill", title: "Destination", value: order.destination?.address ?? "Charter Ride")
                    InfoRow(icon: "person.fill", title: "Passengers", value: "\(order.passengerCount)")
                    
                    if let notes = order.notes, !notes.isEmpty {
                        InfoRow(icon: "note.text", title: "Notes", value: notes)
                    }
                }
                .padding()

                Spacer()

                // Accept/Decline Buttons
                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Text("Decline")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { onAccept(order) }) {
                        Text(String(format: "Accept - $%.2f", order.estimatedPrice))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("New Ride Request")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
