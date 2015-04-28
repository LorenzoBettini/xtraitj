package xtraitj.example.examples.stack;

import java.util.Collection;
import xtraitj.example.examples.stack.TStack;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TCollectionStack<T extends Collection<U>, U extends Object> extends TStack<Collection<U>> {
}
