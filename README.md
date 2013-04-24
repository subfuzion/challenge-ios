Introduction
------------
[Challenge.gov][1] is an online challenge platform administered by the [U.S. General Services Administration][2] (GSA) in partnership with [ChallengePost][3] that empowers the U.S. Government and the public to bring the best ideas and top talent to bear on our nation’s most pressing challenges. This platform is the latest milestone in the Administration’s commitment to use prizes and challenges to promote innovation.


What is a Challenge?
--------------------
A challenge is exactly what the name suggests: it is a challenge by one party (a “seeker”) to a third party or parties (a “solver”) to identify a solution to a particular problem or reward contestants for accomplishing a particular goal. Prizes (monetary or non–monetary) often accompany challenges and contests.

Challenges can range from fairly simple (idea suggestions, creation of logos, videos, digital games and mobile applications) to proofs of concept, designs, or finished products that solve the grand challenges of the 21st century.

For more information, visit [Challenge.gov][1].


What is this project about (challenge-ios)?
-------------------------------------------
This is an open source project to provide an iPhone app for accessing challenges, similar in functionality provided by the [Challenge.gov search portal][4].

The main goals of this project are to demonstrate providing a service wrapper over an existing federal data source and to facilitate mobile app development. As a proof-of-concept, the companion GitHub-hosted project, [challenge-api][5], is a Node application that provides the REST API to provide additional search and sort functionality over the raw XML feed available at [Challenge.gov][1].


Technical Overview
------------------
The iPhone app accesses JSON data over REST APIs provided by the [challenge-api][5].


License
-------
(The MIT License)

Copyright (c) 2013 Tony Pujals and Tenny Susanto (until transferred to GSA)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[1]:  http://challenge.gov/
[2]:  http://www.gsa.gov/portal/category/100000/
[3]:  http://challengepost.com/
[4]:  http://challenge.gov/search
[5]:  https://github.com/tonypujals/challenge-api


