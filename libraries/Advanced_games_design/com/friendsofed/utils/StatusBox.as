﻿package com.friendsofed.utils{	import flash.text.*;	import flash.filters.*;	import flash.display.Sprite;	import flash.display.Shape;	import flash.events.Event;	import flash.events.MouseEvent;		public class StatusBox extends Sprite	{		private const MINIMIZED_SIZE:uint = 15;		private const PADDING:uint = 5;				//We don't find this font.....		//[Embed(systemFont="Courier New", fontName="embeddedFont", fontWeight="normal", advancedAntiAliasing="true", mimeType="application/x-font")]		//private var EmbeddedFontClass:Class;				[Embed(source = "../media/fonts/embedded/BAUHS93.TTF", fontName="embeddedFont",fontFamily="MyFontName", embedAsCFF="false")]		private var EmbeddedFontClass:Class;				private var _format:TextFormat;		private var _fontSize:uint;		private var _fontColor:uint;		private var _textContent:String;		private var _backgroundColor:uint;		private var _textField:TextField;		private var _textContainer:Sprite;		private var _backgroundFill:Shape;		private var _maxWidth:Number;				public function StatusBox(textContent:String = "", x:Number = 0, y:Number = 0, fontSize:uint = 10, fontColor:uint = 0xFFFFFF, backgroundColor:uint = 0x000000)		{			this._textContent = textContent;			this.x = x;			this.y = y;			this._fontSize = fontSize;			this._fontColor = fontColor;			this._backgroundColor = backgroundColor;						//Create a text format object			_format = new TextFormat();			_format.size = _fontSize;			_format.color = _fontColor;			//The name of the font should match the 			//"name" parameter in the embed tag			_format.font = "embeddedFont"						//Create a TextField object			_textField = new TextField();			_textField.embedFonts = true;			_textField.autoSize = TextFieldAutoSize.LEFT;			_textField.text = _textContent;			_textField.setTextFormat(_format);			_textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;						//Create a sprite object and add the _textContainer to it			_textContainer = new Sprite();			addChild(_textContainer);			_textContainer.addChild(_textField);						_maxWidth = _textField.textWidth;						//Draw the background			drawBackground();						//Add a bevel and drop shadow filter			var textBoxFilters:Array = [];			textBoxFilters = this.filters;			textBoxFilters.push(new BevelFilter(2, 135, 0xFFFFFF, 0.50, 			                                    0x000000, 0.50, 2, 2));			textBoxFilters.push(new DropShadowFilter(2, 135, 0x000000, 0.35, 			                                         2, 2));			this.filters = textBoxFilters;						addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}				private function addedToStageHandler(event:Event):void		{			//Add drag and drop			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);						//Enable double-clicking			mouseChildren = false;			doubleClickEnabled = true;						//Add a double-click event listener			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);			addEventListener(Event.REMOVED_FROM_STAGE,  			                 removedFromStageHandler);		}				private function removedFromStageHandler(event:Event):void		{			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			removeEventListener(Event.REMOVED_FROM_STAGE, 			                    removedFromStageHandler);		}				private function drawBackground():void		{			_textContainer.graphics.clear();			_textContainer.graphics.lineStyle();			_textContainer.graphics.beginFill(_backgroundColor);			_textContainer.graphics.drawRect(0, 0, _maxWidth + PADDING, 			                           _textField.textHeight + PADDING);			_textContainer.graphics.endFill();		}				private function mouseDownHandler(event:Event):void		{			this.startDrag();			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);		}				private function mouseUpHandler(event:Event):void		{			this.stopDrag();			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);		}				//Minimize the window when double-clicked		private function doubleClickHandler(event:Event):void		{			if(this.width == MINIMIZED_SIZE && this.height == 			                 MINIMIZED_SIZE)			{				this.width = _maxWidth + PADDING;				this.height = _textField.textHeight + PADDING;			}			else			{				this.width = MINIMIZED_SIZE;				this.height = MINIMIZED_SIZE;			}		}				//Getters and setters		//text		public function get text():String		{			return _textField.text;		}		public function set text(value:*):void		{			_textField.text = String(value);			_textField.setTextFormat(_format);			//Resize the box only to make it wider			if(_textField.textWidth > _maxWidth)			{				_maxWidth = _textField.textWidth;			}			drawBackground();		}				//fontSize		public function get fontSize():uint		{			return uint(_format.size);		}		public function set fontSize(value:uint):void		{			_format.size = value;			//the TextFormat needs to be reapplied for size change to take effect			_textField.setTextFormat(_format);		}				//color		public function get color():uint		{			return uint(_format.color);		}				public function set color(value:uint):void		{			_format.color = value;			_textField.setTextFormat(_format);		}	}}