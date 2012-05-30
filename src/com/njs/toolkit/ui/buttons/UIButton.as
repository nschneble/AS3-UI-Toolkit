package com.njs.toolkit.ui.buttons
{
	import com.njs.toolkit.ui.UIComponent;
	import com.njs.toolkit.ui.text.UITextField;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.MouseEvent;
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
		public static const RIGHT_MARGIN : Number = 4;
		public static const BACKGROUND_ALPHAS : Array = [1.0, 1.0];
		public static const BACKGROUND_RATIOS : Array = [0, 255];
		public static const ELLIPSE_SIZE : Number = 8;
		public static const DEFAULT_SELECTED_BACKGROUND_COLOR : uint = 0x515151;
		public static const DEFAULT_HOVER_BACKGROUND_COLORS : Array = [0xC2C2C2, 0xA1A1A1];
		public static const DEFAULT_TEXT_COLOR : uint = 0x515151;
		public static const DEFAULT_SELECTED_TEXT_COLOR : uint = 0xFFFFFF;


		// instance variables
		private var _width : Number;
		private var _height : Number;
		private var _selectedBackgroundColor : uint;
		private var _hoverBackgroundColors : Array;
		private var _textColor : uint;
		private var _selectedTextColor : uint;
		private var _text : String;
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
			_selectedBackgroundColor = DEFAULT_SELECTED_BACKGROUND_COLOR;
			_hoverBackgroundColors = DEFAULT_HOVER_BACKGROUND_COLORS;
			_textColor = DEFAULT_TEXT_COLOR;
			_selectedTextColor = DEFAULT_SELECTED_TEXT_COLOR;
			_text = "";

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

			_hoverBackgroundColors = null;

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
		 * The background color to display when this button is selected.
		 */
		public function set selectedBackgroundColor (value : uint) : void
		{
			_selectedBackgroundColor = value;

			updateDisplayList ();
		}

		public function get selectedBackgroundColor () : uint
		{
			return _selectedBackgroundColor;
		}

		/**
		 * The background colors to display (as a gradient) when the mouse
		 * is over this button.
		 * 
		 * Must be an Array object of two uint values.
		 */
		public function set hoverBackgroundColors (values : Array) : void
		{
			if (values && values.length == 2 && values [0] is uint && values [1] is uint)
			{
				_hoverBackgroundColors = values;

				updateDisplayList ();
			}
		}

		public function get hoverBackgroundColors () : Array
		{
			return _hoverBackgroundColors;
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
				background.graphics.clear ();

				if (mouseDown)
				{
					background.graphics.beginFill (selectedBackgroundColor);
					background.graphics.drawRoundRect (0, 0, width, height, ELLIPSE_SIZE, ELLIPSE_SIZE);
					background.graphics.endFill ();
				}
				else if (mouseOver)
				{
					var matrix : Matrix = new Matrix ();
					matrix.createGradientBox (width, height, Math.PI * 0.5);

					background.graphics.beginGradientFill (GradientType.LINEAR, hoverBackgroundColors, BACKGROUND_ALPHAS, BACKGROUND_RATIOS, matrix);
					background.graphics.drawRoundRect (0, 0, width, height, ELLIPSE_SIZE, ELLIPSE_SIZE);
					background.graphics.endFill ();
				}
			}
		}

	}
}
