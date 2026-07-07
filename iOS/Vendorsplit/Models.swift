import Foundation

struct Contribution: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var contributor: String
    var item: String
    var cost: Double
    var event: String
    var date: Date

    init(id: UUID = UUID(), contributor: String = "", item: String = "", cost: Double = 0.0, event: String = "", date: Date = Date()) {
        self.id = id
        self.contributor = contributor
        self.item = item
        self.cost = cost
        self.event = event
        self.date = date
    }
}
