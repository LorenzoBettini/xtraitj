package xtraitj.example.examples.extensions.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.xtext.xbase.lib.Functions;
import org.junit.Before;
import org.junit.Test;

import xtraitj.example.examples.extensions.StringIterableWithExtensions;

import com.google.common.collect.Lists;

public class ExtensionsTest {
	
	StringIterableWithExtensions list;
	
	@Before
	public void setUp() {
		list = new StringIterableWithExtensions(
				Lists.newArrayList("first", "second", "third"));
	}

	@Test
	public void testEmptyList() {
		list = new StringIterableWithExtensions(new ArrayList<String>());
		assertNull(list.head());
		assertNull(list.last());
	}
	
	@Test
	public void testHead() {
		assertEquals("first", list.head());
	}
	
	@Test
	public void testLast() {
		assertEquals("third", list.last());
	}

	@Test
	public void testJoin() {
		assertEquals("first, second, third", list.join(", "));
		assertEquals("first - second - third", list.join(" - "));
	}

	@Test
	public void testMapToList() {
		List<Integer> lengths = list.mapToList(new Functions.Function1<String, Integer>() {
			public Integer apply(String p) {
				return p.length();
			}
		});
		assertEquals("[5, 6, 5]", lengths.toString());
	}

	@Test
	public void testMap() {
		Iterable<Integer> lengths = list.map(new Functions.Function1<String, Integer>() {
			public Integer apply(String p) {
				return p.length();
			}
		});
		assertEquals("[5, 6, 5]", 
				Lists.newArrayList(lengths).toString());
	}
}
