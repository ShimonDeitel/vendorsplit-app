import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Theme.accent)
                    Text("Vendorsplit Pro")
                        .font(Theme.titleFont)
                    Text("Automatic even-split calculator and event history")
                        .font(Theme.bodyFont)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    if let product = purchases.product {
                        Button {
                            Task { await purchases.purchase() }
                        } label: {
                            Text("Unlock for \(product.displayPrice)")
                                .font(Theme.headlineFont)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        }
                        .accessibilityIdentifier("purchaseButton")
                        .padding(.horizontal)
                    } else {
                        ProgressView()
                    }

                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restorePurchasesButton")

                    Button("Not now") { dismiss() }
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("dismissPaywallButton")
                }
                .padding()
            }
        }
    }
}
