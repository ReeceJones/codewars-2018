import std.stdio;
import std.math;
import std.conv;
import std.range;
import std.typecons;
import std.regex;
import core.stdc.limits; // INT_MAX, FLOAT_MAX, etc
import std.algorithm;
import std.string;

version(prob00)
{
	void invoke()
	{
		writeln("hi Dave.");
	}
}

version(prob01)
{
	void invoke()
	{
		writeln("please don't fail us, ", readln());
	}
}

version(prob02)
{
	// d = vt + (1/2)(at^2)
	void invoke()
	{
		uint v,a,t;
		readf!"%f %f %f\n"(v,a,t);
		while (v != 0 || a != 0 || t != 0)
		{
			staggeredWriteln(
				( v * t ) + ( (0.5) * ( a * t * t ) )
			);
		}
		flush();
	}
}

// you know, I just got an idea...what if I use unit tests for testing, and instead of having all code stored in the invoke function
// I just place it into its own function so that the invoke functions only purpose is to collect user input

version(prob03)
{
	bool isPrime(uint n)
	{
		if (n < 2) return false;
		for(uint i = 2; i < n; i++)
			if (n % i == 0)
				return false;
		return true;
	}
	bool magnanimous(int number)
	{
		bool magnumDong = true;
		string s = number.text;
		foreach(i, c; s)
		{
			if (i == 0) continue;
			string pre = s[0..i];
			string post = s[i..$];
			int n = pre.to!int + post.to!int;
			version(unittest) writeln(n);
			bool prime = n.isPrime();
			if (!prime) magnumDong = false;
		}
		return magnumDong;
	}
	unittest
	{
		assert(magnanimous(40_427) == true);
		assert(magnanimous(819) == false);
		assert(magnanimous(101) == true);
		assert(magnanimous(109) == false);
		assert(magnanimous(2_000_221) == true);
		assert(magnanimous(4063) == true);
		assert(magnanimous(10) == false);
		assert(magnanimous(98) == true);
	}
	void invoke()
	{
		uint n;
		readf!"%u\n"(n);
		while (n != 0)
		{
			staggeredWriteln(n, " ", magnanimous(n) ? "MAGNANIMOUS" : "PETTY");
			readf!("%u\n")(n);
		}
		flush();
	}
}

version(prob04)
{
	alias Coins = Tuple!(int, "gold", int, "silver", int, "bronze");
	Coins findLowest(int gold, int silver, int bronze)
	{
		// 5 bronze -> 1 silver
		int carry = bronze / 5;
		int saved = bronze % 5;
		if (saved == 0)
		{
			carry = (bronze - 1) / 5;
			saved = (bronze - 1) % 5 + 1; //?
		}
		silver += carry;
		bronze = saved;

		// 10 silver -> 1 gold
		carry = silver / 10;
		saved = silver % 10;
		if (saved == 0)
		{
			carry = (silver - 1) / 5;
			carry = (silver - 1) % 5;
		}
		gold += carry;
		silver = saved;
		return Coins(gold, silver, bronze);
	}
	unittest
	{
		auto x = findLowest(500, 400, 300);
		x.writeln;
		assert(x.gold == 545);
		assert(x.silver == 9);
		assert(x.bronze == 5);
		auto y = findLowest(5, 5, 5);
		y.writeln;
		assert(y.gold == 5);
		assert(y.silver == 5);
		assert(y.bronze == 5);
		auto z = findLowest(59, 79, 99);
		z.writeln;
		assert(z.gold == 68);
		assert(z.silver == 8);
		assert(z.bronze == 4);
	}
	void invoke()
	{
		uint lines;
		readf!"%u\n"(lines);
		foreach(_;0..lines)
		{
			uint gold, silver, bronze;
			readf!"%u %u %u\n"(gold, silver, bronze);
			auto r = findLowest(gold, silver, bronze);
			staggeredWriteln(r.gold, " ", r.silver, " ", r.bronze);
		}
		flush();
	}
}

