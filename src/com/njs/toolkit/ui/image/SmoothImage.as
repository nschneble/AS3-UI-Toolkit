package com.njs.toolkit.ui.image
{
	import com.njs.tinyurl.TinyURL;
	import com.njs.toolkit.ui.UIComponent;
	import com.njs.toolkit.util.URLUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;


	/**
	 * An image loaded from a URL. Smoothing is automatically applied.
	 * 
	 * The URL can be from any domain, so there's no need to worry about
	 * cross-domain restrictions.
	 */
	public class SmoothImage extends UIComponent
	{
		// constants
		public static const INVALID_URL_MESSAGE : String = "{SmoothImage}: {The following URL is not valid: \"{MESSAGE_DATA}\"}";
		public static const IMAGE_NOT_LOADED_MESSAGE : String = "{SmoothImage}: {The image failed to load: \"{MESSAGE_DATA}\"}";
		public static const IMAGE_BYTES_NOT_LOADED_MESSAGE : String = "{SmoothImage}: {Could not access bytes for image: \"{MESSAGE_DATA}\"}";
		public static const MESSAGE_DATA_ALIAS : String = "{MESSAGE_DATA}";


		// instance variables
		private var _imageWidth : Number;
		private var _imageHeight : Number;
		private var _maintainAspectRatio : Boolean;
		private var _centered : Boolean;
		private var loader : Loader;
		private var imageURL : String;

		/**
		 * The underlying bitmap image.
		 */
		protected var bitmap : Bitmap;


		public function SmoothImage (x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0)
		{
			super (x, y);

			_imageWidth = isNaN (width) ? 0 : Math.max (width, 0);
			_imageHeight = isNaN (height) ? 0 : Math.max (height, 0);
		}


		// UIComponent overrides

		override protected function destroy () : void
		{
			while (numChildren > 0)
			{
				removeChildAt (0);
			}

			if (loader)
			{
				// cancels any loading operations currently in progress
				try
				{
					loader.close ();
				}
				catch (error : Error)
				{
					// nothing to do here; image was already loaded
				}

				loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, onImageBytesLoaded);
				loader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, onImageNotLoaded);
				loader.contentLoaderInfo.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, onImageBytesNotLoaded);

				loader.unload ();
				loader = null;
			}

			bitmap = null;
		}


		// public methods

		public function load (imageURL : String) : void
		{
			if (URLUtil.isValid (imageURL))
			{
				loader = new Loader ();
				loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, onImageNotLoaded);

				loader.load (new URLRequest (imageURL), new LoaderContext (true));

				this.imageURL = imageURL;
			}
			else
			{
				trace (INVALID_URL_MESSAGE.replace (MESSAGE_DATA_ALIAS, imageURL));

				this.imageURL = null;
			}
		}

		/**
		 * The image width.
		 */
		public function set imageWidth (value : Number) : void
		{
			if (! isNaN (value) && value > 0)
			{
				_imageWidth = value;

				resizeImage ();
			}
		}

		public function get imageWidth () : Number
		{
			return _imageWidth;
		}

		/**
		 * The image height.
		 */
		public function set imageHeight (value : Number) : void
		{
			if (! isNaN (value) && value > 0)
			{
				_imageHeight = value;

				resizeImage ();
			}
		}

		public function get imageHeight () : Number
		{
			return _imageHeight;
		}

		/**
		 * Set to true to maintain the original aspect ratio when the
		 * image is resized.
		 */
		public function set maintainAspectRatio (value : Boolean) : void
		{
			_maintainAspectRatio = value;

			resizeImage ();
		}

		public function get maintainAspectRatio () : Boolean
		{
			return _maintainAspectRatio;
		}

		/**
		 * Determines if the image should be centered when the
		 * maintainAspectRatio property is set to true.
		 * 
		 * If false, the image will remain left-aligned for portraits and
		 * top-aligned for landscapes.
		 */
		public function set centered (value : Boolean) : void
		{
			_centered = value;

			resizeImage ();
		}

		public function get centered () : Boolean
		{
			return _centered;
		}


		// event handlers

		private function onImageLoaded (event : Event) : void
		{
			loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, onImageLoaded);
			loader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, onImageNotLoaded);

			/*
			 * To bypass cross-domain restrictions we need to reload a
			 * copy of the image as a byte array.
			 */

			loader.contentLoaderInfo.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onImageBytesNotLoaded);
			var bytes : ByteArray = loader.contentLoaderInfo.bytes;

			if (loader)
			{
				loader.unload ();

				loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onImageBytesLoaded);
				loader.loadBytes (bytes);
			}
		}

		private function onImageBytesLoaded (event : Event) : void
		{
			loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, onImageBytesLoaded);
			loader.contentLoaderInfo.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, onImageBytesNotLoaded);

			var bitmapData : BitmapData = new BitmapData (loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
			bitmapData.draw (loader);

			bitmap = new Bitmap (bitmapData);
			bitmap.smoothing = true;

			if (imageWidth == 0)
			{
				_imageWidth = bitmap.bitmapData.width;
			}

			if (imageHeight == 0)
			{
				_imageHeight = bitmap.bitmapData.height;
			}

			resizeImage ();

			addChild (bitmap);

			loader.unload ();
			loader = null;
		}

		private function onImageNotLoaded (event : IOErrorEvent) : void
		{
			loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, onImageLoaded);
			loader.contentLoaderInfo.removeEventListener (IOErrorEvent.IO_ERROR, onImageNotLoaded);

			trace (IMAGE_NOT_LOADED_MESSAGE.replace (MESSAGE_DATA_ALIAS, event.text));

			loader.unload ();
			loader = null;
		}

		private function onImageBytesNotLoaded (event : SecurityErrorEvent) : void
		{
			loader.contentLoaderInfo.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, onImageBytesNotLoaded);

			trace (IMAGE_BYTES_NOT_LOADED_MESSAGE.replace (MESSAGE_DATA_ALIAS, event.text));

			loader.unload ();
			loader = null;

			/*
			 * TinyURL.com has a wildcard cross-domain policy, so creating
			 * a shortened URL to a photo should allow us to load it.
			 */

			if (! imageURL.match ("http://tinyurl.com/"))
			{
				TinyURL.create (imageURL, onTinyURLCreated);
			}
		}

		private function onTinyURLCreated (tinyURL : String) : void
		{
			load (tinyURL);
		}


		// helper methods

		/**
		 * Resizes the image.
		 * 
		 * Images are scaled to fit unless maintainAspectRatio is true.
		 */
		protected function resizeImage () : void
		{
			if (bitmap)
			{
				if (maintainAspectRatio)
				{
					var scaleWidth : Number = imageWidth / bitmap.bitmapData.width;
					var scaleHeight : Number = imageHeight / bitmap.bitmapData.height;

					if (scaleWidth < scaleHeight)
					{
						bitmap.x = 0;
						bitmap.y = centered ? (imageHeight - (bitmap.bitmapData.height * scaleWidth)) * 0.5 : 0;
						bitmap.width = bitmap.bitmapData.width * scaleWidth;
						bitmap.height = bitmap.bitmapData.height * scaleWidth;
					}
					else
					{
						bitmap.x = centered ? (imageWidth - (bitmap.bitmapData.width * scaleHeight)) * 0.5 : 0;
						bitmap.y = 0;
						bitmap.width = bitmap.bitmapData.width * scaleHeight;
						bitmap.height = bitmap.bitmapData.height * scaleHeight;
					}
				}
				else
				{
					bitmap.x = 0;
					bitmap.y = 0;
					bitmap.width = imageWidth;
					bitmap.height = imageHeight;
				}
			}
		}

	}
}
