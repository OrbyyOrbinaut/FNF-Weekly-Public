package meta.data;

import flixel.FlxG;

using StringTools;

class Highscore
{
	public static var weekScores:Map<String, Int> = new Map();
	public static var marathonScores:Int;
	public static var marathonWins:Int;
	public static var marathonDeaths:Int;
	public static var marathonSongs:Int;
	public static var goldMode:Bool = false;
	public static var songScores:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();


	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function resetMarathon():Void
	{
		setMarathonScore(0);
		setMarathonWins(0);
		setMarathonDeaths(0);
		setMarathonSongs(0);
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
			}
		}
		else {
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	public static function saveMarathonScore(score:Int = 0):Void
	{
		if (marathonScores > 0)
		{
			if (marathonScores < score)
				setMarathonScore(score);
		}
		else
			setMarathonScore(score);
	}

	public static function saveMarathonWins(win:Int):Void
	{
		setMarathonWins(marathonWins + win);
	}

	public static function saveMarathonDeaths(deaths:Int):Void
	{
		setMarathonDeaths(marathonDeaths + deaths);
	}

	public static function saveMarathonSongs(song:Int):Void
	{
		setMarathonSongs(marathonSongs + song);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setMarathonScore(score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		marathonScores = score;
		FlxG.save.data.marathonScores = marathonScores;
		FlxG.save.flush();
	}

	static function setMarathonWins(win:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		marathonWins = win;
		FlxG.save.data.marathonWins = marathonWins;
		FlxG.save.flush();
	}

	static function setMarathonDeaths(die:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		marathonDeaths = die;
		FlxG.save.data.marathonDeaths = marathonDeaths;
		FlxG.save.flush();
	}

	static function setMarathonSongs(song:Int):Void
	{
		marathonSongs = song;
		FlxG.save.data.marathonSongs = marathonSongs;
		FlxG.save.flush();
	}

	public static function setGold():Void
	{
		goldMode = true;
		FlxG.save.data.goldenMode = goldMode;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function getMarathonScore():Int
	{
		if (marathonScores <= 0)
			setMarathonScore(0);

		return marathonScores;
	}

	public static function getMarathonWins():Int
	{
		return marathonWins;
	}

	public static function getMarathonDeaths():Int
	{
		return marathonDeaths;
	}

	public static function getMarathonSongs():Int
	{
		return marathonSongs;
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.marathonScores != null)
		{
			marathonScores = FlxG.save.data.marathonScores;
		}
		if (FlxG.save.data.marathonWins != null)
		{
			marathonWins = FlxG.save.data.marathonWins;
		}
		if (FlxG.save.data.marathonDeaths != null)
		{
			marathonDeaths = FlxG.save.data.marathonDeaths;
		}
		if (FlxG.save.data.marathonSongs != null)
		{
			marathonSongs = FlxG.save.data.marathonSongs;
		}
		if (FlxG.save.data.goldenMode != null)
		{
			goldMode = FlxG.save.data.goldenMode;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
	}
}