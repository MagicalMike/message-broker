# Protocol Description

## Overview
This markdown describes the communication protocol used in the Message Broker apps.
The protocol uses JSON to serialize/deserialize the content and is converted to a Data object to be passed
to or from the server.

## Structure
The communication protocol can be displayed as a JSON as follows:
```json
{
    "Command":"<PUT|GET|COUNT|RESPONSE|ERROR>"
    "Content": <content>
}
```
or as a Swift array of dictionaries like this:

```swift
    let json = [
        "Command": Command.put.rawValue,
        "Content": content
    ]
```
The keys are described as follows:
* **Command** - a instruction that the server/clients use to identify the actions they need to take;
* **Content** - a string message that represents the payload of the data;

## Commands
* **PUT** - adds a message to the message queue;
* **GET** - retrieves the most recent message from the queue;
* **COUNT** - retrieves the number of messages of the queue;
* **RESPONSE** - sent by the server as a successful response to a client command;
* **ERROR** - sent by the server as a failed request to a client command;


