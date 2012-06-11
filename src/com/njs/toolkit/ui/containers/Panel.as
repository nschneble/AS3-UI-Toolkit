package com.njs.toolkit.ui.containers
{
	import com.njs.toolkit.events.PanelEvent;
	import com.njs.toolkit.ui.UIComponent;
	import com.njs.toolkit.ui.buttons.UIButton;
	import com.njs.toolkit.ui.text.UITextField;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
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
		public static const DEFAULT_TITLE_COLOR : uint = 0x666666;
		public static const DEFAULT_PANEL_TITLE : String = "Panel";
		public static const CLOSE_BUTTON_TEXT : String = "X";
		public static const CLOSE_BUTTON_MARGIN : Number = 2;
		public static const CLOSE_BUTTON_BACKGROUND_ALPHAS : Array = [0, 0];
		public static const DEFAULT_CLOSE_BUTTON_TEXT_COLOR : uint = 0x666666;
		public static const DEFAULT_CLOSE_BUTTON_HIGHLIGHTED_TEXT_COLOR : uint = 0x000000;
		public static const DEFAULT_CLOSE_BUTTON_SELECTED_TEXT_COLOR : uint = 0xFFFFFF;
		public static const DEFAULT_BORDER_COLOR : uint = 0xCCCCCC;
		public static const DEFAULT_CONTENT_AREA_BACKGROUND_COLOR : uint = 0xFFFFFF;
		public static const DEFAULT_BACKDROP_COLOR : uint = 0x000000;
		public static const BACKDROP_ALPHA : Number = 0.5;


		// instance variables
		private var _width : Number;
		private var _height : Number;
		private var _borderThickness : Number;
		private var _cornerRadius : Number;
		private var _title : String;
		private var _showCloseButton : Boolean;
		private var _titleColor : uint;
		private var _closeButtonTextColor : uint;
		private var _closeButtonHighlightedTextColor : uint;
		private var _closeButtonSelectedTextColor : uint;
		private var _borderColor : uint;
		private var _contentAreaBackgroundColor : uint;
		private var _backdropColor : uint;

		protected var background : Shape;
		protected var titleTextField : UITextField;
		protected var closeButton : UIButton;
		protected var parentContainer : DisplayObjectContainer;
		protected var backdrop : Shape;
		protected var modal : Boolean;


		public function Panel (parentContainer : DisplayObjectContainer = null, modal : Boolean = false, x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0)
		{
			super (x, y);

			_width = isNaN (width) ? 0 : Math.max (width, 0);
			_height = isNaN (height) ? 0 : Math.max (height, 0);

			this.parentContainer = parentContainer;
			this.modal = modal;

			init ();
		}

		private function init () : void
		{
			_borderThickness = DEFAULT_BORDER_THICKNESS;
			_cornerRadius = DEFAULT_CORNER_RADIUS;
			_title = DEFAULT_PANEL_TITLE;
			_showCloseButton = false;
			_titleColor = DEFAULT_TITLE_COLOR;
			_closeButtonTextColor = DEFAULT_CLOSE_BUTTON_TEXT_COLOR;
			_closeButtonHighlightedTextColor = DEFAULT_CLOSE_BUTTON_HIGHLIGHTED_TEXT_COLOR;
			_closeButtonSelectedTextColor = DEFAULT_CLOSE_BUTTON_SELECTED_TEXT_COLOR;
			_borderColor = DEFAULT_BORDER_COLOR;
			_contentAreaBackgroundColor = DEFAULT_CONTENT_AREA_BACKGROUND_COLOR;
			_backdropColor = DEFAULT_BACKDROP_COLOR;
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

			if (parentContainer == null)
			{
				parentContainer = stage;
			}

			backdrop = new Shape ();
			parentContainer.addChildAt (backdrop, parentContainer.contains (this) ?
				parentContainer.getChildIndex (this) : parentContainer.numChildren);

			updateDisplayList ();
		}

		override protected function destroy () : void
		{
			while (numChildren > 0)
			{
				removeChildAt (0);
			}

			closeButton.removeEventListener (MouseEvent.CLICK, onCloseButtonClick);

			if (parentContainer.contains (backdrop))
			{
				parentContainer.removeChild (backdrop);
			}

			applyBlurFilters (true);

			background = null;
			titleTextField = null;
			closeButton = null;
			parentContainer = null;
			backdrop = null;
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
		 * The color of the panel title.
		 */
		public function set titleColor (value : uint) : void
		{
			_titleColor = value;

			updateDisplayList ();
		}

		public function get titleColor () : uint
		{
			return _titleColor;
		}

		/**
		 * The color of the close button text.
		 */
		public function set closeButtonTextColor (value : uint) : void
		{
			_closeButtonTextColor = value;

			updateDisplayList ();
		}

		public function get closeButtonTextColor () : uint
		{
			return _closeButtonTextColor;
		}

		/**
		 * The color of the close button text when the mouse is over the
		 * button.
		 */
		public function set closeButtonHighlightedTextColor (value : uint) : void
		{
			_closeButtonHighlightedTextColor = value;

			updateDisplayList ();
		}

		public function get closeButtonHighlightedTextColor () : uint
		{
			return _closeButtonHighlightedTextColor;
		}

		/**
		 * The color of the close button text when the button is selected.
		 */
		public function set closeButtonSelectedTextColor (value : uint) : void
		{
			_closeButtonSelectedTextColor = value;

			updateDisplayList ();
		}

		public function get closeButtonSelectedTextColor () : uint
		{
			return _closeButtonSelectedTextColor;
		}

		/**
		 * The color of the panel border and title bar background.
		 */
		public function set borderColor (value : uint) : void
		{
			_borderColor = value;

			updateDisplayList ();
		}

		public function get borderColor () : uint
		{
			return _borderColor;
		}

		/**
		 * The background color of the content area.
		 */
		public function set contentAreaBackgroundColor (value : uint) : void
		{
			_contentAreaBackgroundColor = value;

			updateDisplayList ();
		}

		public function get contentAreaBackgroundColor () : uint
		{
			return _contentAreaBackgroundColor;
		}

		/**
		 * The color of the backdrop for modal panels.
		 */
		public function set backdropColor (value : uint) : void
		{
			_backdropColor = value;

			updateDisplayList ();
		}

		public function get backdropColor () : uint
		{
			return _backdropColor;
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
			sizeAndPositionModalBackdrop ();
		}

		/**
		 * Sizes and positions the panel title.
		 */
		protected function sizeAndPositionTitle () : void
		{
			if (titleTextField)
			{
				titleTextField.text = title;
				titleTextField.textColor = titleColor;
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
				closeButton.textColor = closeButtonTextColor;
				closeButton.highlightedTextColor = closeButtonHighlightedTextColor;
				closeButton.selectedTextColor = closeButtonSelectedTextColor;
				closeButton.backgroundAlphas = CLOSE_BUTTON_BACKGROUND_ALPHAS;
				closeButton.highlightedBackgroundAlphas = CLOSE_BUTTON_BACKGROUND_ALPHAS;
				closeButton.selectedBackgroundAlphas = CLOSE_BUTTON_BACKGROUND_ALPHAS;
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

				background.graphics.beginFill (borderColor);
				background.graphics.drawRoundRect (0, 0, width, height, cornerRadius);
				background.graphics.endFill ();

				background.graphics.beginFill (contentAreaBackgroundColor);
				background.graphics.drawRoundRect (xContentArea, yContentArea, contentAreaWidth, contentAreaHeight, cornerRadius);
				background.graphics.endFill ();
			}

			// uses the same color as the border to generate a soft glow
			filters = [new GlowFilter (borderColor)];
		}

		/**
		 * Sizes and positions the backdrop for modal panels.
		 */
		protected function sizeAndPositionModalBackdrop () : void
		{
			if (parentContainer && backdrop)
			{
				var xBackdrop : Number = (stage.stageWidth - parentContainer.width) * 0.5;
				var yBackdrop : Number = (stage.stageHeight - parentContainer.height) * 0.5;
				var backdropWidth : Number = parentContainer.width;
				var backdropHeight : Number = parentContainer.height;

				backdrop.graphics.clear ();
				backdrop.graphics.beginFill (backdropColor, BACKDROP_ALPHA);
				backdrop.graphics.drawRect (xBackdrop, yBackdrop, backdropWidth, backdropHeight);
				backdrop.graphics.endFill ();

				applyBlurFilters ();
			}
		}

		/**
		 * Applies a <code>BlurFilter</code> object to the backdrop for
		 * modal panels.<br />
		 * <br />
		 * <strong>Note:</strong> If the parent container is the stage,
		 * then a <code>BlurFilter</code> object is applied to
		 * <em>every</em> child component on the stage, other than the
		 * panel itself.
		 */
		protected function applyBlurFilters (removeFilters : Boolean = false) : void
		{
			if (parentContainer && parentContainer == stage)
			{
				var i : int;
				var child : DisplayObject;

				for (i = 0; i < parentContainer.numChildren; ++ i)
				{
					child = parentContainer.getChildAt (i);

					if (child != this)
					{
						child.filters = removeFilters ? [] : [new BlurFilter ()];
					}
				}
			}
			else if (parentContainer)
			{
				parentContainer.filters = removeFilters ? [] : [new BlurFilter ()];
			}
		}

	}
}
