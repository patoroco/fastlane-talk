# [fit]Automatiza tu flow en
# [fit]iOS


Jorge Maroto García
*@patoroco*
![inline 25%](images/logotkt.png)


---


![inline 100%](images/fastlane-logo.png)


---


![125%](images/anounce-fabric.png)


---

![fit](images/anounce-android-support.jpg)

---


# [fit]Automatiza tu flow en
# [fit]~~iOS~~ *mobile*

Jorge Maroto García
*@patoroco*
![inline 25%](images/logotkt.png)


---


![inline 65%](images/fastlane-flows.png)


---


![inline 100%](images/spaceship.png)


---


![110%](gifs/spaceship-vs-scrapping.gif)


---


![inline 100%](images/fastlane-logo.png)


---


![inline](images/fastlane-ios-utils.png)


---


![inline 100%](images/fastlane-testflight-utils.png)


---


![inline 100%](images/fastlane-android-utils.png)


---


#and more ...
#[fit]https://github.com/fastlane/


---


### *Install*

#[fit]*`gem install fastlane`*

![102%](gifs/gem-install-fastlane.gif)


---


![](images/fastlane-help.png)


---


#[fit]`fastlane init`


---


![fit](images/fastlane-init.png)


---


![150%](images/fastlane-init-tree.png)


---


![fit](images/appfile.png)


---


# [fit] Fastfile

```ruby
lane :test do
	xctest( destination: "name=iPad 2" )
end
```


---


# [fit] DSL


---

![83%](images/actions-iterm.png)

# actions

#[fit] `fastlane actions`


---

![83% original](images/actions-iterm.png)


---


# Total 120 actions*

- https://github.com/fastlane/fastlane/blob/master/docs/Actions.md

- https://github.com/fastlane/fastlane/tree/master/lib/fastlane/actions

--
--
<sub>* last visit 27/11/2015</sub>


---

![fit](images/action-swiftlint.png)

---


#[fit] Example: crashlytics

#[fit] `fastlane action crashlytics`

![](images/fastlane_action_crashlytics.png)


---


![](images/fastlane_action_crashlytics.png)


---

# Example _crashlytics_


```ruby
lane :crashlytics do
  ipa( configuration: "Crashlytics" )
  crashlytics({
    ipa_path: Actions.lane_context[Actions::SharedValues::IPA_OUTPUT_PATH],
    groups: "Ticketea",
    notifications: "YES",
    notes_path: "./fastlane/crashlytics.txt"
  })

  slack({
    message: "Nueva versión de prueba de Box Office",
    channel: "@javiche",
    default_payloads: []
  })
end

```

---


```ruby

fastlane_version "1.41.1"

default_platform :ios

platform :ios do
  desc "Create app on iTunes Connect"
  lane :create_app do
    # be carefull with produce action, because apps created can't be deleted
    # from iTunes Connect (thanks Apple)
    produce(
      app_identifier: 'me.maroto.codemotion20152',
      app_name: 'prueba codemotion',
      language: 'Spanish',
      app_version: '1.0',
      sku: 'CODE20155', # if SKU is not specified, it will use a random one
    )
  end

  desc "Update certificates and use it on provisioning profiles"
  lane :update_certs do
    cert
    sigh(force: true)
  end
  
  ...
end

```

#[fit]https://github.com/patoroco/fastlane-talk/blob/master/fastlane/Fastfile


---


![87%](images/fastlane-lanes.png)


---



#[fit]Full flow

---


![](images/storyboard.png)


---

![inline 25%](images/produce.png)


---


![150%](images/produce-create.png)


---


![fit](images/produce-create-repeated.png)


---

![fit](images/produce-itunes-connect-1.png)


---


![fit](images/produce-itunes-connect-2.png)


---

![fit](images/produce-enable-services-help.png)


---


![fit](images/developer-center-entitlements.png)


---


![93%](images/produce-actions-help.png)


---

# Fastfile

```ruby

  lane :create_app do
    # be carefull with produce action, because apps created
    # can't be deleted from iTunes Connect (thanks Apple)

    produce(
      app_identifier: 'me.maroto.codemotion20152',
      app_name: 'prueba codemotion',
      language: 'Spanish',
      app_version: '1.0',
      sku: 'CODE20155',
    ) # if SKU is not specified, it will use a random one
  end


```


---

![inline 25%](images/sigh.png)
![inline 25%](images/cert.png)
![inline 25%](images/pem.png)


---


![fit](images/pem-use.png)


---


![fit](images/cert-use.png)


---


# Fastfile

```ruby
 desc "Update certificates and use it on provisioning profiles"
 lane :update_certs do
   cert
   sigh(force: true)
 end

 desc "Enable push if is needed"
 lane :enable_push do
   pem
   sigh(force:true)
 end

```


