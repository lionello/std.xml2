module std.xml2.testing;

import std.array : empty, front, popFront;
import std.typecons : TypeTuple;

alias TestInputTypes = TypeTuple!(
	string, wstring, dstring,
	char[], wchar[], dchar[],
	immutable(ubyte)[], immutable(ushort)[], immutable(uint)[],
	//CharInputRange!dstring
);

struct CharInputRange(T) {
	T input;

	this(string input) {
		import std.conv : to;
		this.input = to!T(input);
	}

	@property auto front() {
		return this.input.front;
	}

	@property bool empty() {
		return this.input.empty;
	}

	@property void popFront() {
		this.input.popFront();
	}
}

T makeTestInputTypes(T,S)(S s) {
	import std.traits : isArray, isSomeString, isUnsigned;
	import std.range.primitives;

	import std.conv : to;
	static if(isSomeString!T) {
		return to!T(s);
	} else static if(isArray!T && is(ElementType!T == immutable(ubyte))) {
		auto sCopy = to!string(s);
		return cast(immutable(ubyte)[])sCopy;
	} else static if(isArray!T && is(ElementType!T == immutable(ushort))) {
		auto sCopy = to!wstring(s);
		return cast(immutable(ushort)[])sCopy;
	} else static if(isArray!T && is(ElementType!T == immutable(uint))) {
		auto sCopy = to!dstring(s);
		return cast(immutable(uint)[])sCopy;
	} else {
		return T(s);
	}
}
