---
layout: post
header: Some Thoughts on Chat Apps
---
 
__Foreword__

Given my trials over the years with multiple different software and computer ~~issues~~ _learning experiences_, people often approach with inquiries about which app/website might best for doing "X". Since I've gotten similar questions about similar topics from different crowds, I decided I'll put all my thoughts on the topic in one spot so I can accurately and consistently present information. 

So for today this spot is for Quin talking about messaging applications and chat apps.

# Thoughts Here!

Part of my reasoning behind this post is to inspire thought about the day-to-day tools we use. When it comes to communications we participate in during day-to-day proceedings, we already use a swiss army knife of apps and websites to share information. 

I think about how a lot of these "modern day" communication methods seem to not consider privacy, data ownership and sovereignty or other potential issues like company aqusitions and other small legal details that leave the common persons exposed to surveillance, hacking and data theft.

If we were simply sending silly jokes and cat memes to eachother 24/7 then this might not be too much of a big deal. But we use these communication channels for Bank verification codes, making plans with friends and family, communication with lawyers and other private parties. Information passed between two parties that trust eachother. But with man in the middle attacks like SIM Cloning or corporate surveillance, anyone can read your plans, your verification codes and your other personal direct messages. For example Cloning SIM cards is a proven and common practice that malicious actors utilize to take over someones life with a simple phone number. 



Well tl;dr there's 3 realistic options when it comes to privacy/dataownership. Signal, Matrix and E-mail, though email doesn't have a lot going for it :/

Discord, Telegram, Snapchat, Facebook, Whatsapp are all private corporate garbage.

### #1 Signal

Signal is the best of the best when it comes to security and privacy. They have a proven history of not serving any data to the US Gov when served subpoena. The trick is that they collect 0 data, so even if they were hacked, all the e2ee and untracked data transports make it impossible for them to have any information on any of their users. [They also list all their interactions with the fed!](https://signal.org/bigbrother/)

### #2 Matrix

Matrix is next best, there's some murmurs of some encryption issues with how keys/data is handled on the server implementatitons possibly hinting at some security vulnerabilities. But up till the day of this post it seems that this is just conjecture for now. I'll be keeping an eye on the murmurs because I care about things like that :/

Matrix has a discord type setup where there's multiple servers and DMs, there's voice chats and video calls/groups. It's federated so all the data can be owned and operated by a private server if desired but the open/free community options are also good! It's free and very useable _BUT_ there's a few ODD things about matrix.

_Odd thing #1_

You will not find an app called "Matrix" related to a chat app. Matrix is actually the name of the chat protocol. This protocol is open source and can be used by any app creator that'd like to use the foundational functions of the Matrix protocol in their own individual applications. This means I could be using the [ElementX](https://element.io/en/download) chat app and you could be using [Fluffychat](https://fluffychat.im/en/) and we'd be able to seamlessly communicate despite using different applications. For a complete list of Matrix compatible chat applications check [HERE](https://matrix.org/ecosystem/clients/)

_Odd thing #2_

Device verification. When you create a matrix account and sign into one of your selected apps it'll likely ask you to sign in with a second device at some point to verify your devices. This is part of some cool background encryption stuff to keep your data secure and even though it's more work, it keeps prying eyes like governments and corporations out of your personal chats/calls.

### #3 E-Mail

E-Mail, we all know it, we allllllll love it.
There's quite a bit of things that go into email and to be honest I hardly understand it. But from whawt I do know it is not like the other two options in this post. E-Mail leaves such a big breadcrumb trail of personal information, from IP's, tracking information, potential 3rd party tracking pixels / scripts. There are so many different spots your information can get left when an email is finding it's way from one outbox to an inbox.

But given all of this it still powers much of the internet. Almost every service or tool requires an email. For this I can only recommend two tools to keep yourself in-touch with the world wide web while also keeping your attack surfaes<sup>1</sup> limited.

#### Tuta

[https://tuta.com](https://tuta.com)

Tuta is a cloud service provider centralized around Privacy and data sovergnty. Tuta is Open source, E2EE<sup>2</sup> and a bunch of other great things, I cannot recommend moving your email to this provider enough. Check out more of the fun security stuff [here](https://tuta.com/security)

#### E-Mail Proxy service

Another tool that I consider required these days is an email proxy service. For the un-initiated, it basically is like a PO box for your email. You can generate a bunch of random emails for your logins and different accounts to prevent reusing emails for all the different services and applications.

There's quite a few reasons why someone might want to proxy their email. You could use this in conjunction with email filters to more easily direct emails from specific services/people to folders. But the #1 reason I use an Email proxy is privacy. It allows me to abstract and block malicious services from sending me spam. If I unsubscribe from an email it doesn't ensure that I don't get spammed anymore. But if my proxy disables the randomly generated address, then the email will never find a destination to begin with, thus preventing spam.

I use [Firefox Relay](https://relay.firefox.com) but there's other proxies out there, I'm sure you can find em :)

### Definitions

`Attack Surface`<sup>1</sup>:
A practice, piece of information or exposed data that could be mitigated to prevent threat actors from obtaining more robust data regarding your online footprint.

`E2EE`<sup>2</sup>:
E2EE is an abbreviation for End to End Encryption. This is the practice of keeping data encrypted before and after storing it. This practice is not common in many applications, but it is critical for ensuring that any leaked data would be useless to threat actors.
