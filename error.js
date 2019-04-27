(()=>{
	"use strict";

	process.stderr.write( "This module is not designed to be used as dependencies!\n" );
	process.stderr.write( "Please use following command to install and register global commands!\n" );
	process.stderr.write( "    npm install -g cmd-boost" );
	process.exit(1);
})();
