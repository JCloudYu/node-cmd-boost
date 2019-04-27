# Command Boost Library #
This library is designed to provide variety of tools implemented using Native Bash or Native NodeJS.

## How to use? ##
Well, all you have to do is run the following command to install the library globally. And the npm will handles the rest for you!
```bash
npm install -g cmd-boost
```

## What commands are provided in this library ? ##
Hmm, very little! Following list is the commands provided by the library!

### Commands ###
- **\[Bash\] incognito**  
	This cmd is an alias to _**ssh**_ command which by default will not
	remember and check any host key into .ssh directory. This is very convenient for one-time session.  
	
	Example:  
	```bash
	incognito root@127.0.0.1
	```
	
- **\[Bash\] lrun**  
	This cmd will bring up other command repetitively if the command failed and exit abnormally.  
	
	Example:  
	```bash
	lrun incognito -o ExitOnForwardFailure=yes -o ServerAliveInterval=10 -NL 1234:locahost:1234 root@127.0.0.1
	```
	 
- **\[Bash\] summon**
	This cmd will run other command and make the command be a daemon process.
	Note that the command will only run executable files.
	
	Example:  
	```bash
	summon beacon.sh 
	```

- **\[Bash\] njs**
	This cmd is an alias to _**node**_ command with --experimental-modules is enabled by default and the default esm loader is assigned.
	
	Example:  
	```bash
	njs module-written-in-es6-syntax.esm.js
	```

- **\[Node\] rpath**  
	This cmd is written in NodeJS and is designed to provide exactly the same behavior as [realpath](http://man7.org/linux/man-pages/man3/realpath.3.html) command.
	
	Example:  
	```bash
	rpath ./a/b/file
	```
