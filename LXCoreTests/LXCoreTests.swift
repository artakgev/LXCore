//
//  LXCoreTests.swift
//  LXCoreTests
//
//  Created by Artak Gevorgyan on 26.12.22.
//

import XCTest
@testable import LXCore
// swiftlint:disable all
final class StringExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testRemoveNonNumbers() throws {
        XCTAssertEqual("abcd".removeNonNumbers(), "")
        XCTAssertEqual("ab!@#%cd$".removeNonNumbers(), "")
        XCTAssertEqual("41\n".removeNonNumbers(), "41")
        XCTAssertEqual("41\\n".removeNonNumbers(), "41")
        XCTAssertEqual("41\n\n".removeNonNumbers(), "41")
        XCTAssertEqual("41\t/".removeNonNumbers(), "41")
        XCTAssertEqual("🚕🏧".removeNonNumbers(), "")
        XCTAssertEqual("🚕45🏧".removeNonNumbers(), "45")
        XCTAssertEqual("🚕Տեստ🏧".removeNonNumbers(), "")
        XCTAssertEqual("Տեստ".removeNonNumbers(), "")
        XCTAssertEqual("Տեստ41".removeNonNumbers(), "41")
        XCTAssertEqual(".Տեստ41".removeNonNumbers(), ".41")
        XCTAssertEqual(".41".removeNonNumbers(), ".41")
        XCTAssertEqual("..41".removeNonNumbers(), "..41")
        XCTAssertEqual("4.1".removeNonNumbers(), "4.1")
        XCTAssertEqual("4...1".removeNonNumbers(), "4...1")
        XCTAssertEqual("41.".removeNonNumbers(), "41.")
        XCTAssertEqual("41..".removeNonNumbers(), "41..")
        XCTAssertEqual("41\t.".removeNonNumbers(), "41.")
        XCTAssertEqual("   4".removeNonNumbers(), "4")
        XCTAssertEqual("   .4".removeNonNumbers(), ".4")
        XCTAssertEqual(" .  .4".removeNonNumbers(), "..4")
        XCTAssertEqual(" 4 ".removeNonNumbers(), "4")
        XCTAssertEqual(" 4  .".removeNonNumbers(), "4.")
        XCTAssertEqual(" 4  ..".removeNonNumbers(), "4..")
        XCTAssertEqual("4 ".removeNonNumbers(), "4")
        XCTAssertEqual(".".removeNonNumbers(), ".")
    }

    func testRemoveNonDigits() throws {
        XCTAssertEqual(".".removeNonDigits(), "")
        XCTAssertEqual("1.".removeNonDigits(), "1")
        XCTAssertEqual("abcd".removeNonDigits(), "")
        XCTAssertEqual("ab!@#%cd$".removeNonDigits(), "")
        XCTAssertEqual("41\n".removeNonDigits(), "41")
        XCTAssertEqual("41\t/".removeNonDigits(), "41")
        XCTAssertEqual("🚕Տեստ🏧".removeNonDigits(), "")
        XCTAssertEqual("Տեստ41".removeNonDigits(), "41")
        XCTAssertEqual(".Տեստ41".removeNonDigits(), "41")
        XCTAssertEqual("4...1".removeNonDigits(), "41")
        XCTAssertEqual("   4".removeNonDigits(), "4")
        XCTAssertEqual(" 4  .".removeNonDigits(), "4")
        XCTAssertEqual("4 ".removeNonDigits(), "4")
        XCTAssertEqual(".".removeNonDigits(), "")
        XCTAssertEqual("0123456789".removeNonDigits(), "0123456789")
        XCTAssertEqual("01234567890".removeNonDigits(), "01234567890")
        XCTAssertEqual("\0'1234567890".removeNonDigits(), "1234567890")
        XCTAssertEqual("\0".removeNonDigits(), "")
        XCTAssertEqual("/1".removeNonDigits(), "1")
        XCTAssertEqual("\\1".removeNonDigits(), "1")
        XCTAssertEqual("\\0'1234567890".removeNonDigits(), "01234567890")
    }

    func testReplaceWithAsterisksStartingAt() throws {
        XCTAssertEqual("".replaceWithAsterisks(starting: 0), "")
        XCTAssertEqual("".replaceWithAsterisks(starting: -1), "")
        XCTAssertEqual("Test".replaceWithAsterisks(starting: -1), "Test")
        XCTAssertEqual("Test".replaceWithAsterisks(starting: 1000000), "Test")
        XCTAssertEqual(".".replaceWithAsterisks(starting: 0), "*")
        XCTAssertEqual(".".replaceWithAsterisks(starting: 1), ".")
        XCTAssertEqual("*".replaceWithAsterisks(starting: 0), "*")
        XCTAssertEqual("***".replaceWithAsterisks(starting: 1), "***")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 0), "***")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 1), "***")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 2), "*5*")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 3), "*5*")
        XCTAssertEqual("\n".replaceWithAsterisks(starting: 0), "*")
        XCTAssertEqual("\n\n".replaceWithAsterisks(starting: 0), "**")
        XCTAssertEqual("\n\n".replaceWithAsterisks(starting: 1), "\n*")
        XCTAssertEqual("\n*\n".replaceWithAsterisks(starting: 1), "\n**")
        XCTAssertEqual("\0".replaceWithAsterisks(starting: 0), "*")
        XCTAssertEqual("\0\0".replaceWithAsterisks(starting: 0), "**")
        XCTAssertEqual("\\0\0".replaceWithAsterisks(starting: 0), "***")
        XCTAssertEqual("\\0\0".replaceWithAsterisks(starting: 1), "\\**")
        XCTAssertEqual("\0*45".replaceWithAsterisks(starting: 0), "****")
        XCTAssertEqual("\0*45".replaceWithAsterisks(starting: 1), "\0***")
        XCTAssertEqual("\\1".replaceWithAsterisks(starting: 0), "**")
        XCTAssertEqual("\\1\\1".replaceWithAsterisks(starting: 0), "****")
        XCTAssertEqual("\\1\\1".replaceWithAsterisks(starting: 1), "\\***")
        XCTAssertEqual("\\1\\1".replaceWithAsterisks(starting: 1), "\\***")
        XCTAssertEqual("\\1*45".replaceWithAsterisks(starting: 0), "*****")
        XCTAssertEqual("\\1*45".replaceWithAsterisks(starting: 1), "\\****")

    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
// swiftlint:enable all
