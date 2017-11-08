<a href="https://github.com/MagicalMike/message-broker"><img src="https://github.com/MagicalMike/message-broker/blob/master/res/logo.png" width="50%"/></a>
---

Message Broker is an OSX app developed in Swift 4 that uses TCP client-server communication to implement certain message broking functionalities, such as GET / PUSH requests, Publisher - Subscriber mechanics and advanced routing technologies. The app uses [SwiftSocket](https://github.com/swiftsocket/SwiftSocket) for its TCP/UDP communication capabilities. See below for more information about the app and what it can do.

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
