﻿package com.friendsofed.vector{		import flash.geom.Point;	import com.friendsofed.gameElements.primitives.*;	public class VectorMath	{				public function VectorMath()		{		}				//Find the dot product of two VectorModel objects		static public function dotProduct		  (v1:VectorModel, v2:VectorModel):Number 		{			 var dotProduct:Number =  v1.vx *  v2.dx + v1.vy * v2.dy;  		 return dotProduct;		}				static public function dotProduct2		  (v1:VectorModel, v2:VectorModel):Number 		{			 var dotProduct:Number =  v1.vx *  v2.vx + v1.vy * v2.vy;  		 return dotProduct;		}			  //Find the perpProduct of two vectors		static public function perpProduct		  (v1:VectorModel, v2:VectorModel):Number 		{		  var perpProduct:Number = v1.ln.vx *  v2.dx + v1.ln.vy * v2.dy;			//You can calculate the same result using 			//the vectors' vx and vy like this:			//var perpProduct:Number = v1.vx * v2.vy - v1.vy * v2.vx;						if(perpProduct != 0)			{			  return perpProduct;		  }		  else		  {		    return 1;		  }		}				//Find the ratio between the perpProducts of v1 and v2		//This helps to find the intersection point		static public function ratio		  (v1:VectorModel, v2:VectorModel):Number 		{		  //Make sure that the vectors aren't parallel		  if((v1.dx == v2.dx && v1.dy == v2.dy) ||          (v1.dx == -v2.dx && v1.dy == -v2.dy))      {        return 1;      }            //Make sure that neither vector has a length of zero      if((v1.m == 0 || v2.m == 0))      {    	  return 1;      }            //Create a third vector between       //the start points of vectors one and two			//to help find the interection point  		var v3:VectorModel = new VectorModel();  		v3.update(v1.a.x, v1.a.y, v2.a.x, v2.a.y);  		      //Find the ratio      var ratio:Number         = VectorMath.perpProduct(v3, v2) / VectorMath.perpProduct(v1, v2);      return ratio;		}				//Find the distance between two points		static public function distance		  (aX:Number, aY:Number, bX:Number, bY:Number):Number 		{		  var v1:VectorModel = new VectorModel();		  v1.update(aX, aY, bX, bY);		  return v1.m;	  }	  	  //Calculate a collision force vector		static public function collisionForce		  (v1:VectorModel, v2:VectorModel):VectorModel 		{		  var t:Number = VectorMath.ratio(v1, v2);                                            var intersectionX:Number = v1.a.x + v1.vx * t;      var intersectionY:Number = v1.a.y + v1.vy * t;          //Calculate the force of the impact (collision vector)      var collisionForceVx:Number         = v1.a.x + v1.vx - intersectionX;       var collisionForceVy:Number         = v1.a.y + v1.vy - intersectionY;                                          //Create a collision force VectorModel to return to the caller      var collisionVector:VectorModel         = new VectorModel        (0,0,0,0, collisionForceVx, collisionForceVy);              return collisionVector;	  }	  	  //Calculate a projection		static public function project		  (v1:VectorModel, v2:VectorModel):VectorModel 		{		  //Find the dot product between v1 and v2      var dp1:Number = VectorMath.dotProduct(v1, v2);      //Find the projection of v1 onto v2      var vx:Number = dp1 * v2.dx;      var vy:Number = dp1 * v2.dy;            //Add start and end points, if they exist            var aX:Number = 0;      var aY:Number = 0;      var bX:Number = 0;      var bY:Number = 0;            //Create a projection VectorModel to return to the caller      var projectionVector:VectorModel = new VectorModel();            if(v2.a.x != 0      && v2.a.y != 0)      {        aX = v2.a.x;        aY = v2.a.y;        bX = v2.a.x + vx;        bY = v2.a.y + vy;                projectionVector.update(aX, aY, bX, bY);      }      else      {        projectionVector.update(0,0,0,0, vx, vy);      }            return projectionVector;	  }	  	  //Calculate a bounce vector		static public function bounce		  (v1:VectorModel, v2:VectorModel):VectorModel 		{		   //Find the projection onto v2       var p1:VectorModel = VectorMath.project(v1, v2);              //Find the projection onto v2's normal       var p2:VectorModel = VectorMath.project(v1, v2.ln);       //Calculate the bounce vector by adding up the projections       //and reversing the projection onto the normal       var bounceVx:Number = p1.vx + (p2.vx * -1);       var bounceVy:Number = p1.vy + (p2.vy * -1);              //Create a bounce VectorModel to return to the caller       var bounceVector:VectorModel = new VectorModel         (0,0,0,0, bounceVx, bounceVy);		  		   return bounceVector;	  }	  static public function bounce2	    (v1:VectorModel, v2:VectorModel):VectorModel 		{		   //Find the projection onto v2       var p1:VectorModel = VectorMath.project(v1, v2);              //Find the projection onto v2's normal       var p2:VectorModel = VectorMath.project(v1, v2.ln);       //Calculate the bounce vector by adding up the projections       //and reversing the projection onto the normal       var bounceVx:Number = p1.vx + p2.vx;       var bounceVy:Number = p1.vy + p2.vy;              //Create a bounce VectorModel to return to the caller       var bounceVector:VectorModel          = new VectorModel(0,0,0,0, bounceVx, bounceVy);		  		   return bounceVector;	  }	 	  static public function findIntersection	    (v1:VectorModel, v2:VectorModel):Number 		{		  //Find out if the vectors are paralell		  if ((v1.dx == v2.dx && v1.dy == v2.dy) 		  || (v1.dx == -v2.dx && v1.dy == -v2.dy)) 		  {      	return 1;      }       else       {      	//Create two new vectors between the       	//start points of vectors 1 and 2      	var v3:VectorModel       	  = new VectorModel(v1.a.x, v1.a.y, v2.a.x, v2.a.y);      	var v4:VectorModel       	  = new VectorModel(v2.a.x, v2.a.y, v1.a.x, v1.a.y);      		      	var t1:Number       	  = VectorMath.perpProduct(v3, v2) / VectorMath.perpProduct(v1, v2);      	var t2:Number       	  = VectorMath.perpProduct(v4, v1) / VectorMath.perpProduct(v2, v1);      		      	if (t1 > 0 && t1 <= 1 && t2 > 0 && t2 <= 1)       	{        	return t1;        }         else         {        	return 1;        }	    }    }        //Use this method to create bounce and friction for the verlet object.		//It takes four arguments: 		//1. The verlet model		//2. The vector that you want to bounce it against		//3. The bounce multiplier, for the amount of "bounciness"		//4. The friction multiplier, for the amount of surface friction between objects				static public  function bounceOnPlane		  (		    verletModel:AVerletModel, 		    plane:VectorModel, 		    bounce:Number, 		    friction:Number		  ):void		{		  var v1:VectorModel 		    = new VectorModel		    (	        verletModel.xPos, 	        verletModel.yPos, 			    verletModel.xPos + verletModel.vx, 			    verletModel.yPos + verletModel.vy			  );  			    		//Find the projection vectors      var p1:VectorModel = VectorMath.project(v1, plane);      var p2:VectorModel = VectorMath.project(v1, plane.ln);              //Calculate the bounce vector      var bounce_Vx:Number = p2.vx * -1;      var bounce_Vy:Number = p2.vy * -1;              //Calculate the friction vector      var friction_Vx:Number = p1.vx;      var friction_Vy:Number = p1.vy;                  verletModel.vx         = (bounce_Vx * bounce) + (friction_Vx * friction);      verletModel.vy         = (bounce_Vy * bounce) + (friction_Vy * friction);	                                   		}	}}