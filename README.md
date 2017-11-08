<a href="https://github.com/MagicalMike/message-broker"><img src="https://github.com/MagicalMike/message-broker/blob/master/res/logo.png" width="50%"/></a>
---

Message Broker is an OSX app developed in Swift 4 that uses TCP client-server communication to implement certain message broking functionalities, such as GET / PUSH requests, Publisher - Subscriber mechanics and advanced routing technologies.

The app uses [SwiftSocket](https://github.com/swiftsocket/SwiftSocket) for its TCP/UDP transport capabilities.  Visit [Protocol Description](https://github.com/MagicalMike/message-broker/blob/master/docs/protocol-description.md) for a in-depth explanation of the communication protocol used.

## Previews

<img src="https://github.com/MagicalMike/message-broker/blob/master/res/sender.png" alt="Sender" width="40%"/> <img src="https://github.com/MagicalMike/message-broker/blob/master/res/server.png" alt="Server" width="40%"/> <img src="https://github.com/MagicalMike/message-broker/blob/master/res/receiver.png" alt="Receiver" width="40%"/>


## Current Progress

### Message Queue:
- [x] Implement a communication protocol and describe it in a [markdown](docs/protocol-description.md) file;
- [x] Pick a transport protocol and argument your choice;
- [x] Implement the Message Queue;
- [x] Implement concurency to allow multiple sending / receiving;

### Storaging mechanism:
- [x] Serialize the message queue;
- [x] Store the queue in secondary memory;
- [x] Reestablish the queue if the server disconnects;

### Message routing mechanism:
- [x] Modify the communication protocol to allow for message routing;
- [x] Add multiple dynamic queues;
- [ ] Display explicit error message when user tries to access non-existent queue;
- [x] _Make protocol compatible with clients that don't use routing mechanisms;_
- [x] _Create persistent and non-persistent queues;_

### Publisher-Subscriber pattern:
- [x] Modify the communication protocol to support this pattern;
- [x] Implement subscriber mechanism;
- [ ] Display error if user subscribes to non-existant queue;

### Advanced message routing:
- [x] Modify the protocol so that it allows for multiple routing;

### Assignment 6: "Last will and testament" mechanism
- [ ] Subscribers must leave a message whenever they deconnect;
- [ ] Subscribers must set the "last will and testament" message and queue whenever they connect;
- [ ] Abnormal disconnections must be reported and "last will and testament" must be sent

