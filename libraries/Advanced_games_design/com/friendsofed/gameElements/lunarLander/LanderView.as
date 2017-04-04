﻿package com.friendsofed.gameElements.lunarLander{	import flash.display.*;	import flash.filters.*;	import flash.events.Event;	import com.friendsofed.gameElements.primitives.*;		//Required for creating a gradient fill	import flash.display.GradientType;	import flash.geom.Matrix;	public class LanderView extends AVerletView	{	  private var _thrusterShape:Shape = new Shape();	  		public function LanderView(model:LanderModel):void		{		  super(model);		}		override protected function draw():void		{		  		  //1. Create the thruster		  //Create the gradient fill effect for the thruster			var matrix:Matrix = new Matrix();			matrix.createGradientBox(model.width/2, model.width/3, 			       (90*Math.PI/180), 0, -model.width/4);			var colors:Array = new Array();			colors = [0xFF3300, 0xFFFF00];			var alphas:Array = new Array();			alphas = [100, 0]; 			var ratios:Array = new Array();			ratios = [0, 255];						//1.Draw the thruster flame			_thrusterShape.graphics.lineStyle(1, 0x000000, 0);			_thrusterShape.graphics.beginGradientFill(GradientType.LINEAR, 			                        colors, alphas, ratios, matrix);			_thrusterShape.graphics.moveTo(model.width/4, -model.width/4); 			_thrusterShape.graphics.curveTo(model.width/2, model.width/2, 			                        (model.width/4 * 3), -model.width/4);			_thrusterShape.graphics.lineTo(model.width/4, -model.width/4);			_thrusterShape.graphics.endFill();						//Position the thruster so that it appears under the lander			_thrusterShape.y = (model.height / 4) * 4;						//Make the thruster invisible when it's first drawn			_thrusterShape.visible = false;						//Add a blur filter to the thruster			var thrusterFilters:Array = new Array();			thrusterFilters = _thrusterShape.filters;			thrusterFilters.push(new BlurFilter(5,5,3));			_thrusterShape.filters = thrusterFilters;		  		  //2. Create the lander		  //Create a new Vector object for the drawing coordinates			var coordinates:Vector.<Number> = new Vector.<Number>();						//Push the coordinates into the Vector			coordinates.push(0,3, 10,3, 10,7, 8,7, 10,10, 6,7, 4,7, 0,10, 2,7, 0,7, 0,3, 1,3, 5,-3,9,3);						//Create a Vector object for the drawing commands			var commands:Vector.<int> = new Vector.<int>(); 						//1 = moveTo(), 2 = lineTo(), 3 = curveTo()			commands.push(1,2,2,2,2,2,2,2,2,2,2,2,3);						//Create the landerShape object and draw it.			var landerShape:Shape = new Shape();			landerShape.graphics.lineStyle();			landerShape.graphics.beginFill(0x666666);						//Use the drawPath command to draw the s			//hape using the commands and coordinates Vectors			landerShape.graphics.drawPath(commands, coordinates);			//landerShape.graphics.drawRect(0,0,10,10);			landerShape.graphics.endFill();						//Scale the shape to the model's size			landerShape.width = model.width;			landerShape.height = model.height;						//Create a new sprite to contain the shapes			var lander:Sprite = new Sprite();			lander.addChild(_thrusterShape);			lander.addChild(landerShape);			addChild(lander);						//Add a bevel and drop shadow filters			/*			var filters:Array = [];			filters = lander.filters;			filters.push(new BevelFilter(2, 135, 0xFFFFFF, 0.50, 			                     0x000000, 0.50, 2, 2));			filters.push(new DropShadowFilter(2, 135, 0x000000, 			                     0.35, 2, 2));			lander.filters = filters;			*/			//Center the shape			//lander.x -= model.width / 2;			//lander.y -= model.height / 2;		}		override protected function changeHandler(event:Event):void		{		  //First call the default directives in AVerletView's changeHandler method			super.changeHandler(event);						//Add these new directives to the method			if(model.thrusterFired)			{				_thrusterShape.visible = true;			}			else			{				_thrusterShape.visible = false;			}		}	}}