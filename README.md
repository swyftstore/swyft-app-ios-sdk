# swyft-app-ios-sdk

This project is to be used by a 3rd party iOS application, inorder to integrate with a Swyft Vission Cabinet


### Table of Contents 
- [Setup](#setup)
  - [Request SDK Credentials](#creds)
  - [Installation](#install)
- [Usage](#usage)
  - [SDK Initilization](#init)
  - [User Enrollment](#enroll)
  - [User Authentication](#auth)
  - [Get User Orders](#orders)
  - [Get User Payment Methods](#pMethods)
  - [Add User Payment Method](#addPMethod)
  - [Update User Payment Method](#updatePMethod)
  - WIP
- [Webhooks](#webhooks)
  - [Session Begins](#webhookBegins)
  - [Session Ends](#webhookEnd)

<a name="setup"/>

## Setup 

Before using the Swyft SDK you will need request access credentials and install the library into your project

<a name="creds"/>

### Request SDK credentials 

In order to use the SDK you need to request credentials by supplying swyft with your Applications Bundle ID. The credentials will should be stored in a pList file that you will need to include in your applications build path. 

Sample JSON file swyft-sdk.json
```xml
<key>TERMINAL_ID</key>
<string>00000001</string>
<key>PAYMENT_SECRET</key>
<string>fasfefveeveve23rf3vc3d232223344567898</string>
<key>SWYFT_SDK_AUTH_KEY</key>
<string>fasdfasfef3cevwe3qf3q4fewvq3f34tg4gv4v4v45v</string>

```
<a name="install"/>

### Installation

To include the Swyft SDK in your project, add the following to your Podfile

```javascript
# SwyftSdk
  pod 'SwyftSdk', '~> 1'
```

Note: we haven't decided if we want to publish our sdk to cocopods or distribute through more closed channels 

<a name="usage"/>

## Usage

Below you will find some code examples for how you can intergate the sdk with your application

<a name="init"/>

### SDK Initilization

The first step when integrating the Swyft SDK with your project is to the initializion methond on the skd. We recommend doing this on your main activities onCreate method. The initializion methond takes in the application context that is used to access some local resources within the SDK. 
```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    SwyftSdk.initSDK(getApplicationContext());
}
```

<a name="enroll"/>

### Enroll User 

The next is to enroll your applications user with Swyft. This is used to track the user's orders and paymentment methods. The method returns a swyftId that is used to authenticate the user later on. If the user already exist the SDK blocks the creation of a duplicate user and returns the swyftId successfully. 
```swift
let customerInfo = SwyftUser(
    email: "user@swyftstores.com",
    firstName: "John",
    lastName: "Smith",
    phoneNumber: "+1 1234567890")
        
SwyftSdk.enrollUser(user: customerInfo, success: { response in  
    //store swyftId for later usage
    self.swyftId = response.swyftId                      
}) { error in
    debugPrint(error)        
}
    
```    
<a name="auth"/>

### User Authentication 

After you have enrolled a user you can authenticate the user. This creates a session for the user so they can interact with the Swyft Vision Cabinet by scanning a QR Code returned by the sdk for your application to display. You can either supply an authentication string for the SDK to display as a QR Code or have the SDK generate a dynamic one for you. You can set the qrCode foreground color by passing in the UIColor value you wish to use.

- Auto Generated QR Code
```java
 SwyftSdk.authenticateUser(swyftId: self.swyftId, qrCodeColor: self.view.tintColor, customAuth: customAuth, success: { response in
  DispatchQueue.main.async {
      //display the returned qrCode UIImage
      self.qrCodeImage.image = response.qrCode
  }

}) { error in
  debugPrint(error)
}
}); 
``` 
- Custom Generated QR Code
```swift
 SwyftSdk.authenticateUser(swyftId: self.swyftId, qrCodeColor: self.view.tintColor, success: { response in                        
    DispatchQueue.main.async {
        //display the returned qrCode UIImage
        self.qrCodeImage.image = response.qrCode
    }

}) { error in
    debugPrint(error)
}
```

<a name="orders"/>

### Get User Orders

After athenticating a user you can retrieve their past orders. Orders will be returned in a paginated list. 
```swift

```
<a name="pMethods"/>

### Get User Payment Methods

If Swyft handling the payment processing for your integration, after you authenticate the user you can retreive a list of their previously enrolled payment methods
```swift

```

<a name="addPMethod"/>

### Add User Payment Methods

If Swyft handling the payment processing for your integration, after you authenticate the user you can add additional payment methods for the user
```swift

```
<a name="updatePMethod"/>

### Update User Payment Methods

If Swyft handling the payment processing for your integration, after you authenticate the user you can update payment methods for the user
```swift

```

WIP

<a name="webhooks"/>

## Webhooks

Ontop of the Swyft Client SDK we have a pair of webhooks that you can choose to integrate with. The webhooks can alert you eachtime one of your users begin a session with a Swyft Vision Cabinet, as well as once the session ends and its transaction details. If you wish to intgrate with the Swyft Vision Cabinet webhooks below are the payloads you can expect once you supply Swyft with your end points. 

<a name="webhookBegins"/>

### Session Begins

Session Begins WebHook Payload
```javascript
payload: {
  email_address:String,
  preauth_amount: String,
  storeId: String,
  customerId: String
}

```

<a name="webhookEnd"/>

### Session Ends

Session Ends WebHook Payload
```javascript
payload: {
  email_address:String,
  products: Array,
  store_id: String,
  customer_id: String,
  subtotal: String,
  tax: String,
  total: String
}
```
