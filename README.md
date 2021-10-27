# CombineExpanded

Package that extends Combine with some useful APIs.

## New API:

* then
* shareReplay
* Future.deferred

## then

Wait for completion of `self`, *then* forward all events from `next`. All values sent from `self` are ignored.

```swift
let publisher1 = Future<Int, Never>.deferred { future in
    future(.success(1))
}.handleEvents(receiveCompletion: { _ in
    print("completed 1")
})

let publisher2 = Future<Int, Never>.deferred { future in
    future(.success(2))
}.handleEvents(receiveCompletion: { _ in
    print("completed 2")
})

publisher1.then(publisher2)
    .sink {
        print($0)
    }

// output: 
// completed 1
// 2
// completed 2
```

## shareReplay

Creates a new `Publisher` that will multicast values emitted by the underlying publisher, up to `bufferSize`. All clients of this `Publiher` will see the same version of the emitted values/errors.

The underlying `Publisher` will not be started until `self` is started for the first time. When subscribing to this producer, all previous values (up to `bufferSize`) will be emitted, followed by any new values.

```swift
let publisher = Future<Void, Never>.deferred { future in
    print("started")
    future(.success(()))
}.shareReplay(1)

publisher
    .sink(receiveCompletion: { _ in },
          receiveValue: {})
    .store(in: &cancellables)

publisher
    .sink(receiveCompletion: { _ in },
          receiveValue: {})
    .store(in: &cancellables)

// output:
// started
```

## Future.deferred

Delays `Future` start until it is subscribed.

```swift
let future = Future<Void, Error>.deferred { future in
    print("started")
    future(.success(()))
}
print("before")
future.sink(receiveCompletion: { _ in },
            receiveValue: { _ in })
    .store(in: &cancellable)
print("after")

// output:
// before
// started
// after
```