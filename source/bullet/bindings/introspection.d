module bullet.bindings.introspection;

import std.traits;

import bullet.bindings.dmethods;

/++
Returns all members of type T that have the @Binding attribute
+/
template BindingMembers(T) {
    alias BindingMembers = getSymbolsByUDA!(T, Binding);
}

/+
TODO: use or remove these.
template isBindingMember(alias member) {
    enum isBindingMember = anySatisfy!(isBindingAttribute, __traits(getAttributes, member));
}

template isBindingAttribute(attribute) {
    enum isBindingAttribute = is(attribute == Binding);
}
+/
