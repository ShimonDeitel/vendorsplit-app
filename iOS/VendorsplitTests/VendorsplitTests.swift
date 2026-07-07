import XCTest
@testable import Vendorsplit

@MainActor
final class VendorsplitTests: XCTestCase {
    func makeIsolatedStore() -> Store {
        Store()
    }

    func testSeedDataUnderFreeLimit() {
        let store = makeIsolatedStore()
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeIsolatedStore()
        let before = store.items.count
        let added = store.add(Contribution())
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = makeIsolatedStore()
        let item = Contribution()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeIsolatedStore()
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        let store = makeIsolatedStore()
        store.isPro = false
        store.items = Array(repeating: Contribution(), count: Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        XCTAssertFalse(store.add(Contribution()))
    }

    func testProBypassesLimit() {
        let store = makeIsolatedStore()
        store.isPro = true
        store.items = Array(repeating: Contribution(), count: Store.freeLimit)
        XCTAssertTrue(store.canAddMore)
        XCTAssertTrue(store.add(Contribution()))
    }

    func testUpdateModifiesExistingItem() {
        let store = makeIsolatedStore()
        var item = Contribution()
        store.add(item)
        item.contributor = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.contributor, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = makeIsolatedStore()
        store.items = [Contribution(), Contribution()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }
}
