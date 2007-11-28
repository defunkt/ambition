CodeHighlighter.addStyle("ruby",{
	comment : {
		exp  : /(#[^\n]+)|(#\s*\n)/
	},
	brackets : {
		exp  : /\(|\)/
	},
	string : {
		exp  : /'[^']*'|"[^"]*"/
	},
	keywords : {
		exp  : /\b(extend|def|module|class|require)\b/
	},
	expression : {
		exp  : /\b(do|end|if|yield|then|else|for|trap|exit|until|unless|while|elsif|case|when|break|retry|redo|rescue|raise)\b|\bdefined\?/	},
	/* Added by Shelly Fisher (shelly@agileevolved.com) */
	symbol : {
	  exp : /([^:])(:[A-Za-z0-9_!?]+)/
	},
	constant : {
	  exp : /[A-Z]{1}\w+|\bself\b/
	},
	regex : {
	  exp : /\/.+\//
	},
	number : {
	  exp : /\d/
	}
});
