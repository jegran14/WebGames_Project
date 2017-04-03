﻿package com.friendsofed.utils{	import flash.text.*;	import flash.filters.*;	import flash.display.Sprite;	import flash.display.Shape;	public class EasyText extends Sprite	{		[Embed(systemFont="Andale Mono", fontName="embeddedFont", 		fontWeight="normal", advancedAntiAliasing="true", 		mimeType="application/x-font")]    private var EmbeddedFontClass:Class;				private var _format:TextFormat;		private var _textField:TextField;		private var _textContainer:Sprite;		private var _backgroundFill:Shape;		private var _maxWidth:Number;				public function EasyText		  (		    textContent:String = "", 		    fontSize:uint = 12,		    color:uint = 0x000000		  )		{			//Create a text format object			_format = new TextFormat();			_format.size = fontSize;			_format.color = color;			//The name of the font should match the 			//"name" parameter in the embed tag			_format.font = "embeddedFont"						//Create a TextField object			_textField = new TextField();			_textField.embedFonts = true;			_textField.autoSize = TextFieldAutoSize.LEFT;			_textField.text = textContent;			_textField.setTextFormat(_format);			_textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;						//Create a sprite object and add the _textContainer to it			_textContainer = new Sprite();			addChild(_textContainer);			_textContainer.addChild(_textField);						_maxWidth = _textField.textWidth;		}				//Getters and setters		//text		public function get text():String		{			return _textField.text;		}		public function set text(text:String):void		{			_textField.text = text;			_textField.setTextFormat(_format);			//Resize the box only to make it wider			if(_textField.textWidth > _maxWidth)			{				_maxWidth = _textField.textWidth;			}		}				//fontSize		public function get fontSize():uint		{			return uint(_format.size);		}		public function set fontSize(fontSize:uint):void		{			_format.size = fontSize;			//the TextFormat needs to be reapplied 			//for size change to take effect			_textField.setTextFormat(_format);		}				//color		public function get color():uint		{			return uint(_format.color);		}				public function set color(color:uint):void		{			_format.color = color;			_textField.setTextFormat(_format);		}	}}