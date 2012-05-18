package com.njs.toolkit.util
{
	/**
	 * Useful methods when dealing with URLs.
	 */
	public final class URLUtil
	{
		// constants

		/**
		 * A regex pattern for matching URLs.
		 */
		public static const VALID_URL_REGEX : RegExp = /(?i)\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))/;


		// public methods

		/**
		 * Checks for valid URLs. Uses the (improved) regex pattern for
		 * matching URLs developed by John Gruber:
		 * 
		 * An Improved Liberal, Accurate Regex Pattern for Matching URLs
		 * http://daringfireball.net/2010/07/improved_regex_for_matching_urls
		 * 
		 * @param url the URL to validate
		 * 
		 * @return true if the URL is valid; false otherwise
		 */
		public static function isValid (url : String) : Boolean
		{
			return (url && VALID_URL_REGEX.test (url));
		}

	}
}
