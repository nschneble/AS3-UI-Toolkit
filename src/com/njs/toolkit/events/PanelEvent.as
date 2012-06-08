package com.njs.toolkit.events
{
	import flash.events.Event;


	/**
	 * A PanelEvent object is dispatched when the close button is clicked
	 * in a Panel container.
	 */
	public class PanelEvent extends Event
	{
		// constants

		/**
		 * Dispatched when the close button is clicked.
		 */
		public static const PANEL_DISMISSED : String = "com.njs.toolkit.events.PanelEvent.panelDismissed";


		public function PanelEvent (type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super (type, bubbles, cancelable);
		}

	}
}
