import XCTest

class codemotion2015UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setLanguage(app)
        app.launch()
    }
    
    func testSnapshot() {
        snapshot("01Main")
        XCUIApplication().buttons.elementBoundByIndex(0).tap()
        snapshot("02Language")
    }
}
