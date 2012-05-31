package com.njs.toolkit.util
{
	import flash.display.Bitmap;


	/**
	 * Useful methods when dealing with images.
	 */
	public final class ImageUtil
	{
		// public methods

		/**
		 * Resizes an image.
		 * 
		 * Images are scaled to fit unless maintainAspectRatio is true.
		 * 
		 * @param image the image to resize
		 * @param width the desired image width
		 * @param height the desired image height
		 * @param maintainAspectRatio if true, the original aspect ratio
		 *     is maintained; otherwise the image is scaled to fit
		 */
		public static function resize (image : Bitmap, width : Number, height : Number, maintainAspectRatio : Boolean = false) : void
		{
			if (image)
			{
				if (maintainAspectRatio)
				{
					var scaleWidth : Number = width / image.bitmapData.width;
					var scaleHeight : Number = height / image.bitmapData.height;

					if (scaleWidth < scaleHeight)
					{
						image.width = image.bitmapData.width * scaleWidth;
						image.height = image.bitmapData.height * scaleWidth;
					}
					else
					{
						image.width = image.bitmapData.width * scaleHeight;
						image.height = image.bitmapData.height * scaleHeight;
					}
				}
				else
				{
					image.width = width;
					image.height = height;
				}
			}
		}

	}
}
