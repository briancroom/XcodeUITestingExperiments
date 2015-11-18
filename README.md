# XcodeUITestingExperiments
With Xcode 7, Apple introduced a new test runner and extended its XCTest framework to enable creating integration tests for apps, and refers to it as "UI Testing". Although this new system is superficially similar to popular 3rd-party integration testing tools like [KIF](https://github.com/kif-framework/KIF), it differs architecturally in that the tests are run in a separate process than the app being tested. This divide between the tests and the app strongly encourages a black-box based approach to testing, with support for programmatically interacting with the app's UI through an Objective-C/Swift API on top of iOS' existing accessibility framework.

Although there are strong advantages to black-box testing, there are some scenarios in which there is insufficient flexibility to efficiently set up a testing scenario and make assertions regarding the app's behavior. This repo contains a number of projects illustrating potential approaches to cracking open the box a little bit, or otherwise providing a suitable environment for writing controlled tests.

**NOTE:** Some of the approaches used here involve injecting code into the tested app in order to inspect or modify the internal state of the app. This will make your tests dependent on implementation details of the app, which is undesirable. Consider these techniques to be a last resort if you are unable to craft a workable test by interacting with your app's UI through the `XCUI*` API. *With that disclaimer out of the way, read on for the fun stuff!*

## The Experiments

### NetworkStubbingExperiment
Many apps depend on communicating with an external web service of some sort for storing and retrieving data. When writing automated tests for such an app, there can be significant downsides to having the app communicate with the live web server:

* It can make test execution much slower than otherwise possible
* It prevents tests from being run in an offline environment
* It poses challenges in setting up particular scenarios for tests

Spinning up a test-specific HTTP server for the app to communicate with during tests is an attractive alternate strategy. The `NetworkStubbingExperiment` illustrates this embedding the `GCDWebServer` framework inside a UI test bundle and starting an instance before launching the app under test. An environment variable is used to instruct the app to use `localhost` as the base URL for its HTTP requests.

It contains an example of stubbing a `GET` request to return a particular bit of data, as well as setting up a spy for a `POST` request and asserting that the app sent a particular piece of data as a part of its request.

*This strategy is minimally invasive to the tested app and can be used without reservation.*

**Techniques:**

* Injecting configuration data into the tested app via an environment variable
* Mocking an external service within the test bundle

### FileSystemManipulation
When running a test, it is important that the app begin in a known state. Persistent state can be easily polluted by previously-run tests, and executing actions in the UI to reset the state is prohibitively slow in some situations. This experiment illustrates a mechanism for making modifications to the tested app's file system very early in the lifecycle of the app by utilizing code injection via the `DYLD_INSERT_LIBRARIES` environment variable. This technique could provide a shortcut for resetting persisted state.

**Techniques:**

* Injecting utility code into the tested app
* Configuring the utility code with the command pattern, delivered via an environment variable

### SystemLogQuery
Making assertions about the internal state of the tested app is occasionally the most practical way to write a test. This experiment illustrates using code injection and the Darwin notification center to get the tested app to dump key pieces of internal data to the system log, and then reading that data in the test process.

**Techniques:**

* Injecting utility code into the tested app
* Lightweight IPC with the Darwin notification center
* Data transfer using the Apple System Log