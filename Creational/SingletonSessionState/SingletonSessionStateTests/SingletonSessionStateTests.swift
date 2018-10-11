//
//  SingletonSessionStateTests.swift
//  SingletonSessionStateTests
//
//  Created by Vlastimir Radojevic on 10/11/18.
//  Copyright © 2018 Vlastimir Radojevic. All rights reserved.
//

import XCTest
@testable import SingletonSessionState
class SingletonSessionStateTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConcurrentAccess() {
        let asyncQueue = DispatchQueue(label: "asyncQueue", attributes: .concurrent, target: nil)
        
        let expect = expectation(description: "Storing values in SessionState shall succeed")
        
        let maxIndex = 200
        
        for index in 0...maxIndex {
            asyncQueue.async {
                SessionState.shared.set(index, forKey: String(index))
            }
        }
        
        // wait until the last element is written
        while SessionState.shared.object(forKey: String(maxIndex)) as? Int != maxIndex {
            //nop
        }
        
        expect.fulfill()
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, "Test expectation failed")
        }
    }

}
