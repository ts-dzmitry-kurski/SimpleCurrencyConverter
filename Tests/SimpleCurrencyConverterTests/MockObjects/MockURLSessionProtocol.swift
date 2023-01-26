import Foundation
import XCTest

class MockURLSessionProtocol: URLProtocol {
    
    static var loadingHandler: (() -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLSessionProtocol.loadingHandler else {
            XCTFail("Error: loading handler is nil")
            return
        }
        
        let (response, data) = handler()
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let existingData = data {
            client?.urlProtocol(self, didLoad: existingData)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
