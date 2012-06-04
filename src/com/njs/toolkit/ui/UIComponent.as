package com.njs.toolkit.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;


	/**
	 * A base class for view components.
	 */
	public class UIComponent extends Sprite
	{
		// instance variables
		private var _clickable : Boolean;
		private var _fullscreen : Boolean;


		public function UIComponent (x : Number = 0, y : Number = 0)
		{
			this.x = isNaN (x) ? 0 : x;
			this.y = isNaN (y) ? 0 : y;

			addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);
		}

		/**
		 * Override to add child components.
		 * 
		 * This function will be called automatically when this component
		 * is added to the stage.
		 */
		protected function createChildren () : void
		{
			// override in subclasses
		}

		/**
		 * Override to remove child components and event listeners.
		 * 
		 * This function will be called automatically when this component
		 * is removed from the stage.
		 */
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

			if (fullscreen)
			{
				stage.addEventListener (FullScreenEvent.FULL_SCREEN, onDisplayStateChanged);
			}
		}

		private function onRemovedFromStage (event : Event) : void
		{
			removeEventListener (Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener (Event.ADDED_TO_STAGE, onAddedToStage);

			destroy ();

			clickable = false;
			fullscreen = false;
		}

		/**
		 * Override to handle click events.
		 * 
		 * This function will be called automatically when this component
		 * receives a click event and clickable is true.
		 */
		protected function onClick (event : MouseEvent) : void
		{
			// override in subclasses
		}

		/**
		 * Override to handle fullscreen events.
		 * 
		 * This function will be called automatically when the display
		 * state changes between normal and fullscreen.
		 */
		protected function onDisplayStateChanged (event : FullScreenEvent) : void
		{
			// override in subclasses
		}


		// public methods

		/**
		 * Set to true to allow this component to receive click events.
		 */
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

		/**
		 * Set to true to allow this component to receive events when the
		 * display state changes between normal and fullscreen.
		 */
		public function set fullscreen (value : Boolean) : void
		{
			if (fullscreen != value)
			{
				_fullscreen = value;

				if (fullscreen && stage)
				{
					stage.addEventListener (FullScreenEvent.FULL_SCREEN, onDisplayStateChanged);
				}
				else if (stage)
				{
					stage.removeEventListener (FullScreenEvent.FULL_SCREEN, onDisplayStateChanged);
				}
			}
		}

		public function get fullscreen () : Boolean
		{
			return _fullscreen;
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
