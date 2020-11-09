# MyBank
An iOS app written with clean architecture &amp; unit testing 

A simple app that demonstrates some examples of clean architecture, code organisation, loose coupling, unit testing and some of the best practices used in modern iOS programming using Swift.
App Goal:
• Show account details after fetching from network
• Load a list of transactions grouped by dates under the account details
• Transactions are divided as cleared and penning but they show together in correct order grouped by dates to show transactions of the same day under one section
• Pull to refresh the view to load latest data and show a loading indicator
• Show error alerts when there in an issue
• Make sure all devices and orientations are supported (use size class)
• Some of the transactions are ATM based and they show location icon and tapping those transactions navigate to the ATM location page on a map view
The data for the account details + transaction history + atm locations are all combined together and comes from the this json file at: https://www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1
The code also pulls this data locally from a JSON file if needed and used for testing, debugging purposes, Particularly XCUITest picks the data from a local stubbed JSON file.
Screenshots: Remote data
    
Screenshots: Local JSON data
  Dark mode support (in landscape mode)
Installation
• Xcode 11.6+ (required)
• Clean /DerivedData folder if any
• Build the project and let the Swift Package Manager pulls two remote libraries used
for unit testing – Quick & Nimble
    
3rd Party Libraries (only in unit testing)
• Quick - To unit test as much as possible 🤫
• Nimble - To pair with Quick 👬

