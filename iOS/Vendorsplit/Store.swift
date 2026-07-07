import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Contribution] = []
    @Published var isPro: Bool = false

    /// Free tier allows this many entries. Seed data below is always fewer than this
    /// so a fresh install never opens straight into the paywall.
    static let freeLimit = 20

    private let fileName = "vendorsplit_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Contribution].self, from: data) else {
            items = Self.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Self.freeLimit
    }

    @discardableResult
    func add(_ item: Contribution) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: Contribution) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Contribution) {
        items.removeAll { $0.id == item.id }
        save()
    }

    static func seedData() -> [Contribution] {
        [
        Contribution(contributor: "Alex", item: "Salad", cost: 3.5, event: "July 4th BBQ", date: Date().addingTimeInterval(-259200)),
        Contribution(contributor: "Maria", item: "Chips", cost: 5.75, event: "Office Potluck", date: Date().addingTimeInterval(-518400)),
        Contribution(contributor: "Sam", item: "Soda", cost: 8.0, event: "July 4th BBQ", date: Date().addingTimeInterval(-777600)),
        Contribution(contributor: "Alex", item: "Salad", cost: 10.25, event: "Office Potluck", date: Date().addingTimeInterval(-1036800))
        ]
    }
}
