package main;

import com.google.common.collect.Lists;

import my.traits.C;

public class Main {
	public static void main(String[] args) {
		CInterface c = new C();
		System.out.println(c.m());
		System.out.println(new C().m());
		System.out.println(
				new C(Lists.newArrayList
						("first", "second", "third"))
					.m());
	}
}
