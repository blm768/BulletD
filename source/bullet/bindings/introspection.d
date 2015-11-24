module bullet.bindings.introspection;

import std.traits;

import bullet.bindings.dmethods;

//TODO: submit to Phobos?
template allMembers(alias symbol) {
    private alias getMember(alias Name) = getMember!(symbol, Name);
    alias allMembers = staticMap!(getMember, __traits(allMembers, symbol));
}

/++
Returns all members of type T that have the @Binding attribute
+/
template BindingMembers(T) {
    alias BindingMembers = getSymbolsByUDA!(T, Binding);
}

enum isBindingClass(T) = hasMember!(T, "_cppName");

template BindingClasses(alias Module) {
    alias BindingClasses = Filter!(isBindingClass, allMembers!Module);
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
