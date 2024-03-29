# Segment-Castle
Add Castle real-time monitoring support to your applications via his plugin for [Analytics-Swift](https://github.com/segmentio/analytics-swift).

## Adding the dependency

### via Xcode
In the Xcode `File` menu, click `Add Packages`.  You'll see a dialog where you can search for Swift packages.  In the search field, enter the URL to this repo.

[https://github.com/castle/analytics-ios-integration-castle](https://github.com/castle/analytics-ios-integration-castle)

You'll then have the option to pin to a version, or specific branch, as well as which project in your workspace to add it to.  Once you've made your selections, click the `Add Package` button.  

### via Package.swift

Open your Package.swift file and add the following do your the `dependencies` section:

```
.package(
    name: "SegmentCastle",
    url: "https://github.com/castle/analytics-ios-integration-castle",
    from: "1.0.0"
),
```

## Using the Plugin in your App

Open the file where you setup and configure the Analytics-Swift library.  Add this plugin to the list of imports.

```
import Segment
import SegmentCastle // <-- Add this line
```

Just under your Analytics-Swift library setup, call `analytics.add(plugin: ...)` to add an instance of the plugin to the Analytics timeline.

```
let analytics = Analytics(configuration: Configuration(writeKey: "<YOUR WRITE KEY>")
                    .flushAt(3)
                    .trackApplicationLifecycleEvents(true))
analytics.add(plugin: CastleDestination(userJwt: "<USER_JWT>"))
```

Your events will now be automatically sent to Castle.
