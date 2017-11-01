# Message Broker
## Introduction
This is a collection of apps built using Cocoa and Swift 4 for the OSX containing:
* The _Sender_ application, design to send messages to the server
* The _Server_ application, that receives, processes and sends messages to the _Receiver_
* The _Receiver_ application, that obtains and displays the messages

Message Broker uses [SwiftSocket](https://github.com/swiftsocket/SwiftSocket) for TCP socket communication.

## Current Progress

### Assignment 1: Message Queue
- [x] Implement a communication protocol and describe it in a [markdown](docs/protocol-description.md) file;
- [x] Pick a transport protocol and argument your choice;
- [x] Implement the Message Queue;
- [x] Implement concurency to allow multiple sending / receiving;

### Assignment 2: Storaging mechanism
- [ ] Serialize the message queue;
- [ ] Store the queue in secondary memory;
- [ ] Reestablish the queue if the server disconnects;

### Assignment 3: Message routing mechanism
- [ ] Modify the communication protocol to allow for message routing;
- [ ] Add multiple dynamic queues;
- [ ] Display explicit error message when user tries to access non-existent queue;
- [ ] _Make protocol compatible with clients that don't use routing mechanisms;_
- [ ] _Create persistent and non-persistent queues;_

### Assignment 4: Publisher-Subscriber pattern
- [ ] Modify the communication protocol to support pattern;
- [ ] Implement subscriber mechanism;
- [ ] Display error if user subscribes to non-existant queue;

### Assignment 5: Advanced message routing
- [ ] Modify the protocol so that it allows for multiple routing;

### Assignment 6: "Last will and testament" mechanism
- [ ] Subscribers must leave a message whenever they deconnect;
- [ ] Subscribers must set the "last will and testament" message and queue whenever they connect;
- [ ] Abnormal disconnections must be reported and "last will and testament" must be sent

## Help
Use the links below to access a more in-depth explanation of each app: [**Not yet implemented.**]
* [Sender Documentation](https://www.youtube.com/watch?v=nowXNscWa20)
* [Server Documentation](https://www.youtube.com/watch?v=nowXNscWa20)
* [Receiver Documentation](https://www.youtube.com/watch?v=nowXNscWa20)
