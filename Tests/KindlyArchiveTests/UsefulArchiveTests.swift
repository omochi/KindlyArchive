import XCTest
@testable import UsefulArchive

class UsefulArchiveTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UsefulArchive().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
