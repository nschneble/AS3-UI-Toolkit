package com.njs.toolkit.ui.buttons
{
	import com.njs.toolkit.ui.UIComponent;
	import com.njs.toolkit.ui.text.UITextField;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextFormatAlign;


	/**
	 * A base class for buttons.
	 */
	public class UIButton extends UIComponent
	{
		// constants
		public static const TOP_MARGIN : Number = 6;
		public static const BOTTOM_MARGIN : Number = 4;
		public static const LEFT_MARGIN : Number = 7;
		public static const RIGHT_MARGIN : Number = 5;
		public static const BACKGROUND_ALPHAS : Array = [1.0, 1.0];
		public static const BACKGROUND_RATIOS : Array = [0, 255];
		public static const DEFAULT_CORNER_RADIUS : Number = 8;
		public static const DEFAULT_SELECTED_BACKGROUND_COLORS : Array = [0xCCCCCC, 0x999999];
		public static const DEFAULT_BACKGROUND_COLORS : Array = [0xFFFFFF, 0xCCCCCC];
		public static const DEFAULT_TEXT_COLOR : uint = 0x666666;
		public static const DEFAULT_SELECTED_TEXT_COLOR : uint = 0xFFFFFF;
		public static const DROP_SHADOW_COLOR : uint = 0x999999;
		public static const FULL_DROP_SHADOW : Number = 1.0;
		public static const HALF_DROP_SHADOW : Number = 0.5;


		// instance variables
		private var _width : Number;
		private var _height : Number;
		private var _selectedBackgroundColors : Array;
		private var _backgroundColors : Array;
		private var _textColor : uint;
		private var _selectedTextColor : uint;
		private var _text : String;
		private var _showDropShadow : Boolean;
		private var _cornerRadius : Number;
		private var mouseOver : Boolean;
		private var mouseDown : Boolean;

		protected var background : Shape;
		protected var buttonTextField : UITextField;


		public function UIButton (x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0)
		{
			super (x, y);

			_width = isNaN (width) ? 0 : Math.max (width, 0);
			_height = isNaN (height) ? 0 : Math.max (height, 0);

			clickable = true;

			addEventListener (MouseEvent.MOUSE_OVER, onToggleMouseOver);
			addEventListener (MouseEvent.MOUSE_OUT, onToggleMouseOver);
			addEventListener (MouseEvent.MOUSE_DOWN, onToggleMouseDown);
			addEventListener (MouseEvent.MOUSE_UP, onToggleMouseDown);

			init ();
		}

		private function init () : void
		{
			_selectedBackgroundColors = DEFAULT_SELECTED_BACKGROUND_COLORS;
			_backgroundColors = DEFAULT_BACKGROUND_COLORS;
			_textColor = DEFAULT_TEXT_COLOR;
			_selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
			_text = "";
			_showDropShadow = true;
			_cornerRadius = DEFAULT_CORNER_RADIUS;

			mouseOver = false;
			mouseDown = false;
		}


		// UIComponent overrides

		override protected function createChildren () : void
		{
			background = new Shape ();
			addChild (background);

			buttonTextField = new UITextField ();
			addChild (buttonTextField);

			updateDisplayList ();
		}

		override protected function destroy () : void
		{
			while (numChildren > 0)
			{
				removeChildAt (0);
			}

			removeEventListener (MouseEvent.MOUSE_OVER, onToggleMouseOver);
			removeEventListener (MouseEvent.MOUSE_OUT, onToggleMouseOver);
			removeEventListener (MouseEvent.MOUSE_DOWN, onToggleMouseDown);
			removeEventListener (MouseEvent.MOUSE_UP, onToggleMouseDown);

			_selectedBackgroundColors = null;
			_backgroundColors = null;

			background = null;
			buttonTextField = null;
		}

		/**
		 * The button width.
		 */
		override public function set width (value : Number) : void
		{
			if (! isNaN (width) && value > 0)
			{
				_width = value;

				updateDisplayList ();
			}
		}

		override public function get width () : Number
		{
			return (_width > 0 ? _width : (buttonTextField ? LEFT_MARGIN + buttonTextField.width + RIGHT_MARGIN : 0));
		}

		/**
		 * The button height.
		 */
		override public function set height (value : Number) : void
		{
			if (! isNaN (height) && value > 0)
			{
				_height = value;

				updateDisplayList ();
			}
		}

		override public function get height () : Number
		{
			return (_height > 0 ? _height : (buttonTextField ? TOP_MARGIN + buttonTextField.height + BOTTOM_MARGIN : 0));
		}


		// public methods

		/**
		 * The background colors to display (as a gradient) when this
		 * button is selected.
		 * 
		 * Must be an Array object of two uint values.
		 */
		public function set selectedBackgroundColors (values : Array) : void
		{
			if (values && values.length == 2 && values [0] is uint && values [1] is uint)
			{
				_selectedBackgroundColors = values;

				updateDisplayList ();
			}
		}

		public function get selectedBackgroundColors () : Array
		{
			return _selectedBackgroundColors;
		}

		/**
		 * The background colors to display (as a gradient) for this
		 * button.
		 * 
		 * Must be an Array object of two uint values.
		 */
		public function set backgroundColors (values : Array) : void
		{
			if (values && values.length == 2 && values [0] is uint && values [1] is uint)
			{
				_backgroundColors = values;

				updateDisplayList ();
			}
		}

		public function get backgroundColors () : Array
		{
			return _backgroundColors;
		}

		/**
		 * The color of the button text.
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
		 * The color of the button text when this button is selected.
		 */
		public function set selectedTextColor (value : uint) : void
		{
			_selectedTextColor = value;

			updateDisplayList ();
		}

		public function get selectedTextColor () : uint
		{
			return _selectedTextColor;
		}

		/**
		 * The button text.
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
		 * Set to true to display a drop shadow behind the button.
		 */
		public function set showDropShadow (value : Boolean) : void
		{
			_showDropShadow = value;

			updateDisplayList ();
		}

		public function get showDropShadow () : Boolean
		{
			return _showDropShadow;
		}

		/**
		 * The radius of the ellipse used to draw the rounded corners.
		 */
		public function set cornerRadius (value : Number) : void
		{
			if (! isNaN (value) && value >= 0)
			{
				_cornerRadius = value;

				updateDisplayList ();
			}
		}

		public function get cornerRadius () : Number
		{
			return _cornerRadius;
		}


		// event handlers

		private function onToggleMouseOver (event : MouseEvent) : void
		{
			switch (event.type)
			{
				case (MouseEvent.MOUSE_OVER):
					mouseOver = true;
				break;

				case (MouseEvent.MOUSE_OUT):
					mouseOver = false;
					mouseDown = false;
				break;

				default:
				break;
			}

			updateDisplayList ();
		}

		private function onToggleMouseDown (event : MouseEvent) : void
		{
			switch (event.type)
			{
				case (MouseEvent.MOUSE_DOWN):
					mouseDown = true;
				break;

				case (MouseEvent.MOUSE_UP):
					mouseDown = false;
				break;

				default:
				break;
			}

			updateDisplayList ();
		}


		// helper methods

		/**
		 * Draws the button.
		 */
		protected function updateDisplayList () : void
		{
			/*
			 * We want to size and position the text field first, because
			 * the size of the background may be determined exclusively by
			 * the size of the text field.
			 */

			sizeAndPositionTextField ();
			sizeAndPositionBackground ();
		}

		/**
		 * Sizes and positions the button text.
		 */
		protected function sizeAndPositionTextField () : void
		{
			if (buttonTextField)
			{
				buttonTextField.text = text;
				buttonTextField.textColor = mouseDown ? selectedTextColor : textColor;
				buttonTextField.textAlign = TextFormatAlign.CENTER;
				buttonTextField.useBoldText = true;
				buttonTextField.shrinkToFit = true;

				buttonTextField.x = LEFT_MARGIN;
				buttonTextField.y = TOP_MARGIN;

				if (_width > 0)
				{
					buttonTextField.width = _width - LEFT_MARGIN - RIGHT_MARGIN;
				}

				if (_height > 0)
				{
					buttonTextField.height = _height - TOP_MARGIN - BOTTOM_MARGIN;
				}
			}
		}

		/**
		 * Sizes and positions the button background.
		 */
		protected function sizeAndPositionBackground () : void
		{
			if (background)
			{
				var matrix : Matrix = new Matrix ();
				matrix.createGradientBox (width, height, Math.PI * 0.5);

				var backgroundColors : Array = mouseDown ? selectedBackgroundColors : backgroundColors;
				var dropShadowAlpha : Number = mouseOver ? FULL_DROP_SHADOW : HALF_DROP_SHADOW;

				background.graphics.clear ();
				background.graphics.beginGradientFill (GradientType.LINEAR, backgroundColors, BACKGROUND_ALPHAS, BACKGROUND_RATIOS, matrix);

				if (cornerRadius > 0)
				{
					background.graphics.drawRoundRect (0, 0, width, height, cornerRadius, cornerRadius);
				}
				else
				{
					background.graphics.drawRect (0, 0, width, height);
				}

				background.graphics.endFill ();

				if (showDropShadow)
				{
					filters = [new GlowFilter (DROP_SHADOW_COLOR, dropShadowAlpha)];
				}
				else
				{
					filters = [];
				}
			}
		}

	}
}