version(prob05)
{
	alias LED = Tuple!(int, "row", int[], "col");
	LED findDay(string start, int target)
	{
		int[string] startOffset = [
			"Sunday" : 0,
			"Monday" : 3,
			"Tuesday" : 6,
			"Wednesday" : 9,
			"Thursday" : 12,
			"Friday" : 15,
			"Saturday" : 18,
		];
		int s = startOffset[start];
		int day = 1;
		int week = 0;
		while (day < target)
		{
			s+=3;
			if (s > 19)
			{
				week++;
				s = 0;
			}
			day++;
		}
		if (day >= 10)
			return LED(week, [s, s+1]);
		else
			return LED(week, [s+1]); // the counter is on the right side
	}
	unittest
	{
		auto a = findDay("Monday", 8);
		assert(a.row == 1);
		assert(a.col == [4]);
		auto b = findDay("Monday", 17);
		assert(b.row == 2);
		assert(b.col == [9, 10]);
		auto c = findDay("Thursday", 1);
		assert(c.row == 0);
		assert(c.col == [13]);
		auto d = findDay("Thursday", 24);
		assert(d.row == 3);
		assert(d.col == [18,19]);
	}
	void invoke()
	{
		uint lines;
		readf!"%u\n"(lines);
		foreach(_;0..lines)
		{
			string start;
			int target;
			auto r = findDay(start, target);
			if (r.col.length > 1)
				staggeredWriteln(r.row, r.col[0], r.col[1]);
			else
				staggeredWriteln(r.row, r.col[0]);
		}
	}
}

version(prob06)
{
	bool validatePhone(string number)
	{
		string san = number.replaceAll(regex(r"[^0-9]", "g"), ""); // remove any non-digit character
		if (san[0] == '0' || san[0] == '1') return false;
		if (san[1] == '9') return false;
		if (san[3] == '1' || san[3] == '0') return false;
		if (san[4] == '1' && san[5] == '1') return false;
		return true;
	}
	unittest
	{
		assert(validatePhone("1234567890") == false);
		assert(validatePhone("(879) 867-5309") == true);
		assert(validatePhone("(494)852-8921") == false);
		assert(validatePhone("(281)302-1492") == true);
		assert(validatePhone("281.302.1492") == true);
		assert(validatePhone("281.311.1492") == false);
		assert(validatePhone("281.012.1492") == false);
		assert(validatePhone("7138675309") == true);
	}
	void invoke()
	{
		uint lines;
		readf!"%u\n"(lines);
		foreach(_;0..lines)
		{
			string phone = readln();
			writeln(phone, " ", validatePhone(phone) ? "VALID": "INVALID");
		}
	}
}

version(prob07)
{
	long maxProduct(int[] num)
	{
		int[] sorted = num.sort!"a < b".array;
		int[] pool; // 3 lowest, and 3 highest values in the set
		if (num.length <= 6)
			pool = sorted;
		else
		{
			int[] bottom = sorted[0..3];
			int[] top = sorted[$-3..$];
			assert(top.length == 3);
			pool = bottom ~ top;
		}
		long max = LONG_MIN;
		foreach(i, x; pool)
		{
			foreach(j, y; pool)
			{
				if (i == j) continue;
				foreach(k, z; pool)
				{
					if (i == k || j == k) continue;
					long product = x * y * z;
					if (product > max)
						max = product;
				}
			}
		}
		return max;
	}
	unittest
	{
		assert(maxProduct([5, -3, 2, 4, -1]) == 40);
		assert(maxProduct([999, 2, 0, 834, 3, 1, 697]) == 580716702);
		assert(maxProduct([2, 1, 0, -1]) == 0);
		assert(maxProduct([5, 2, -3, 4, -4, 1, 0, -2]) == 60);
		assert(maxProduct([89, -2, 2, 3, -4, 87, 1, -98, -6, -97, -1, 88, -3, -99, -5]) == 863478);
		assert(maxProduct([0, -1, -2, -3, -8, -9]) == 0);
		assert(maxProduct([-2, -5, -3, -7, -1, -4, -8, -6]) == -6);
	}
	void invoke()
	{
		int[] input = readln.split(" ").map!(a => a.to!int).array;
		while (input[0] != 0)
		{
			writeln(maxProduct(input[1..$]));
			input = readln.split(" ").map!(a => a.to!int).array;
		}
	}
}

