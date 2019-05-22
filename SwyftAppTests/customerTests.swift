//
//  customerTests.swift
//  customerTests
//
//  Created by Tom Manuel on 5/6/19.
//  Copyright © 2019 Tom Manuel. All rights reserved.
//

import XCTest
import Firebase
import FirebaseFirestore

@testable import customer

class customerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDBConnection() {
        let db = Firestore.firestore()
        let getCustomer = GetCustomerPoc(db:db)
        getCustomer.getCustomer(id: "BK9pcr91TVQiV6kjatPh")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
