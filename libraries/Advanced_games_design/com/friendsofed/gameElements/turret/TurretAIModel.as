﻿package com.friendsofed.gameElements.turret{	import flash.events.Event;	import flash.events.EventDispatcher;	import com.friendsofed.gameElements.primitives.*;	public class TurretAIModel extends AVerletModel	{	  //The angle of the turret is stored in 	  //AVerletModel's angle property	  public var constrainLeft:int = 0;	  public var constrainRight:int = 0;	  public var enemy:Object;	  public var fireFrequency:int; //number in miliseconds	  public var randomFire:Boolean = false;	  public var attackRange:int = 300;	  	  private var _fireBullet:Boolean = false;	    		public function TurretAIModel		  (		    width:uint = 30, 		    height:uint = 30, 		    color:uint = 0x999999,		    constrainLeft:int = 0,		    constrainRight:int = 0,		    enemy:Object = null,		    attackRange:int = 300,		    fireFrequency:int = 1000,		    randomFire:Boolean = false		  ):void 		{		  this.width = width;		  this.height = height;		  this.color = color;		  this.constrainLeft = constrainLeft;		  this.constrainRight = constrainRight;		  this.enemy = enemy; 		  this.fireFrequency = fireFrequency;		  this.attackRange = attackRange;		  this.randomFire = randomFire;		}			  public function get fireBullet():Boolean	  {	    return _fireBullet;	  }	  public function set fireBullet(value:Boolean):void	  {	    _fireBullet = value;	    dispatchEvent(new Event(Event.CHANGE));	  }	}	}