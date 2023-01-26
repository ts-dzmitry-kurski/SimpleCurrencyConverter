# SimpleCurrencyConverter
Simple and lightweight framework that provides developers with ready-made methods for obtaining currency rates and conversions. At the moment, operations with the following monetary units are supported: **JPY, USD, EUR, GBP**.

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

**Warning!** **The runtime configuration values take precedence over build-time configuration."**

## Usage:

