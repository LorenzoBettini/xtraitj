package xtraitj.tests.utils

import org.apache.log4j.ConsoleAppender
import org.apache.log4j.Level
import org.apache.log4j.spi.LoggingEvent

/**
 * JvmModelAssociator does not throw exceptions but logs possible
 * errors; we use this class to record possible error events
 */
class XtraitjLogListener extends ConsoleAppender {

	val public events = newArrayList()

	override doAppend(LoggingEvent event) {
		if (event.getLevel == Level.ERROR) {
			events += event
		}
	}

}
