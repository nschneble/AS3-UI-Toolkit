package com.njs.toolkit.ui.buttons
{
	import flash.events.MouseEvent;


	/**
	 * A base class for buttons with selectable states.
	 */
	public class UIToggleButton extends UIButton
	{
		public function UIToggleButton (x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0)
		{
			super (x, y, width, height);
		}


		// UIButton overrides

		override protected function onToggleMouseOver (event : MouseEvent) : void
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

		override protected function onToggleMouseDown (event : MouseEvent) : void
		{
			switch (event.type)
			{
				// selects (or deselects) the toggle button
				case (MouseEvent.MOUSE_UP):
					mouseDown = ! mouseDown;
				break;

				default:
				break;
			}

			updateDisplayList ();
		}


		// public methods

		public function set selected (value : Boolean) : void
		{
			if (mouseDown != value)
			{
				mouseDown = value;

				updateDisplayList ();
			}
		}

		public function get selected () : Boolean
		{
			return mouseDown;
		}

	}
}
