//
//  Copyright (c) 2017. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import MasonRIBsSample

import XCTest

class RootRouterTests: XCTestCase {

    private var loggedInBuilder: LoggedInBuildableMock!
    private var rootInteractor: AppRootInteractableMock!
    private var rootRouter: AppRootRouter!

    override func setUp() {
        super.setUp()

        loggedInBuilder = LoggedInBuildableMock()
        rootInteractor = AppRootInteractableMock()
        rootRouter = AppRootRouter(interactor: rootInteractor,
                   viewController: AppRootViewControllableMock(),
                   loggedOutBuilder: LoggedOutBuildableMock(),
                   loggedInBuilder: loggedInBuilder)
    }

    func test_routeToLoggedIn_verifyInvokeBuilderAttachReturnedRouter() {
        let loggedInRouter = LoggedInRoutingMock(interactable: LoggedInInteractableMock())
        var assignedListener: LoggedInListener? = nil
        loggedInBuilder.buildHandler = { (_ listener: LoggedInListener) -> (LoggedInRouting) in
            assignedListener = listener
            return loggedInRouter
        }

        XCTAssertNil(assignedListener)
        XCTAssertEqual(loggedInBuilder.buildCallCount, 0)
        XCTAssertEqual(loggedInRouter.loadCallCount, 0)

        rootRouter.routeToLoggedIn(withPlayer1Name: "1", player2Name: "2")

        XCTAssertTrue(assignedListener === rootInteractor)
        XCTAssertEqual(loggedInBuilder.buildCallCount, 1)
        XCTAssertEqual(loggedInRouter.loadCallCount, 1)
    }
}
