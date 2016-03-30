module bullet.bindings.introspection;

import std.meta;
import std.traits;

import bullet.bindings.dmethods;

template GetMember(alias Symbol, string member) {
    alias GetMember = AliasSeq!(__traits(getMember, Symbol, member));
}

//TODO: submit to Phobos?
template AllMembers(alias Symbol) {
    private alias GetSymbolMember(alias Name) = GetMember!(Symbol, Name);
    alias AllMembers = staticMap!(GetSymbolMember, __traits(allMembers, Symbol));
}

/++
Returns all members of type T that have the @Binding attribute
+/
template BindingMembers(T) {
    alias BindingMembers = getSymbolsByUDA!(T, Binding);
}

//TODO: use UDAs instead? Some other cleaner method?
enum isBindingClass(T) = hasMember!(T, "_cppName");

template BindingClasses(alias Module) {
    alias BindingClasses = Filter!(isBindingClass, AllMembers!Module);
}

template isPackage(alias Symbol) {
    enum isPackage = __traits(isPackage, Symbol);
}

template isModule(alias Symbol) {
    enum isModule = __traits(isPackage, Symbol);
}

template SubPackages(alias Package) if(isPackage!Package) {
    alias SubPackages = Filter!(isPackage, AllMembers!Package);
}

pragma(msg, fullyQualifiedName!bullet);
pragma(msg, __traits(allMembers, std));
pragma(msg, __traits(allMembers, bullet.dmethods));
pragma(msg, SubPackages!(.bullet));

/+
TODO: use or remove these.
template isBindingMember(alias member) {
    enum isBindingMember = anySatisfy!(isBindingAttribute, __traits(getAttributes, member));
}

template isBindingAttribute(attribute) {
    enum isBindingAttribute = is(attribute == Binding);
}
+/