version(prob08)
{
	int serialize(int start, int length)
	{
		int counter = start;
		string cl = counter.text;
		int saved;
		string atom;
		while (atom.length + cl.length <= length)
		{
			saved = counter;
			atom ~= text(counter++);
			cl = counter.text;
		}
		return saved;
	}
	unittest
	{
		assert( serialize(0, 5) == 4 );
		assert( serialize(0, 11) == 9 );
		assert( serialize(3, 9) == 10 );
		assert( serialize(7, 18) == 16 );
		assert( serialize(98, 9) == 100 );
		assert( serialize(13, 1) == 0 );
		assert( serialize(8192, 1024) == 8447 );
		assert( serialize(256, 8192) == 2489 );
	}
	void invoke()
	{
		uint start, length;
		readf!"%u %u\n"(start, length);
		while (start != 0 || length != 0)
		{
			writeln(start, " ", length, " ", serialize(start, length));
			readf!"%u %u\n"(start, length);
		}
	}
}

version(prob09)
{
	string electric(long n)
	{
		// log(2, n)
		int places = cast(int)n.log2.ceil;
		assert( cast(int)log2(5).ceil == 3); // simple check to make sure that this is the right math
		int on;
		foreach(offset; 0..places)
		{
			if ( (n >> offset) & 1 )
				on++;
		}
		// double needed
		if (cast(double)on > cast(double)places / 2.0)
			return "HEAVY";
		else if (cast(double)on < cast(double)places / 2.0)
			return "LIGHT";
		else
			return "BALANCED";
	}
	unittest
	{
		assert( electric(5) == "HEAVY" );
		assert( electric(8) == "LIGHT" );
		assert( electric(10) == "BALANCED" );
		assert( electric(17) == "LIGHT" );
		assert( electric(316) == "HEAVY" );
		assert( electric(632) == "BALANCED" );
		assert( electric(987654321) == "HEAVY" );
		assert( electric(65536) == "LIGHT" );
		assert( electric(8675309) == "HEAVY" );
	}
	void invoke()
	{
		long n;
		readf!"%d\n"(n);
		while (n != 0)
		{
			writeln(n, n.electric);
			readf!("%d\n")(n);
		}
	}
}

version(prob10)
{
	// side : 1 -> 2 -> 3
	// blocks: 1 -> 4 -> 9
	// each side increases by one, and the blocks are that number squared
	int computePaint(int tip, int depth)
	{
		int paint;
		for(int l = 0; l < depth; ++l)
		{
			int sides = cast(int)sqrt(cast(real)(tip)) + l;
			int blocks = sides * sides;
			if (l == 0)
				paint += tip; // top of pyramid
			else
				paint += blocks - cast(int)pow(sides - 1, 2); // blocks - previous blocks
			// calculate the sides
			paint += sides * 4;
		}
		return paint;
	}
	unittest
	{
		assert( computePaint(1,1) == 5 );
		assert( computePaint(1,2) == 16 );
		assert( computePaint(4,2) == 29 );
		assert( computePaint(289,3) == 577 );
	}
	void invoke()
	{
		uint n;
		readf!"%u\n"(n);
		foreach(_; 0..n)
		{
			int start, depth;
			readf!"%d %d\n"(start,depth);
			writeln(computePaint(start, depth), " liters");
		}
	}
}

version(prob11)
{
	void invoke()
	{
		uint n;
		readf!"%u\n"(n);
		foreach(_; n.iota)
		{
			int num;
			long currentScore;
			long bestScore = INT_MIN;
			readf!"%u\n"(num);
			string[] bestPlayers;
			string[] currentPlayers;
			foreach(i; num.iota)
			{
				int skill;
				string name;
				readf!("%d %s\n")(skill, name);
				currentScore += skill;
				if (currentScore >= 0)
				{
					currentPlayers ~= name;
					if (currentScore > bestScore || (currentScore == bestScore && currentPlayers.length > bestPlayers.length))
					{
						bestPlayers = currentPlayers;
						bestScore = currentScore;
					}
				}
				else
				{
					currentScore = 0;
					currentPlayers = [];
				}
			}
			writeln("OUTPUT");
			if (bestScore == INT_MIN) 
			{
				writeln("None");
			}
			else if (bestPlayers.length == 1)
			{
				writeln(bestPlayers[0]);
			}
			else
			{
				writeln(bestPlayers[0], " to ", bestPlayers[$-1]);
			}
		}
	}
}

