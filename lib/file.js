var clients = {}


// WebSockets - Using Sockets.io - Below This:
io.on('connection', (socket) => {
    console.log('New user connected!');

    //WebSocket for recording Socket items of the users!
    socket.on('start-session', (uid) => {
        // Assigning id to the socket for easy accessing the sockets
        // This is going to help process each socket seam lessly
        // Rather than using other techniques that we tested earlier.
        clients[uid] = socket;
    });

    socket.on('message', async (sendMessage) => {
        // console.log("USER: ", clients[sendMessage.recepient.uid]);
        if (clients[sendMessage.recepient.uid]) {
            // console.log(sendMessage);
            var myquery = { "users": { $all: [sendMessage['sender']["uid"], sendMessage['recepient']["uid"]] } }
            var chat = await ChatMessage.findOne(myquery);
            if (chat) {
                if (sendMessage['file'] != null) {
                    // User sends a file in the message
                    var fileName = Date.now().toString() + '-' + sendMessage["file_type"].replace(/\s/g, '-');
                    var fileLocalLocation = process.cwd() + "\\temp\\" + fileName;

                    var base64Data = sendMessage["file"].replace(/^data:image\/png;base64,/, "");

                    await fs.promises.writeFile(fileLocalLocation, base64Data, 'base64', function (err) {
                        console.log(err);
                    });

                    const fileContent = await fs.promises.readFile(fileLocalLocation);

                    console.log("File", fileContent.length);


                    // var fileLocation = "";

                    const params = {
                        Bucket: process.env.AWS_BUCKET_NAME,
                        Key: fileName,
                        Body: fileContent,
                        acl: 'public-read'
                    }

                    //Upload the image to S3 Bucket
                    s3.upload(params, function (err, data) {
                        console.log("Inside s3 upload");
                        if (err) {
                            fs.unlinkSync(fileLocalLocation);
                        }

                        fs.unlinkSync(fileLocalLocation);
                        // fileLocation = "https://sdc1.storage.serverius.net/safepall:safepall/" + fileName;
                        sendMessage['file'] = fileName;
                        var myQuery = { "users": { $all: [sendMessage['sender']["uid"], sendMessage['recepient']["uid"]] } };
                        var newValues = { $push: { messages: sendMessage } }
                        ChatMessage.updateOne(myQuery, newValues, function (error, value) {
                            if (error) {
                                console.log(error);

                            } else {
                                console.log("Message send success!");
                            }
                        });
                    });


                } else {
                    // User sends a simple message

                    var myQuery = { "users": { $all: [sendMessage['sender']["uid"], sendMessage['recepient']["uid"]] } };
                    var newValues = { $push: { messages: sendMessage } }
                    ChatMessage.updateOne(myQuery, newValues, function (error, value) {
                        if (error) {
                            console.log(error);

                        } else {
                            console.log("Message send success!");
                        }
                    });
                }

            }
            // else {
            //     const chatObject = ChatMessage(
            //         {
            //             "users": [
            //                 sendMessage['sender']["uid"],
            //                 sendMessage['recepient']["uid"]
            //             ],
            //             "messages": sendMessage,
            //         }
            //     );

            //     chatObject.save(function (error, value) {
            //         if (error) {
            //             console.log(error);

            //         } else {
            //             console.log("Chat saved successfully");
            //         }
            //     });
            // }
            clients[sendMessage.recepient.uid].emit("message", sendMessage);

        } else {
            // TODO: Save message if user is not live;
            if (sendMessage['file'] != null) {
                // User sends a file in the message
                var fileName = Date.now().toString() + '-' + sendMessage["file_type"].replace(/\s/g, '-');
                var fileLocalLocation = process.cwd() + "\\temp\\" + fileName;

                var base64Data = sendMessage["file"].replace(/^data:image\/png;base64,/, "");

                await fs.promises.writeFile(fileLocalLocation, base64Data, 'base64', function (err) {
                    console.log(err);
                });

                const fileContent = await fs.promises.readFile(fileLocalLocation);

                console.log("File", fileContent.length);


                // var fileLocation = "";

                const params = {
                    Bucket: process.env.AWS_BUCKET_NAME,
                    Key: fileName,
                    Body: fileContent,
                    acl: 'public-read'
                }

                //Upload the image to S3 Bucket
                s3.upload(params, function (err, data) {
                    console.log("Inside s3 upload");
                    if (err) {
                        fs.unlinkSync(fileLocalLocation);
                    }

                    fs.unlinkSync(fileLocalLocation);
                    // fileLocation = "https://sdc1.storage.serverius.net/safepall:safepall/" + fileName;
                    sendMessage['file'] = fileName;
                    var myQuery = { "users": { $all: [sendMessage['sender']["uid"], sendMessage['recepient']["uid"]] } };
                    var newValues = { $push: { messages: sendMessage } }
                    ChatMessage.updateOne(myQuery, newValues, function (error, value) {
                        if (error) {
                            console.log(error);

                        } else {
                            console.log("Message send success!");
                        }
                    });
                });


            } else {
                // User sends a simple message
                var myQuery = { "users": { $all: [sendMessage['sender']["uid"], sendMessage['recepient']["uid"]] } };
                var newValues = { $push: { messages: sendMessage } }
                ChatMessage.updateOne(myQuery, newValues, function (error, value) {
                    if (error) {
                        console.log(error);

                    } else {
                        console.log("Message send success!");
                    }
                });
            }
            // else {
            //     const chatObject = ChatMessage(
            //         {
            //             "users": [
            //                 sendMessage['sender']["uid"],
            //                 sendMessage['recepient']["uid"]
            //             ],
            //             "messages": sendMessage,
            //         }
            //     );

            //     chatObject.save(function (error, value) {
            //         if (error) {
            //             console.log(error);

            //         } else {
            //             console.log("Chat saved successfully");
            //         }
            //     });
            // }
        }
    });

    socket.on('get-chats', async (uid) => {
        // TODO: emit all chats
        var myQuery = { "users": uid };
        const chats = await ChatMessage.find(myQuery);
        emit("get-chats", chats);
    });
});