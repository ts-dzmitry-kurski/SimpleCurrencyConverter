# SimpleCurrencyConverter
Simple and lightweight framework that provides developers with ready-made methods for obtaining currency rates and conversions. 
At the moment, operations with the following monetary units are supported: **JPY, USD, EUR, GBP**.

## Requirements: 
Xcode 14 and above, iOS 13+, Swift 5.4+

## How to install:

At the moment, only **Swift Package Manager** is supported.

### Installation: 

Open your project settings in Xcode and add a new package in '**Swift Packages**' tab: Repository URL:

**SSH:**  [git@github.com:ts-dzmitry-kurski/SimpleCurrencyConverter.git](git@github.com:ts-dzmitry-kurski/SimpleCurrencyConverter.git)

**HTTPS:** [https://github.com/ts-dzmitry-kurski/SimpleCurrencyConverter.git](https://github.com/ts-dzmitry-kurski/SimpleCurrencyConverter.git)

Choose `SimpleCurrencyConverter` product for your target. If you want to link other targets, go to **Build Phases** of that target, then in Link Binary With Libraries click `+` button and add SimpleCurrencyConverter.

## Configuration:

The framework uses [https://exchangeratesapi.io](https://exchangeratesapi.io/) API. To use the application, you need to set up an API key. There are two ways to do this:

### Build-time configuration:

Add the following entry in your app's `Info.plist`: 
`ExchangeRatesAPIKey` - your_subscription_key

### Runtime configuration:

Provide a value for `exchangeRatesAPIKey` parameter when calling init() method.

    public init(exchangeRatesAPIKey: String? = nil, urlSession: URLSession? = nil)

**Warning!** **The runtime configuration values take precedence over build-time configuration.**

## Usage:

### Initialization:
The first step is to import the framework:

    import SimpleCurrencyConverter


The next step is to initialize the framework object, like so:

    let simpleCurrencyConverter: CurrencyConverterProtocol = SimpleCurrencyConverter()

Initializator signature: 

    public init(exchangeRatesAPIKey: String? = nil, urlSession: URLSession? = nil)

If an exchange rates API key is provided, it is set to the class's exchangeRatesAPIKey property. If no exchange rates API key is provided, the class attempts to retrieve an API key from a plist file using the ExchangeRatesAPIKey keyword.

If a URL session is provided, it is used to initialize the class's network manager.
If no URL session is provided, the class's network manager is initialized with the shared URL session.

### Methods:
There are three methods to choose from:

    func getExchangeRate(baseCurrency: Currency, targetCurrencies: [Currency], 
        resolve: @escaping ([String: Double]) -> Void, reject: @escaping (Error) -> Void)

This function uses the network manager to make a request to an exchange rates API, passing the base currency code and the target currency codes as parameters.

    func convert(amount: Double, baseCurrency: Currency, targetCurrency: Currency, 
        resolve: @escaping (Double) -> Void, reject: @escaping (Error) -> Void)

This function uses the exchange rate between the base currency and the target currency to convert the amount and returns the converted amount through the resolve closure. 

    func convert(amount: Double, baseCurrency: Currency, targetCurrencies: [Currency], 
        resolve: @escaping ([String : Double]) -> Void, reject: @escaping (Error) -> Void)

This function uses the exchange rate between the base currency and the target currencies to convert the amount to all the target currencies, it returns the converted amount in all the target currencies through the resolve closure as a dictionary.
