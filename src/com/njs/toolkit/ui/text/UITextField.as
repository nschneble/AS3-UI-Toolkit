package com.njs.toolkit.ui.text
{
	import com.njs.toolkit.ui.UIComponent;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	/**
	 * A base class for text fields.
	 */
	public class UITextField extends UIComponent
	{
		// constants
		public static const DEFAULT_FONT_NAME : String = "Arial";
		public static const DEFAULT_FONT_SIZE : Number = 12;
		public static const DEFAULT_MIN_FONT_SIZE : Number = 8;
		public static const DEFAULT_TEXT_COLOR : uint = 0x000000;


		// instance variables
		private var _width : Number;
		private var _height : Number;
		private var _fontName : String;
		private var _fontSize : Number;
		private var _minFontSize : Number;
		private var _useBoldText : Boolean;
		private var _useItalicText : Boolean;
		private var _textColor : uint;
		private var _multiline : Boolean;
		private var _shrinkToFit : Boolean;
		private var _selectable : Boolean;
		private var _textAlign : String;
		private var _text : String;
		private var _useHTMLText : Boolean;
		private var _autoSize : String;

		protected var textFormat : TextFormat;
		protected var textField : TextField;


		public function UITextField (x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0)
		{
			super (x, y);

			_width = isNaN (width) ? 0 : Math.max (width, 0);
			_height = isNaN (height) ? 0 : Math.max (height, 0);

			init ();
		}

		private function init () : void
		{
			_fontName = DEFAULT_FONT_NAME;
			_fontSize = DEFAULT_FONT_SIZE;
			_minFontSize = DEFAULT_MIN_FONT_SIZE;
			_useBoldText = false;
			_useItalicText = false;
			_textColor = DEFAULT_TEXT_COLOR;
			_multiline = false;
			_shrinkToFit = false;
			_selectable = false;
			_textAlign = TextFormatAlign.LEFT;
			_text = "";
			_useHTMLText = false;
			_autoSize = null;
		}


		// UIComponent overrides

		override protected function createChildren () : void
		{
			textFormat = new TextFormat ();

			textField = new TextField ();
			addChild (textField);

			updateDisplayList ();
		}

		override protected function destroy () : void
		{
			while (numChildren > 0)
			{
				removeChildAt (0);
			}

			textFormat = null;
			textField = null;
		}

		/**
		 * The text field width.
		 */
		override public function set width (value : Number) : void
		{
			if (! isNaN (value) && value >= 0)
			{
				_width = value;

				updateDisplayList ();
			}
		}

		override public function get width () : Number
		{
			return _width > 0 ? _width : (textField ? textField.width : 0);
		}

		/**
		 * The text field height.
		 */
		override public function set height (value : Number) : void
		{
			if (! isNaN (value) && value >= 0)
			{
				_height = value;

				updateDisplayList ();
			}
		}

		override public function get height () : Number
		{
			return _height > 0 ? _height : (textField ? textField.height : 0);
		}


		// public methods

		/**
		 * Name of the font to use.
		 */
		public function set fontName (value : String) : void
		{
			if (value)
			{
				_fontName = value;

				updateDisplayList ();
			}
		}

		public function get fontName () : String
		{
			return _fontName;
		}

		/**
		 * The font size.
		 */
		public function set fontSize (value : Number) : void
		{
			if (! isNaN (value) && value > 0)
			{
				_fontSize = value;

				updateDisplayList ();
			}
		}

		public function get fontSize () : Number
		{
			return _fontSize;
		}

		/**
		 * The minimum font size.
		 * 
		 * Only used when shrinkToFit is true and the text is too long to
		 * fit at the original font size.
		 */
		public function set minFontSize (value : Number) : void
		{
			if (! isNaN (value) && value > 0)
			{
				_minFontSize = value;

				updateDisplayList ();
			}
		}

		public function get minFontSize () : Number
		{
			return _minFontSize;
		}

		/**
		 * Set to true to display bold text.
		 */
		public function set useBoldText (value : Boolean) : void
		{
			_useBoldText = value;

			updateDisplayList ();
		}

		public function get useBoldText () : Boolean
		{
			return _useBoldText;
		}

		/**
		 * Set to true to display italic text.
		 */
		public function set useItalicText (value : Boolean) : void
		{
			_useItalicText = value;

			updateDisplayList ();
		}

		public function get useItalicText () : Boolean
		{
			return _useItalicText;
		}

		/**
		 * The color of the text.
		 */
		public function set textColor (value : uint) : void
		{
			_textColor = value;

			updateDisplayList ();
		}

		public function get textColor () : uint
		{
			return _textColor;
		}

		/**
		 * Set to true to allow text to be displayed across multiple lines
		 * when needed.
		 * 
		 * If true, word wrap is automatically enabled as well.
		 */
		public function set multiline (value : Boolean) : void
		{
			_multiline = value;

			updateDisplayList ();
		}

		public function get multiline () : Boolean
		{
			return _multiline;
		}

		/**
		 * Set to true to automatically reduce the font size when the text
		 * is too long to fit.
		 * 
		 * Only applies when the text field width is explicitly set. The
		 * resulting text will not be displayed below the minFontSize.
		 */
		public function set shrinkToFit (value : Boolean) : void
		{
			_shrinkToFit = value;

			updateDisplayList ();
		}

		public function get shrinkToFit () : Boolean
		{
			return _shrinkToFit;
		}

		/**
		 * Set to true to allow text to be selected.
		 */
		public function set selectable (value : Boolean) : void
		{
			_selectable = value;

			updateDisplayList ();
		}

		public function get selectable () : Boolean
		{
			return _selectable;
		}

		/**
		 * Controls the text alignment.
		 * 
		 * Expected to be a value from the TextFormatAlign class.
		 */
		public function set textAlign (value : String) : void
		{
			if (value)
			{
				_textAlign = value;

				updateDisplayList ();
			}
		}

		public function get textAlign () : String
		{
			return _textAlign;
		}

		/**
		 * The text to display.
		 */
		public function set text (value : String) : void
		{
			if (value)
			{
				_text = value;

				updateDisplayList ();
			}
		}

		public function get text () : String
		{
			return _text;
		}

		/**
		 * Set to true to display the text as HTML text.
		 */
		public function set useHTMLText (value : Boolean) : void
		{
			_useHTMLText = value;

			updateDisplayList ();
		}

		public function get useHTMLText () : Boolean
		{
			return _useHTMLText;
		}

		/**
		 * The autoSize property for the text.
		 * 
		 * Defaults to null, in which case the property is automatically
		 * determined based on the text alignment.
		 * 
		 * Expected to be a value from the TextFieldAutoSize class.
		 */
		public function set autoSize (value : String) : void
		{
			_autoSize = value;

			updateDisplayList ();
		}

		public function get autoSize () : String
		{
			return _autoSize;
		}


		// helper methods

		/**
		 * Draws the text field.
		 */
		protected function updateDisplayList () : void
		{
			if (textFormat && textField)
			{
				textFormat.font = fontName;
				textFormat.size = fontSize;
				textFormat.bold = useBoldText;
				textFormat.italic = useItalicText;
				textFormat.color = textColor;
				textFormat.align = textAlign;

				textField.selectable = selectable;
				textField.multiline = multiline;
				textField.wordWrap = multiline;
				textField.autoSize = setTextFieldAutoSize ();

				sizeAndFormatText ();

				if (shrinkToFit)
				{
					var tempFontSize : Number = fontSize;

					while ((textField.textWidth > width || textField.textHeight > height) &&
						tempFontSize > minFontSize)
					{
						-- tempFontSize;

						textFormat.size = tempFontSize;

						sizeAndFormatText ();
					}
				}
			}
		}

		/**
		 * Determines the value of the autoSize property.
		 */
		protected function setTextFieldAutoSize () : String
		{
			var autoSize : String;

			if (this.autoSize)
			{
				autoSize = this.autoSize;
			}
			else if (_width > 0)
			{
				autoSize = TextFieldAutoSize.NONE;
			}
			else
			{
				switch (textAlign)
				{
					case (TextFormatAlign.CENTER):
					case (TextFormatAlign.JUSTIFY):
						autoSize = TextFieldAutoSize.CENTER;
					break;

					case (TextFormatAlign.LEFT):
						autoSize = TextFieldAutoSize.LEFT;
					break;

					case (TextFormatAlign.RIGHT):
						autoSize = TextFieldAutoSize.RIGHT;
					break;

					default:
						autoSize = TextFieldAutoSize.NONE;
					break;
				}
			}

			return autoSize;
		}

		/**
		 * Sizes and positions the text field.
		 * 
		 * May be called multiple times when shrinkToFit is true and the
		 * text is being adjusted to fit.
		 */
		protected function sizeAndFormatText () : void
		{
			if (textField)
			{
				textField.defaultTextFormat = textFormat;

				if (useHTMLText)
				{
					textField.htmlText = text;
				}
				else
				{
					textField.text = text;
				}

				textField.x = 0;
				textField.y = 0;
				textField.width = _width > 0 ? _width : textField.textWidth;
				textField.height = _height > 0 ? _height : textField.textHeight;
			}
		}

	}
}