version(prob12)
{
	int[char] toAssoc(string input)
	{
		int[char] assoc;
		foreach(c; input)
		{
			assoc[c]++;
		}
		return assoc;
	}
	string[] takeCase(string test, string[] cases)
	{
		string[] c;
		foreach(existing; cases)
		{
			string sanTest = test.replace(" ", "");
			string sanCase = existing.replace(" ", "");
			if (sanTest.toAssoc == sanCase.toAssoc)
				c ~= existing;
		}
		c.writeln;
		return c.sort!"a < b".array;
	}
	unittest
	{
		string[] cases = [
			"PETER POTAMUS V THAT THING I SENT YOU",
			"PEOPLE VERSUS ROGERS AND DOO",
			"DOE ONE VS PROLOG PERSAUDERS",
			"PEOPLE V FLINTSTONE"
		];
		assert( takeCase("POETS V FENNEL PILOT", cases)[0] == "PEOPLE V FLINTSTONE");
		assert( takeCase("KRAMER V KRAMER", cases).length == 0);
		assert( takeCase("PHOTOTYPESETTER V GIANT HUMAN SUIT", cases)[0] == "PETER POTAMUS V THAT THING I SENT YOU");
		assert( takeCase("DOE VS PROSPEROUS GOLDEN ERA", cases)[0] == "DOE ONE VS PROLOG PERSAUDERS");
		assert( takeCase("PEOPLE V SEBBEN", cases).length == 0);
	}
	void invoke()
	{
		uint n;
		readf!"%u\n"(n);
		string[] existingCases;
		foreach(_; 0..n)
		{
			existingCases ~= readln();
		}
		readf!"%u\n"(n);
		string[] consideringCases;
		foreach(_; 0..n)
		{
			auto r = takeCase(readln(), existingCases);
			if (r.length == 0)
				writeln("No: No matching case");
			else
				writeln("Yes: ", r[0]);
		}
	}
}

version(prob13)
{
	/*
1
3
0 1 2
3 3 1
5 -2 4
4 4
#.#.
.##.
.##.
#..#

1
2
1 4 1
2 2 1
3 5
.....
....#
.#..

	*/
	alias Point = Tuple!(int, "x", int, "y");
	alias Router = Tuple!(Point, "point", int, "radius");
	int dist(Point p0, Point p1)
	{
		return cast(int)sqrt(cast(double)( (p1.x - p0.x) ^^ 2 + (p1.y - p0.y) ^^ 2 ));
	}
	uint covered(string[] map, Router[] routers)
	{
		uint students;
		Point[] covered;
		foreach(x, ln; map)
		{
			foreach(y, c; ln)
			{
				if (c == '#' && covered.exists(Point(cast(int)x, cast(int)y)) == false) // student
				{
					foreach(router; routers)
					{
						auto d = dist(Point(cast(int)x, cast(int)y), router.point);
						if (d < router.radius && covered.exists(Point(cast(int)x, cast(int)y)) == false)
						{
							students++;
							covered ~= Point(cast(int)x, cast(int)y);
						}
					}
				}
			}
		}
		writeln(covered);
		return students;
	}
	bool exists(Point[] points, Point test)
	{
		foreach(p; points)
			if (test.x == p.x && test.y == p.y)
		 		return true;
		return false;
	}
	void invoke()
	{
		uint cases;
		readf!"%u\n"(cases);
		foreach(_; cases.iota)
		{
			uint nrouters;
			readf!"%u\n"(nrouters);
			Router[] routers;
			foreach(r; nrouters.iota)
			{
				int x, y, radius;
				readf!"%d %d %d\n"(x, y, radius);
				routers ~= Router(Point(x, y), radius);
			}
			string[] map;
			uint x, y;
			readf!"%u %u\n"(x, y);
			foreach(l; x.iota)
			{
				map ~= readln.stripRight;
			}
			writeln(covered(map, routers));
		}
	}
}

