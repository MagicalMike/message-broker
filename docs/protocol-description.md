# Protocol Description

## Overview

This markdown describes the communication protocol used in the Message Broker apps.
The protocol uses JSON to serialize/deserialize the content and is converted to a Data object to be passed
to or from the server.

The JSON object is being passed using the TCP protocol to ensure data integrity.

## Structure
The communication protocol can be displayed as a JSON as follows:
```json
{
    "Command"  : "<PUT|GET|COUNT|RESPONSE|ERROR>",
    "Queues"   : ["<queue>"],
    "Contents" : ["<content>"]
}
```
or as a Swift array of dictionaries like this:

```swift
    let json = [
        "Command" : Command.put.rawValue,
        "Queues"  : [queue],
        "Contents": [content]
    ]
```
The keys are described as follows:
* **Command** - a instruction that the server/clients use to identify the actions they need to take;
* **Queues** - a set of queues which are affected by the command;
* **Contents** - a set of string messages that are being sent to and from the server;

## Commands
* **PUT** - adds a message to the message queue;
* **GET** - retrieves the most recent message from the queue without removing it;
* **COUNT** - retrieves the number of messages of the queue;
* **REMOVE** - removes the last message from the specified queues;
* **SUBSCRIBE** - subscribes to one or more queues, thus automatically getting all new messages;
* **RESPONSE** - sent by the server as a successful response to a client command;
* **ERROR** - sent by the server as a failed request to a client command;


