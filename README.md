# SuperMemo

SuperMemo2 method implemented in Swift

## Package.swift

```swift
.package(url: "https://github.com/swift-stack/supermemo.git", .branch("dev"))
```

## Memo
```swift
enum Response: Int {
    case blackout   // 0 - complete blackout.
    case incorrect  // 1 - incorrect response; the correct one remembered
    case mistake    // 2 - incorrect response; the correct one seemed easy to recall
    case difficult  // 3 - correct response recalled with serious difficulty
    case hesitation // 4 - correct response after a hesitation
    case perfect    // 5 - perfect response
}
```

## Usage

```swift
var item = SuperMemo2.Item()
item.apply(response: .difficult)
item.apply(response: .perfect)

assert(item.factor == 1.400...)
assert(item.repetition.number == 2)
assert(item.repetition.interval == 6)
```
