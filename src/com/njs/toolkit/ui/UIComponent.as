package com.njs.toolkit.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;


	/**
	 * A base class for view components.
	 */
	public class UIComponent extends Sprite
	{
		// instance variables
		private var _clickable : Boolean;


		public function UIComponent (x : Number = 0, y : Number = 0)
		{
			this.x = isNaN (x) ? 0 : x;
			this.y = isNaN (y) ? 0 : y;

			addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function createChildren () : void
		{
			// override in subclasses
		}

		protected function destroy () : void
		{
			// override in subclasses
		}


		// event handlers

		private function onAddedToStage (event : Event) : void
		{
			removeEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener (Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			createChildren ();
		}

		private function onRemovedFromStage (event : Event) : void
		{
			removeEventListener (Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);

			destroy ();

			clickable = false;
		}

		protected function onClick (event : MouseEvent) : void
		{
			// override in subclasses
		}


		// public methods

		public function set clickable (value : Boolean) : void
		{
			if (clickable != value)
			{
				_clickable = value;

				showHandCursor (clickable);

				if (clickable)
				{
					addEventListener (MouseEvent.CLICK, onClick);
				}
				else
				{
					removeEventListener (MouseEvent.CLICK, onClick);
				}
			}
		}

		public function get clickable () : Boolean
		{
			return _clickable;
		}


		// helper methods

		private function showHandCursor (value : Boolean) : void
		{
			mouseChildren = ! value;
			buttonMode = value;
			useHandCursor = value;
		}

	}
}
