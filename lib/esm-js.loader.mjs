/**
 * I've been encountered a stupid situation in which I want to write es module compatible libraries that
 * can be shared between nodejs and browser, but I have to rename my file in mjs to enable es module in nodejs
 * and at the same time, I have to provide correct mime type to make the browser accepts files ended with .mjs
 * extension. Here's why this module comes out! This module makes the nodejs environment accept files ended with
 * .esm.js to be a es module. Then I don't have to modify the server to tell the browser what a .js file is!
**/
// Source: https://gist.github.com/JCloudYu/87b4a5caff65320557452167e3466dbb

import process from 'process';
import os from 'os';


// ES Modules' identifier is renamed into 'module' after NodeJS v12
const NODEJS_VERSION = process.versions.node.split('.');
const ESM_IDENTIFIER = (NODEJS_VERSION[0] >= 12) ? 'module' : 'esm';


const IS_WINDOWS = (os.platform().substring(0,3) === "win");
const IS_WIN_ABSOLUTE_PATH = /^[a-zA-Z]:\/[^/].*$/;
const PATHS = [
	null,	// Reserved for main module dir
	null,	// Reserved for main module path
	`file://${IS_WINDOWS?'/':''}${process.cwd()}/`
];

export function resolve(specifier, parentModuleURL, defaultResolve) {
	// This specifier must be the main module with absolute path! (Without leading file://)
	if ( parentModuleURL === undefined ) {
		/**
		 * We don't need to detect the leading C:/ in windows env here...
		 * It has been processed to /C:/Users/XXX/Desktop/xxx.mjs already...awkward = =+
		**/
		const _MAIN_MODULE_PATH = PATHS[1] = `file://${specifier}`;
		const DIVIDER_POS = _MAIN_MODULE_PATH.lastIndexOf('/')+1;
		PATHS[0] = _MAIN_MODULE_PATH.substring(0, DIVIDER_POS);
		specifier = `./${_MAIN_MODULE_PATH.substring(DIVIDER_POS)}`;
	}
	
	
	
	// Prevent falsy absolute path in Windows environment ( such as C:/ )
	if ( IS_WINDOWS && IS_WIN_ABSOLUTE_PATH.test(specifier) ) {
		specifier = `file:///${specifier}`;
	}

	// Path started with / means the path init from the directory of main module
	// Path started with // ( double /) means the path init from node_modules near the main module
	// This mechanism is used to follow the rule in browser environment ( path started from / means from host root )
	if ( specifier.substring(0, 2) === "//" ) {
		specifier = `${PATHS[0]}node_modules/${specifier.substring(2)}`;
	}
	else
	if ( specifier[0] === "/" ) {
		specifier = `${PATHS[0]}${specifier.substring(1)}`;
	}
	else {
		specifier = new URL(specifier, parentModuleURL||PATHS[0]).href;
	}
	
	
	
	if ( specifier.substr(-7) === ".esm.js" ) {
		return { url: specifier, format:ESM_IDENTIFIER };
	}
	
	return defaultResolve(specifier, parentModuleURL);
}
