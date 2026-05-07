import StoreKit
import Foundation

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isPremium: Bool = false
    var isLoading = false

    private var transactionListener: Task<Void, Never>?
    private let productIDs = [
        "com.zzoutuo.ContractGuard.monthly",
        "com.zzoutuo.ContractGuard.yearly",
        "com.zzoutuo.ContractGuard.lifetime"
    ]

    init() {
        transactionListener = listenForTransactions()
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async -> Bool {
        guard !isLoading else { return false }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                purchasedProductIDs.insert(transaction.productID)
                isPremium = true
                await transaction.finish()
                return true
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    var monthlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.ContractGuard.monthly" }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.ContractGuard.yearly" }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == "com.zzoutuo.ContractGuard.lifetime" }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if case .verified(let transaction) = result {
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                }
            }
        }
    }

    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        for productID in productIDs {
            if await isProductPurchased(productID) {
                purchased.insert(productID)
            }
        }
        purchasedProductIDs = purchased
        isPremium = !purchased.isEmpty
    }

    private func isProductPurchased(_ productID: String) async -> Bool {
        guard let result = await Transaction.currentEntitlement(for: productID) else { return false }
        guard let transaction = try? checkVerified(result) else { return false }
        return transaction.revocationDate == nil
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }
}