---


![inline 25%](images/gym.png)


---


# Gymfile

```ruby

clean true
silent true

buildlog_path './fastlane/logs/'
output_directory "./fastlane/builds"

```

---

# Fastfile

```ruby

 desc "Create an ipa with Debug configuration"
 lane :ipa_debug do
   gym(
     configuration: 'Debug',
     output_name: 'codemotion-debug.ipa'
   )
 end
 
 desc "Create an ipa with Release configuration"
 lane :ipa_release do
   gym(
     configuration: 'Release',
     output_name: 'codemotion-release.ipa'
   )
 end
 
```


---


![inline 25%](images/snapshot.png)


---

# SnapshotHelper.swift

```swift
import Foundation
import XCTest

var deviceLanguage = ""

func setLanguage(app: XCUIApplication)
{
    Snapshot.setLanguage(app)
}

func snapshot(name: String, waitForLoadingIndicator: Bool = false)
{
    Snapshot.snapshot(name, waitForLoadingIndicator: waitForLoadingIndicator)
}



@objc class Snapshot: NSObject
{
    class func setLanguage(app: XCUIApplication)
    {
        let path = "/tmp/language.txt"

        do {
            let locale = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
            deviceLanguage = locale.substringToIndex(locale.startIndex.advancedBy(2, limit:locale.endIndex))
            app.launchArguments += ["-AppleLanguages", "(\(deviceLanguage))", "-AppleLocale", "\"\(locale)\"","-ui_testing"]
        } catch {
            print("Couldn't detect/set language...")
        }
    }
    
    class func snapshot(name: String, waitForLoadingIndicator: Bool = false)
    {
        if (waitForLoadingIndicator)
        {
            waitForLoadingIndicatorToDisappear()
        }
        print("snapshot: \(name)") // more information about this, check out https://github.com/krausefx/snapshot
        
        sleep(1) // Waiting for the animation to be finished (kind of)
        XCUIDevice.sharedDevice().orientation = .Unknown
    }
    
    class func waitForLoadingIndicatorToDisappear()
    {
        let query = XCUIApplication().statusBars.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other)
        
        while (query.count > 4) {
            sleep(1)
            print("Number of Elements in Status Bar: \(query.count)... waiting for status bar to disappear")
        }
    }
}

```


---

# Snapfile

```ruby
# A list of devices you want to take the screenshots from
devices([
    "iPhone 6",
    "iPhone 6 Plus",
    "iPhone 5",
    "iPhone 4s",
])

languages([
  "en-US",
  "fr-FR",
  "es-ES"
])

# The name of the scheme which contains the UI Tests
scheme "codemotion2015UI"

# Where should the resulting screenshots be stored?
output_directory "./fastlane/screenshots"

```


---

# UITest

```swift

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

```


---


# Fastfile

```ruby

  lane :generate_snapshots do
    snapshot(
      clear_previous_screenshots: true,
    )
  end


```


---

![inline](images/snapshots-results.png)

---


![inline 25%](images/frameit.png)


---


`$ frameit`

--

<sub>https://developer.apple.com/app-store/marketing/guidelines</sub>


---


#[fit] Main window->English->iPhone 6 Plus
![inline fit](images/iPhone6Plus-01Main_framed.png)


---


#[fit] Second window->Spanish->iPhone 5
![inline](images/iPhone5-02Language_framed.png)


---


![fit](images/frameit-after.png)


---


![inline 25%](images/scan.png)


---


# Fastfile

```ruby

 desc "Runs test with scan"
 lane :scan do
   scan(
     scheme: 'codemotion2015',
     device: 'iPhone 6'
   )
 end


```


---


![fit](gifs/fastlane-scan.gif)


---


![inline 25%](images/deliver.png)


---


![fit](images/fastlane-crashlytics.png)


---


![fit](images/fastlane-beta.png)


---


#[fit]Demo


---


![inline 75%](images/pilot.png)


---


# Features

- upload build
- list builds
- manage test users


---


![fit](gifs/fastlane-pilot.gif)


--- 


![inline 45%](images/boarding.png)


---


# How

![inline](images/BoardingOverview.png)


---


![110%](gifs/BoardingSetup.gif)


---


![inline 25%](images/supply.png)
![inline fit](images/android.png)


---


# Links

- fastlane.tools/
- github.com/fastlane/***

--

- github.com/fastlane/fastlane/blob/master/docs/Actions.md


---


![right 126%](http://media.tumblr.com/tumblr_lnm1g25WsB1qdq5u6.gif)


#[fit]Thanks!

--

Jorge Maroto García
_@patoroco_

--

#[fit] github.com/patoroco/fastlane-talk