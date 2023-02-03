import XCTest
import Quick
import Nimble

@testable import SimpleCurrencyConverter

final class SimpleCurrencyConverterSpecs: QuickSpec {
    
    override func spec() {
        describe("requests") {
            
            var session: URLSession!
            var simpleCurrencyConverter: CurrencyConverterProtocol!
            
            beforeEach {
                let configuration = URLSessionConfiguration.ephemeral
                configuration.protocolClasses = [MockURLSessionProtocol.self]
                session = URLSession(configuration: configuration)
                simpleCurrencyConverter = SimpleCurrencyConverter.shared(exchangeRatesAPIKey: "mockApiKey", urlSession: session)
            }
            
            context("with pre-fetched json rates reponse") {
                it("parse valid json response") {
                    guard let fileUrl = Bundle.module.url(forResource: "RatesMockResponse", withExtension: "json"),
                          let data = try? Data(contentsOf: fileUrl) else {
                        fail("Failed to parse json file by path")
                        return
                    }

                    MockURLSessionProtocol.loadingHandler = {
                        let response = HTTPURLResponse(url: URL(string: "https://api.exchangeratesapi.io/v1/latest")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
                        return (response!, data)
                    }

                    var preFetchedItem: [String: Double]?

                    if let jsonObject = try? JSONSerialization.jsonObject(with: data),
                       let jsonDict = jsonObject as? [String: Any],
                       let rates = jsonDict["rates"] as? [String: Double] {
                        preFetchedItem = rates
                    } else {
                        fail("Failed to decode pre-fetched rates JSON")
                    }
                    
                    simpleCurrencyConverter.getExchangeRate(baseCurrency: .USD, targetCurrencies: [.GBP, .JPY, .EUR]) { result in
                        switch result {
                        case .success(let rates):
                            expect(preFetchedItem).to(equal(rates))
                        case .failure(let error):
                            fail("Error while rates test-request \(error)")
                        }
                    }
                }
            }
            
            context("with pre-fetched json convert reponse") {
                it("parse valid json response") {
                    guard let fileUrl = Bundle.module.url(forResource: "ConvertMockResponse", withExtension: "json"),
                          let data = try? Data(contentsOf: fileUrl) else {
                        fail("Failed to parse json file by path")
                        return
                    }

                    MockURLSessionProtocol.loadingHandler = {
                        let response = HTTPURLResponse(url: URL(string: "https://api.exchangeratesapi.io/v1/convert")!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)
                        return (response!, data)
                    }

                    var preFetchedItem: Double?

                    if let jsonObject = try? JSONSerialization.jsonObject(with: data),
                       let jsonDict = jsonObject as? [String: Any],
                       let result = jsonDict["result"] as? Double {
                        preFetchedItem = result
                    } else {
                        fail("Failed to decode pre-fetched convert JSON")
                    }
                    
                    simpleCurrencyConverter.convert(amount: 25, baseCurrency: .GBP, targetCurrencies: [.JPY]) { result in
                        switch result {
                        case .success(let convertResult):
                            expect(preFetchedItem).to(equal(convertResult["JPY"]))
                        case .failure(let error):
                            fail("Error while rates test-request \(error)")
                        }
                    }
                }
            }
            
            afterEach {
                session = nil
                simpleCurrencyConverter = nil
            }
        }
    }
    
}
