//
//  FourSquareDemoTests.swift
//  FourSquareDemoTests
//
//  Created by Elvis Mwenda on 31/10/2021.
//

import XCTest
@testable import FourSquareDemo

class FourSquareDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVenueCount() throws {
        let model = VenuesViewModel()
        model.send(event: .onAppear)
        switch  model.state {
        case .idle:
            print("started")
        case .loading:
            print("loading")
        case .loaded(let data):
            XCTAssertEqual(VenueDataHandler.getData().count, data.count, "venue count must me equal to 5")
        case .error(let error, let data):
            Logger.shared.log(error, #file, #line)
            XCTAssertEqual(VenueDataHandler.getData().count, data.count, "venue count must me equal to 5")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
