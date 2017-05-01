package 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets 
	{
		[Embed(source = "../media/graphics/cube.png")]
		public static const EnemyCube:Class;
		
		[Embed(source = "../media/graphics/firegreen.png")]
		public static const Projectile:Class;
		
		[Embed(source = "../media/graphics/rubik_ingame.png")]
		public static const Player:Class;
		
		[Embed(source = "../media/graphics/rubik_menu.png")]
		public static const Character_menu:Class;
		
		[Embed(source = "../media/graphics/bg_blue.jpg")]
		public static const BlueBg:Class;
		
		[Embed(source = "../media/graphics/bg_pink.jpg")]
		public static const PinkBg:Class;
		
		[Embed(source = "../media/graphics/menu_bg.jpg")]
		public static const MenuBg:Class;
		
		[Embed(source = "../media/graphics/1_off.jpg")]
		public static const Lvl1Btn_off:Class;
		
		[Embed(source = "../media/graphics/1_on.jpg")]
		public static const Lvl1Btn_on:Class;
		
		[Embed(source = "../media/graphics/1_over.jpg")]
		public static const Lvl1Btn_over:Class;
		
		[Embed(source = "../media/graphics/2_off.jpg")]
		public static const Lvl2Btn_off:Class;
		
		[Embed(source = "../media/graphics/2_on.jpg")]
		public static const Lvl2Btn_on:Class;
		
		[Embed(source = "../media/graphics/2_over.jpg")]
		public static const Lvl2Btn_over:Class;
		
		[Embed(source = "../media/graphics/3_off.jpg")]
		public static const Lvl3Btn_off:Class;
		
		[Embed(source = "../media/graphics/3_on.jpg")]
		public static const Lvl3Btn_on:Class;
		
		[Embed(source = "../media/graphics/3_over.jpg")]
		public static const Lvl3Btn_over:Class;
		
		[Embed(source = "../media/graphics/level_one.jpg")]
		public static const levelOne:Class;
		
		[Embed(source = "../media/graphics/level_two.jpg")]
		public static const levelTwo:Class;
		
		[Embed(source = "../media/graphics/level_three.jpg")]
		public static const levelThree:Class;
		
		[Embed(source = "../media/fonts/American Captain.TTF", fontFamily = "MyFont", embedAsCFF = "false")]
		public static var myFont:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			
			return gameTextures[name];
		}
	}

}