(function($targetObject) {

	var ns = $targetObject;
	var flashContainer = "flashContentContainer";

	function replaceHTMLSpecialChars(sourceString) {

		var amp = /&/gi;
		sourceString = sourceString.replace(amp, "&amp;");

		var quot = /["]/gi;
		sourceString = sourceString.replace(quot, "&quot;");

		var singlequot = /[']/gi;
		sourceString = sourceString.replace(singlequot, "&#039;");

		var lt = /</gi;
		sourceString = sourceString.replace(lt, "&lt;");

		var gt = />/gi;
		sourceString = sourceString.replace(gt, "&gt;");

		return sourceString;

	}

	function getNode() {

		//get the DIV where the flash lives
		var node;

		try {

			node = $("#" + flashContainer)[0];

		} catch (errorAtNodeRef) {

			// hmm, could not pick up the Flash container, try this instead
			if (document.getElementById(flashContainer))
				node = document.getElementById(flashContainer);

		}

		if ((node == undefined) || (node == null) || (node.tagName != "DIV"))
			node = document.body; // cannot find reference, or selected node is not div, so attaching to body

		return node;

	}

	function setElementPosition(targetElement, descriptor) {
		
		targetElement.style.left = descriptor.x + "px";
		targetElement.style.top = descriptor.y + "px";

	}

	function setElementStyles(targetElement, descriptor) {

		targetElement.setAttribute('id', descriptor.id);
		targetElement.style.position = "absolute";
		targetElement.style.width = descriptor.width + "px";
		targetElement.style.height = descriptor.height + "px";

		setElementPosition(targetElement, descriptor);
		
	}

	function writeDiv(descriptor) {

		//get the DIV where the flash lives
		var node = getNode();

		if (node) {

			//create a new div in the node element and position it with inline style
			//The Flash div and the swf must share the same top left corner coordinates for the div being placed
			//to show up where the Flash proxy wants to place them.  Also the Flash div must be relative positioned 
			var targetElement = document.createElement("DIV");
			setElementStyles(targetElement, descriptor);
			node.appendChild(targetElement);

			//write the iframe or the xfbml tag to the created div
			try {

				$(targetElement).html(descriptor.content);

			} catch (errorAtHTML) {

				targetElement.innerHTML = descriptor.content;

			}

		}

	}

	function clearDiv(id) {

		var element;

		if (document.getElementById && document.getElementById(id)) {

			element = document.getElementById(id);
			element.parentNode.removeChild(element);

		}

	}

	function getTweetButtonContent(tweetParams) {

		var tweetButtonParams = "";

		if ((tweetParams.url != null) && (tweetParams.url != ""))
			tweetButtonParams += ("?url=" + encodeURIComponent(tweetParams.url));

		if ((tweetParams.via != null) && (tweetParams.via != ""))
			tweetButtonParams += ((tweetButtonParams.length == 0 ? "?" : "&")
					+ "via=" + encodeURIComponent(tweetParams.via));

		if ((tweetParams.text != null) && (tweetParams.text != ""))
			tweetButtonParams += ((tweetButtonParams.length == 0 ? "?" : "&")
					+ "text=" + encodeURIComponent(tweetParams.text));

		if ((tweetParams.related != null) && (tweetParams.related != ""))
			tweetButtonParams += ((tweetButtonParams.length == 0 ? "?" : "&")
					+ "related=" + encodeURIComponent(tweetParams.related));

		if ((tweetParams.count != null) && (tweetParams.count != ""))
			tweetButtonParams += ((tweetButtonParams.length == 0 ? "?" : "&")
					+ "count=" + encodeURIComponent(tweetParams.count));

		if ((tweetParams.lang != null) && (tweetParams.lang != ""))
			tweetButtonParams += ((tweetButtonParams.length == 0 ? "?" : "&")
					+ "lang=" + encodeURIComponent(tweetParams.lang));

		if ((tweetParams.counturl != null) && (tweetParams.counturl != ""))
			tweetButtonParams += ((tweetButtonParams.length == 0 ? "?" : "&")
					+ "counturl=" + encodeURIComponent(tweetParams.counturl));

		var tweetButton = '<iframe allowtransparency="true" frameborder="0" scrolling="no"';
		tweetButton += 'src="http://platform.twitter.com/widgets/tweet_button.html'
				+ tweetButtonParams + '"';
		tweetButton += 'style="overflow: hidden; width: ' + tweetParams.width
				+ 'px; height: ' + tweetParams.height
				+ 'px; background-color: transparent; border: none;"></iframe>';

		return tweetButton;

	}

	ns.TweetButtonFlash = {};

	ns.TweetButtonFlash.addTweetButton = function(tweetParams) {

		var tweetDivParams = {
			id : tweetParams.id,
			content : getTweetButtonContent(tweetParams),
			x : tweetParams.x,
			y : tweetParams.y,
			width : tweetParams.width,
			height : tweetParams.height,
			options : tweetParams.options
		};

		if (tweetParams.hasOwnProperty("targetDivID"))
			flashContainer = tweetParams.targetDivID;

		writeDiv(tweetDivParams);

	}

	ns.TweetButtonFlash.removeTweetButton = function(id) {

		clearDiv(id);

	}

})(window);