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
        XCTAssertEqual("abcd".removeNonNumbers(), "",           "\"abcd\".removeNonNumbers result should be \"\"")
        XCTAssertEqual("ab!@#%cd$".removeNonNumbers(), "",      "\"ab!@#%cd$\".removeNonNumbers result should be \"\"")
        XCTAssertEqual("41\n".removeNonNumbers(), "41",         "\"41\\n\".removeNonNumbers result should be 41")
        XCTAssertEqual("41\\n".removeNonNumbers(), "41",        "\"41\\\\n\".removeNonNumbers result should be 41")
        XCTAssertEqual("41\n\n".removeNonNumbers(), "41",       "\"41\\n\\n\".removeNonNumbers result should be 41")
        XCTAssertEqual("41\t/".removeNonNumbers(), "41",        "\"41\\t/\".removeNonNumbers result should be 41")
        XCTAssertEqual("🚕🏧".removeNonNumbers(), "",           "\"🚕🏧\".removeNonNumbers result should be \"\"")
        XCTAssertEqual("🚕45🏧".removeNonNumbers(), "45",       "\"🚕45🏧\".removeNonNumbers result should be 45")
        XCTAssertEqual("🚕Տեստ🏧".removeNonNumbers(), "",       "\"🚕Տեստ🏧\".removeNonNumbers result should be \"\"")
        XCTAssertEqual("Տեստ".removeNonNumbers(), "",           "\"Տեստ\".removeNonNumbers result should be \"\"")
        XCTAssertEqual("Տեստ41".removeNonNumbers(), "41",       "\"Տեստ41\".removeNonNumbers result should be 41")
        XCTAssertEqual(".Տեստ41".removeNonNumbers(), ".41",     "\".Տեստ41\".removeNonNumbers result should be .41")
        XCTAssertEqual(".41".removeNonNumbers(), ".41",         "\".41\".removeNonNumbers result should be .41")
        XCTAssertEqual("..41".removeNonNumbers(), "..41",       "\"..41\".removeNonNumbers result should be ..41")
        XCTAssertEqual("4.1".removeNonNumbers(), "4.1",         "\"4.1\".removeNonNumbers result should be 4.1")
        XCTAssertEqual("4...1".removeNonNumbers(), "4...1",     "\"4...1\".removeNonNumbers result should be 4...1")
        XCTAssertEqual("41.".removeNonNumbers(), "41.",         "\"41.\".removeNonNumbers result should be 41.")
        XCTAssertEqual("41..".removeNonNumbers(), "41..",       "\"41..\".removeNonNumbers result should be 41..")
        XCTAssertEqual("41\t.".removeNonNumbers(), "41.",       "\"41\\t.\".removeNonNumbers result should be 41.")
        XCTAssertEqual("   4".removeNonNumbers(), "4",          "\"   4\".removeNonNumbers result should be 4")
        XCTAssertEqual("   .4".removeNonNumbers(), ".4",        "\"   .4\".removeNonNumbers result should be .4")
        XCTAssertEqual(" .  .4".removeNonNumbers(), "..4",      "\" .  .4\".removeNonNumbers result should be ..4")
        XCTAssertEqual(" 4 ".removeNonNumbers(), "4",           "\" 4 \".removeNonNumbers result should be 4")
        XCTAssertEqual(" 4  .".removeNonNumbers(), "4.",        "\" 4  .\".removeNonNumbers result should be 4.")
        XCTAssertEqual(" 4  ..".removeNonNumbers(), "4..",      "\" 4  ..\".removeNonNumbers result should be 4..")
        XCTAssertEqual("4 ".removeNonNumbers(), "4",            "\"4 \".removeNonNumbers result should be 4")
        XCTAssertEqual(".".removeNonNumbers(), ".",             "\".\".removeNonNumbers result should be .")
    }

    func testRemoveNonDigits() throws {
        XCTAssertEqual(".".removeNonDigits(), "",                           "\".\".removeNonDigits result should be \"\"")
        XCTAssertEqual("1.".removeNonDigits(), "1",                         "\"1.\".removeNonDigits result should be 1")
        XCTAssertEqual("abcd".removeNonDigits(), "",                        "\"abcd\".removeNonDigits result should be \"\"")
        XCTAssertEqual("ab!@#%cd$".removeNonDigits(), "",                   "\"ab!@#%cd$\".removeNonDigits result should be \"\"")
        XCTAssertEqual("41\n".removeNonDigits(), "41",                      "\"41\\n\".removeNonDigits result should be 41")
        XCTAssertEqual("41\t/".removeNonDigits(), "41",                     "\"41\\t/\".removeNonDigits result should be 41")
        XCTAssertEqual("🚕Տեստ🏧".removeNonDigits(), "",                    "\"🚕Տեստ🏧\".removeNonDigits result should be \"\"")
        XCTAssertEqual("Տեստ41".removeNonDigits(), "41",                    "\"Տեստ41\".removeNonDigits result should be 41")
        XCTAssertEqual(".Տեստ41".removeNonDigits(), "41",                   "\".Տեստ41\".removeNonDigits result should be .41")
        XCTAssertEqual("4...1".removeNonDigits(), "41",                     "\"4...1\".removeNonDigits result should be 4...1")
        XCTAssertEqual("   4".removeNonDigits(), "4",                       "\"   4\".removeNonDigits result should be 4")
        XCTAssertEqual(" 4  .".removeNonDigits(), "4",                      "\" 4  .\".removeNonDigits result should be 4.")
        XCTAssertEqual("4 ".removeNonDigits(), "4",                         "\"4 \".removeNonDigits result should be 4")
        XCTAssertEqual(".".removeNonDigits(), "",                           "\".\".removeNonDigits result should be .")
        XCTAssertEqual("0123456789".removeNonDigits(), "0123456789",        "\"0123456789\".removeNonDigits result should be 0123456789")
        XCTAssertEqual("01234567890".removeNonDigits(), "01234567890",      "\"01234567890\".removeNonDigits result should be 01234567890")
        XCTAssertEqual("\0'1234567890".removeNonDigits(), "1234567890",     "\"\\0'1234567890\".removeNonDigits result should be 1234567890")
        XCTAssertEqual("\0".removeNonDigits(), "",                          "\"\\0\".removeNonDigits result should be \"\"")
        XCTAssertEqual("/1".removeNonDigits(), "1",                         "\"/1\".removeNonDigits result should be 1")
        XCTAssertEqual("\\1".removeNonDigits(), "1",                        "\"\\\\1\".removeNonDigits result should be 1")
        XCTAssertEqual("\\0'1234567890".removeNonDigits(), "01234567890",   "\"\\\\0'1234567890\".removeNonDigits result should be 01234567890")
    }

    func testReplaceWithAsterisksStartingAt() throws {
        XCTAssertEqual("".replaceWithAsterisks(starting: 0), "",                "\"\".replaceWithAsterisks(starting: 0) result should be \"\"")
        XCTAssertEqual("".replaceWithAsterisks(starting: -1), "",               "\"\".replaceWithAsterisks(starting: -1) result should be \"\"")
        XCTAssertEqual("Test".replaceWithAsterisks(starting: -1), "Test",       "\"Test\".replaceWithAsterisks(starting: -1) result should be Test")
        XCTAssertEqual("Test".replaceWithAsterisks(starting: 1000000), "Test",  "\"Test\".replaceWithAsterisks(starting: 1000000) result should be Test")
        XCTAssertEqual(".".replaceWithAsterisks(starting: 0), "*",              "\".\".replaceWithAsterisks(starting: 0) result should be *")
        XCTAssertEqual(".".replaceWithAsterisks(starting: 1), ".",              "\".\".replaceWithAsterisks(starting: 1) result should be .")
        XCTAssertEqual("*".replaceWithAsterisks(starting: 0), "*",              "\"*\".replaceWithAsterisks(starting: 0) result should be *")
        XCTAssertEqual("***".replaceWithAsterisks(starting: 1), "***",          "\"***\".replaceWithAsterisks(starting: 1) result should be ***")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 0), "***",          "\"*5*\".replaceWithAsterisks(starting: 0) result should be ***")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 1), "***",          "\"*5*\".replaceWithAsterisks(starting: 1) result should be ***")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 2), "*5*",          "\"*5*\".replaceWithAsterisks(starting: 2) result should be *5*")
        XCTAssertEqual("*5*".replaceWithAsterisks(starting: 3), "*5*",          "\"*5*\".replaceWithAsterisks(starting: 3) result should be *5*")
        XCTAssertEqual("\n".replaceWithAsterisks(starting: 0), "*",             "\"\\n\".replaceWithAsterisks(starting: 0) result should be *")
        XCTAssertEqual("\n\n".replaceWithAsterisks(starting: 0), "**",          "\"\\n\\n\".replaceWithAsterisks(starting: 0) result should be **")
        XCTAssertEqual("\n\n".replaceWithAsterisks(starting: 1), "\n*",         "\"\\n\\n\".replaceWithAsterisks(starting: 1) result should be \\n*")
        XCTAssertEqual("\n*\n".replaceWithAsterisks(starting: 1), "\n**",       "\"\\n*\\n\".replaceWithAsterisks(starting: 1) result should be \\n**")
        XCTAssertEqual("\0".replaceWithAsterisks(starting: 0), "*",             "\"\\0\".replaceWithAsterisks(starting: 0) result should be *")
        XCTAssertEqual("\0\0".replaceWithAsterisks(starting: 0), "**",          "\"\\0\\0\".replaceWithAsterisks(starting: 0) result should be **")
        XCTAssertEqual("\\0\0".replaceWithAsterisks(starting: 0), "***",        "\"\\\0\\0\".replaceWithAsterisks(starting: 0) result should be ***")
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
