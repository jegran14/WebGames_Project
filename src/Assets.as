package 
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Assets 
	{
		[Embed(source = "../media/graphics/CubeWhite.png")]
		public static const EnemyCube:Class;
		
		[Embed(source = "../media/graphics/laser.png")]
		public static const Projectile:Class;
		
		[Embed(source = "../media/graphics/center_trans.png")]
		public static const Shield:Class;
		
		[Embed(source = "../media/graphics/rubik_ingame.png")]
		public static const Player:Class;
		
		[Embed(source = "../media/graphics/rubik_menu.png")]
		public static const Character_menu:Class;
		
		[Embed(source = "../media/graphics/bg_blue.jpg")]
		public static const BlueBg:Class;
		
		[Embed(source = "../media/graphics/bg_pink.jpg")]
		public static const PinkBg:Class;
		
		[Embed(source = "../media/graphics/bg_3.jpg")]
		public static const Lvl3Bg:Class;
		
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
		
		[Embed(source = "../media/graphics/back_off.png")]
		public static const BackBtnOff:Class;
		
		[Embed(source = "../media/graphics/back_on.png")]
		public static const BackBtnOn:Class;
		
		[Embed(source = "../media/fonts/American Captain.TTF", fontFamily = "MyFont", embedAsCFF = "false")]
		public static var myFont:Class;
		
		[Embed(source="../media/sounds/laserGun.mp3")]
		public static const LaserGun:Class;
		
		[Embed(source="../media/sounds/EnemyCollide.mp3")]
		public static const EnemyCollide:Class;

		[Embed(source="../media/sounds/EnemyDestroy.mp3")]
		public static const EnemyDestroy:Class;
		
		[Embed(source="../media/sounds/EnemyFreeze.mp3")]
		public static const EnemyFreeze:Class;
		
		[Embed(source="../media/sounds/EnemyUnfreezed.mp3")]
		public static const EnemyUnfreeze:Class;
		
		[Embed(source="../media/sounds/ShieldImpact.mp3")]
		public static const ShieldCollision:Class;
		
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