# CompoundFetchedResultsController

[![Version](https://img.shields.io/cocoapods/v/CompoundFetchedResultsController.svg?style=flat)](http://cocoadocs.org/docsets/CompoundFetchedResultsController)
[![License](https://img.shields.io/cocoapods/l/CompoundFetchedResultsController.svg?style=flat)](http://cocoadocs.org/docsets/CompoundFetchedResultsController)
[![Platform](https://img.shields.io/cocoapods/p/CompoundFetchedResultsController.svg?style=flat)](http://cocoadocs.org/docsets/CompoundFetchedResultsController)
[![Swift version](https://img.shields.io/badge/Swift-4.2-orange.svg)](https://cocoapods.org/pods/CompoundFetchedResultsController)

This is a collection of classes that ultimately allows you to combine multiple sources of data such as static `Array`'s and `NSFetchedResultsController`'s into one big NSFetchedResultsController.

## Demo

To try the example project, just run the following command:

    pod try CompoundFetchedResultsController

## Requirements

Requires Swift 4 and iOS 8 or higher.

## Installation

### From CocoaPods

CompoundFetchedResultsController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "CompoundFetchedResultsController"

### Manually

* Drag the `CompoundFetchedResultsController/Source` folder into your project.

## Usage

### Creating the FRC

First, create your own FRC's that you want to ultimately combine, using whichever method you prefer. Then, just call the initializer as follows:

    let controllers = [
      myController1,
      myController2,
      myController3
    ]
    let frc = CompoundFetchedResultsController(controllers: controllers)

The newly created FRC can be used as you would any other FRC in UITableViewController, UICollectionViewController, etc... Just be careful that you might be mixing fetched result types and handle those cases accordingly.

**Important note**: You might encounter issues if you're mixing FRCs that might notify about multiple parallel imports at the same time. In those cases it's recommended to only use `reloadData()` on your table/collection view to avoid crashes in UIKit.

### Static FRCs

This library provides a class for creating a FRC using static data, simply called `StaticFetchedResultsController`. Use it as follows:

    let objects = [
      myObject1,
      myObject2,
      myObject3
    ]
    let frc = StaticFetchedResultsController(items: objects, sectionTitle: "My Static Section")

Should you modify the items property, an `update section` event will be triggered for the FRC's delegate.

**Important note**: The provided objects must be instances of NSObject subclasses.

### Static FRCs with value types

Should you want to work with Swift value types, there is also a generic `ValueFetchedResultsController`:

    let values: [MyValueType] = [
      myValue1,
      myValue2,
      myValue3
    ]
    let frc = ValueFetchedResultsController(values: values, sectionTitle: "My Static Section")

The values will automatically be wrapped into a simple generic `ValueWrapper` object. You can at a later point retrieve a value using:

    if let wrapper = frc.object(at: indexPath) as? ValueWrapper<MyValueType> {
      let value = wrapper.value
      ...
    }

## Credits

CompoundFetchedResultsController is brought to you by [David Jennes](https://twitter.com/davidjennes).

## License

CompoundFetchedResultsController is available under the MIT license. See the LICENSE file for more info.
