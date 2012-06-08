package com.njs.toolkit.ui.containers
{
	import com.njs.toolkit.events.PanelEvent;
	import com.njs.toolkit.ui.UIComponent;
	import com.njs.toolkit.ui.buttons.UIButton;
	import com.njs.toolkit.ui.text.UITextField;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;


	/**
	 * A panel with a title bar, border and content area for its children.<br />
	 * <br />
	 * To add children to the content area, use the <code>addChild()</code> method and
	 * position the components using the provided properties for the
	 * content area.<br />
	 * <br />
	 * <strong>Example:</strong><br />
	 * <br />
	 * <code>
	 * var panel : Panel = new Panel ();<br />
	 * stage.addChild (panel);<br />
	 * <br />
	 * var button : UIButton = new UIButton ();<br />
	 * button.x = panel.xContentArea;<br />
	 * button.y = panel.yContentArea;<br />
	 * button.text = "TOP LEFT OF CONTENT AREA";<br />
	 * <br />
	 * panel.addChild (button);
	 * </code>
	 */
	public class Panel extends UIComponent
	{
		// constants
		public static const DEFAULT_PANEL_WIDTH : Number = 400;
		public static const DEFAULT_PANEL_HEIGHT : Number = 325;
		public static const DEFAULT_BORDER_THICKNESS : Number = 8;
		public static const DEFAULT_CORNER_RADIUS : Number = 6;
		public static const DEFAULT_PANEL_TITLE : String = "Panel";
		public static const CLOSE_BUTTON_TEXT : String = "X";
		public static const CLOSE_BUTTON_MARGIN : Number = 2;


		// instance variables
		private var _width : Number;
		private var _height : Number;
		private var _borderThickness : Number;
		private var _cornerRadius : Number;
		private var _title : String;
		private var _showCloseButton : Boolean;

		protected var background : Shape;
		protected var titleTextField : UITextField;
		protected var closeButton : UIButton;


		public function Panel (x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0)
		{
			super (x, y);

			_width = isNaN (width) ? 0 : Math.max (width, 0);
			_height = isNaN (height) ? 0 : Math.max (height, 0);

			init ();
		}

		private function init () : void
		{
			_borderThickness = DEFAULT_BORDER_THICKNESS;
			_cornerRadius = DEFAULT_CORNER_RADIUS;
			_title = DEFAULT_PANEL_TITLE;
			_showCloseButton = false;
		}


		// UIComponent overrides

		override protected function createChildren () : void
		{
			background = new Shape ();
			addChild (background);

			var xTitleTextField : Number = DEFAULT_BORDER_THICKNESS;
			var yTitleTextField : Number = DEFAULT_BORDER_THICKNESS;

			titleTextField = new UITextField (xTitleTextField, yTitleTextField);
			addChild (titleTextField);

			var xCloseButton : Number = 0;
			var yCloseButton : Number = CLOSE_BUTTON_MARGIN;

			closeButton = new UIButton (xCloseButton, yCloseButton);
			closeButton.addEventListener (MouseEvent.CLICK, onCloseButtonClick);

			updateDisplayList ();
		}

		override protected function destroy () : void
		{
			while (numChildren > 0)
			{
				removeChildAt (0);
			}

			closeButton.removeEventListener (MouseEvent.CLICK, onCloseButtonClick);

			background = null;
			titleTextField = null;
			closeButton = null;
		}

		/**
		 * The width of the panel.
		 */
		override public function set width (value : Number) : void
		{
			if (! isNaN (value) && value > 0)
			{
				_width = value;

				updateDisplayList ();
			}
		}

		override public function get width () : Number
		{
			return (_width > 0 ? _width : DEFAULT_PANEL_WIDTH);
		}

		/**
		 * The height of the panel.
		 */
		override public function set height (value : Number) : void
		{
			if (! isNaN (value) && value > 0)
			{
				_height = value;

				updateDisplayList ();
			}
		}

		override public function get height () : Number
		{
			return (_height > 0 ? _height : DEFAULT_PANEL_HEIGHT);
		}


		// public methods

		/**
		 * The border thickness between the edge of the panel and the
		 * content area.
		 */
		public function set borderThickness (value : Number) : void
		{
			if (! isNaN (value) && value >= 0)
			{
				_borderThickness = value;

				updateDisplayList ();
			}
		}

		public function get borderThickness () : Number
		{
			return _borderThickness;
		}

		/**
		 * The corner radius for the panel and content area borders.
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

		/**
		 * The panel title.
		 */
		public function set title (value : String) : void
		{
			if (value)
			{
				_title = value;

				updateDisplayList ();
			}
		}

		public function get title () : String
		{
			return _title;
		}

		/**
		 * Set to true to display a close button in the title bar. False
		 * by default.<br />
		 * <br />
		 * A <code>PanelEvent.PANEL_DISMISSED</code> event is dispatched
		 * when the user clicks the close button.
		 */
		public function set showCloseButton (value : Boolean) : void
		{
			_showCloseButton = value;

			updateDisplayList ();
		}

		public function get showCloseButton () : Boolean
		{
			return _showCloseButton;
		}

		/**
		 * The height of the title bar. This value will be zero until the
		 * panel has been added to the stage.
		 */
		public function get titleBarHeight () : Number
		{
			return (titleTextField ? titleTextField.height + (DEFAULT_BORDER_THICKNESS * 2) : 0);
		}

		/**
		 * The x-coordinate of the content area.
		 */
		public function get xContentArea () : Number
		{
			return borderThickness;
		}

		/**
		 * The y-coordinate of the content area. This value will be zero
		 * until the panel has been added to the stage.
		 */
		public function get yContentArea () : Number
		{
			return titleBarHeight;
		}

		/**
		 * The width of the content area.
		 */
		public function get contentAreaWidth () : Number
		{
			return width - (borderThickness * 2);
		}

		/**
		 * The height of the content area. This value may not be correct
		 * until the panel has been added to the stage.
		 */
		public function get contentAreaHeight () : Number
		{
			return height - borderThickness - titleBarHeight;
		}


		// event handlers

		protected function onCloseButtonClick (event : MouseEvent) : void
		{
			dispatchEvent (new PanelEvent (PanelEvent.PANEL_DISMISSED));
		}


		// helper methods

		/**
		 * Draws the panel.
		 */
		protected function updateDisplayList () : void
		{
			/*
			 * We want to size and position the title first, because the
			 * size of the content area is in part determined by its size.
			 */

			sizeAndPositionTitle ();
			sizeAndPositionCloseButton ();
			sizeAndPositionBackground ();
		}

		/**
		 * Sizes and positions the panel title.
		 */
		protected function sizeAndPositionTitle () : void
		{
			if (titleTextField)
			{
				titleTextField.text = title;
				titleTextField.textColor = 0x666666;
				titleTextField.useBoldText = true;
				titleTextField.shrinkToFit = true;
			}
		}

		/**
		 * Sizes and positions the close button.
		 */
		protected function sizeAndPositionCloseButton () : void
		{
			if (closeButton)
			{
				if (showCloseButton && ! contains (closeButton))
				{
					addChildAt (closeButton, getChildIndex (titleTextField) + 1);
				}
				else if (! showCloseButton && contains (closeButton))
				{
					removeChild (closeButton);
				}

				closeButton.text = CLOSE_BUTTON_TEXT;
				closeButton.highlightedTextColor = 0x000000;
				closeButton.backgroundAlphas = [0, 0];
				closeButton.highlightedBackgroundAlphas = [0, 0];
				closeButton.selectedBackgroundAlphas = [0, 0];
				closeButton.showDropShadow = false;
				closeButton.x = width - closeButton.width - CLOSE_BUTTON_MARGIN;
			}
		}

		/**
		 * Sizes and positions the panel background and content area.
		 */
		protected function sizeAndPositionBackground () : void
		{
			if (background)
			{
				background.graphics.clear ();

				background.graphics.beginFill (0xCCCCCC);
				background.graphics.drawRoundRect (0, 0, width, height, cornerRadius);
				background.graphics.endFill ();

				background.graphics.beginFill (0xFFFFFF);
				background.graphics.drawRoundRect (xContentArea, yContentArea, contentAreaWidth, contentAreaHeight, cornerRadius);
				background.graphics.endFill ();
			}

			filters = [new GlowFilter (0xCCCCCC)];
		}

	}
}
