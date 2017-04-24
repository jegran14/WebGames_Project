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
		
		[Embed(source = "../media/graphics/bg_blue.jpg")]
		public static const BlueBg:Class;
		
		[Embed(source = "../media/graphics/menu_bg.jpg")]
		public static const MenuBg:Class;
		
		[Embed(source = "../media/graphics/Level1Btn.png")]
		public static const Lvl1Btn:Class;
		
		[Embed(source = "../media/graphics/Level2Btn.png")]
		public static const Lvl2Btn:Class;
		
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