version(prob14)
{
	alias Spoke = Tuple!(char, "id", int, "angle"); // angle is from origin
	bool present(Spoke[] sys, Spoke s)
	{
		foreach(x; sys)
		{
			if (s.id == x.id) return true;
		}
		return false;
	}
	// checks if its an exact system
	bool checkExact(Spoke[] sys1, Spoke[] sys2)
	{
		// orient correctly
		while (sys1[0].id != sys2[0].id)
		{
			sys2 = sys2[1..$] ~ [sys2[0]]; // rotate
		}
		auto ssys1 = sys1.computeSummedAngles;
		auto ssys2 = sys2.computeSummedAngles;
		if (ssys1.length != ssys2.length) return false;
		// ensure they have the same keys
		foreach(a; ssys1)
		{
			if (!ssys2.present(a)) return false;
		}

		// check
		foreach(a; ssys1)
		{
			foreach(b; ssys2)
			{
				if (a.id == b.id && b.angle != a.angle)
				{
					return false;
				}
			}
		}
		return true;
	}
	Spoke[] computeSummedAngles(Spoke[] sys)
	{
		Spoke[] repl;
		int theta = 0;
		foreach(s; sys)
		{
			theta += s.angle;
			repl ~= Spoke(s.id, theta);
		}
		return repl;
	}
	bool checkPartial(Spoke[] sys1, Spoke[] sys2)
	{
		auto ssys2 = sys2.computeSummedAngles;
		for (int i = 0; i < sys1.length; i++)
		{
			Spoke[] sys = sys1[i..$] ~ sys1[0..i];
			// compute summedAngles
			auto ssys = sys.computeSummedAngles;
			foreach(spoke1; ssys)
			{
				foreach(spoke2; ssys2)
				{
					if (spoke1.id == spoke2.id && spoke1.angle == spoke2.angle && spoke1.angle < 360 && spoke1.angle > 0)
					{
						writeln(ssys);
						writeln(ssys2);
						return true;
					}
				}
			}
		}
		return false;
	}
	void fixZero(ref Spoke[] sys)
	{
		int sum;
		foreach(s; sys)
		{
			sum += s.angle;
		}
		foreach(ref s; sys)
		{
			if (s.angle == 0)
				s.angle = 360 - sum;
		}
	}
	void invoke()
	{
		int cases = readln.stripRight.to!int;
		foreach(_; cases.iota)
		{
			// Exact:  4 0 B 90 G 120 N 45 P 4 0 N 45 P 105 B 90 G
			// Partial: 3 0 G 20 X 150 M 6 0 X 110 A 40 M 90 V 45 Q 55 G
			// Mismatch: 3 0 G 20 X 150 M 4 0 N 45 P 105 B 90 G
			// create spokes
			string ln = readln.stripRight;
			string[] tok = ln.split(" ");
			int nSpokes = tok[0].to!int;
			tok = tok[1..$];
			Spoke[] left, right;
			foreach(__; nSpokes.iota)
			{
				left ~= Spoke(tok[1][0], tok[0].to!int);
				tok = tok[2..$];
			}
			nSpokes = tok[0].to!int;
			tok = tok[1..$];
			foreach(__; nSpokes.iota)
			{
				tok.writeln;
				right ~= Spoke(tok[1][0], tok[0].to!int);
				if (__ != nSpokes - 1)
					tok = tok[2..$];
			}
			left.fixZero;
			right.fixZero;
			writeln(checkExact(left, right));
			writeln(checkPartial(left, right));
		}
	}
}

version(prob15)
{
	alias Applicator = Tuple!(int, int);
	Applicator[] applicators = [
		Applicator(-1, -1),
		Applicator(1, -1),
		Applicator(-1, 0),
		Applicator(1, 0),
		Applicator(-1, 1),
		Applicator(1, 1)
	];
	void solve(string[] hexagon, string[] wordlist)
	{
		char[][] writtenGrid = [
				[' ',' ',' ',' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' ',' ',' ',' '],     
				[' ',' ',' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' ',' ',' '],         
				[' ',' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' ',' '],        
				[' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' '],         
				[' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' '],      
				['.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.'],       
				[' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' '],       
				[' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' '],     
				[' ',' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' ',' '],     
				[' ',' ',' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' ',' ',' '],        
				[' ',' ',' ',' ',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ',' ',' ',' ',' ']   
		];
		writeln(writtenGrid);
		// iterate through each point
		foreach(i, ln; hexagon)
		{
			foreach(j, c; ln)
			{
				if (c == ' ') continue; // only care about certain characters
				// we use this current point as our base point and expand from here
				string[] narrowedList = wordlist;
				string[Applicator] manuList;
				foreach(a; applicators)
					manuList[a] = [c];
				int dist = 1;
				while (narrowedList.length > 0 && dist < hexagon[0].length * 2 * hexagon.length)
				{
					// we can build 6 strings to check against ours
					foreach(app; applicators)
					{
						char cc;
						// get our character
						if (app[1] != 0)
						{
							int xOffset = cast(int)j + dist * app[0];
							int yOffset = cast(int)i + dist * app[1];
							if (xOffset > 0 && yOffset > 0 && yOffset < hexagon.length && xOffset < hexagon[yOffset].length)
								cc = hexagon[yOffset][xOffset];
							else
								cc = ' ';
						}
						else
						{
							int xOffset = cast(int)j + dist * app[0] * 2; // account for spaces
							if (xOffset > 0 && xOffset < hexagon[i].length)
								cc = hexagon[i][xOffset];
							else
								cc = ' ';
						}
						if (cc == ' ')
						{
							manuList.remove(app); // remove this tracker from manulist
						}
						else
						{
							manuList[app] ~= cc;
						}
					}
					foreach(potentialMatch; narrowedList)
					{
						foreach(key, match; manuList.byPair)
						{
							if (potentialMatch == match) // BREAD ACQUIRED
							{
								writeln("found:\t", match, "\t(", i, ",", j, ")");
								// recreate
								for (int k = 0; k < match.length; k++)
								{
									int xOffset, yOffset;
									xOffset = key[1] != 0 ? (cast(int)j + (k * key[0])) : (cast(int)j + (2 * k * key[0]));
									yOffset = key[1] != 0 ? (cast(int)i + (k * key[1])) : cast(int)i;
									if (match == "COMPILER")
										writeln(xOffset, "\t", yOffset, "\t", match[k]);
									writtenGrid[yOffset][xOffset] = match[k];
								}
							}
							if (potentialMatch.length < match.length) // can't be
							{
								narrowedList.remove(potentialMatch);
								assert(narrowedList.length < wordlist.length, "shortening failed: " ~ narrowedList.to!string ~ " " ~ potentialMatch);
							}
						}
					}
					dist++;
				}
			}
		}
		foreach(ln; writtenGrid)
			writeln(cast(string)ln);
	}
	void remove(ref string[] list, string rem)
	{
		foreach(i, s; list)
		{
			if (s == rem)
			{
				list = list[0..i] ~ list[i+1..$];
				return;
			}
		}
	}
	/*
5 6
PROGRAM
COMPILER
ERROR
SYNTAX
OBJECT
     L I P M O C
    E R P O R Y A
   X A O B J A C T
  R E L I P M O C N
 S I E R R O R E T Y
C Y P M O R Y J X O S
 S N Y G O G B L E R
  U T R R C O M P U
   N A R E R R O W
    M X G I C P U
     L S J N X A

	*/
	void invoke()
	{
		string[] tok = readln.stripRight.split(" ");
		int nWords = tok[0].to!int;
		int puzzleLines = tok[1].to!int * 2 - 1;
		string[] words;
		foreach(_; nWords.iota)
		{
			words ~= readln.stripRight;
		}
		string[] hexagon;
		foreach(_; puzzleLines.iota)
		{
			hexagon ~= readln.stripRight;
		}
		solve(hexagon, words);
	}
}

version(prob16)
{
	uint[char] generateOccuranceMap(string s)
	{
		uint[char] map;
		foreach(c; s)
		{
			map[c]++;
		}
		return map;
	}
	bool unique(uint[char] map)
	{
		foreach(val; map.byValue)
		{
			if (val > 1)
				return false;
		}
		return true;
	}
	bool overlap(uint[char] map1, uint[char] map2)
	{
		foreach(key; map1.byKey)
		{
			auto p = key in map2;
			if (p !is null) return true;
		}
		return false;
	}
	void invoke()
	{
		int n = readln.stripRight.to!int;

		foreach(_; n.iota)
		{
			ulong number = readln.stripRight.to!ulong;
			for (ulong i = 1; i < number / 2; i++)
			{
				ulong conj = number - i;
				string s1 = i.text;
				string s2 = conj.text;
				auto m1 = s1.generateOccuranceMap;
				auto m2 = s2.generateOccuranceMap;
				if (m1.unique && m2.unique && !overlap(m1, m2)) // check to ensure they are fully unique
				{
					ulong prod = conj * i;
					if (prod.text.generateOccuranceMap.unique && prod.text.length == 10)
					{
						writeln(number, " : ", conj > i ? conj : i, " * ", conj > i ? i : conj, " = ", prod);
					}
				}
			}
		}
	}
}

version(prob17)
{
	alias Crate = Tuple!(string, "name", int, "size");
	void invoke()
	{
		string ln;
		Crate[] queue;
		Crate[][string] train;
		Crate[][] sent;
		while ((ln = readln.strip) != "DONE")
		{
			string[] tok = ln.split(" ");
			switch(tok[0])
			{
				default:break;
				case "RECV":
					queue ~= Crate(tok[1], tok[2].to!int);
				break;
				case "LOAD":
					train[tok[1]] ~= queue[0];
					queue = queue[1..$];
				break;
				case "XFER":
					train[tok[2]] ~= train[tok[1]][$-1];
					train[tok[1]] = train[tok[1]][0..$-1];
				break;
				case "SEND":
					sent ~= train[tok[1]];
					train[tok[1]] = [];
				break;
			}
		}
		foreach(i, t; sent)
		{
			writeln(i, "\t", t);
		}
	}
}

version(prob18)
{
	bool present(string[] list, string s)
	{
		foreach(a; list)
			if (a == s)
				return true;
		return false;
	}
	void generateSet(ref string[][] set, string[] options, string[] list, int[][] matches)
	{
		if (list.length == matches.length)
		{
			set ~= list;
			return;
		}
		foreach(s; options)
		{
			foreach(puzzle; matches)
			{
				if (present(list, s) == false && s.length == puzzle.length)
				{
					generateSet(set, options, list ~ s, matches);
				}
			}
		}
	}
	bool verifyList(string[] list, int[][] matches)
	{
		char[int] settings;
		foreach(i, puzzle; matches)
		{
			string s = list[i];
			foreach(j, num; puzzle)
			{
				char c = s[j];
				auto t = num in settings;
				if (t is null)
					settings[num] = c;
				else if (*t != c)
					return false;
			}
		}
		return true;
	}
	void invoke()
	{
		int a, b;
		readf!"%d %d\n"(a,b);
		string[] words;
		int[][] matches;
		foreach(_; a.iota)
			words ~= readln.stripRight;
		foreach(_; b.iota)
			matches ~= readln.stripRight.split(" ")[1..$].map!(a => a.to!int).array;
		string[][] solutionSet;
		generateSet(solutionSet, words, [], matches);
		foreach(solution; solutionSet)
		{
			if (solution.verifyList(matches))
			{
				foreach(s; solution)
					writeln(s);
				return;
			}
		}
	}
}






















// shared utilities
string dataBuffer;

/// pushs data into a buffer, to be flushed later
void staggeredWrite(T...)(T t)
{
	dataBuffer ~= text(t);
}

/// staggeredWriteln, but appends newline
void staggeredWriteln(T...)(T t)
{
	staggeredWrite(t, "\n");
}

/// write all contents of the buffer to screen and clear it
void flush()
{
	write(dataBuffer);
	dataBuffer = "";
}

version(unittest) {}
else
{
	void main()
	{
		invoke();
	}
}
