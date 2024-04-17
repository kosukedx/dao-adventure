import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Types "types";

actor {
    type Member = Types.Member;
    type Result<Ok, Err> = Types.Result<Ok, Err>;
    type HashMap<K, V> = Types.HashMap<K, V>;

    // HashMap constructor requires initial capacity, equal func of key, hash of key.
    let members = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

    // Shared function can declare an optional parameter of type {caller : Principal}.
    public shared ({ caller : Principal }) func addMember(member : Member) : async Result<(), Text> {
        let found : ?Member = members.get(caller);
        switch (found) {
            // Not found then add new member.
            case (null) {
                members.put(caller, member);
                #ok();
            };
            // Member exists, throw error.
            case (?member) {
                #err("A given member already exists");
            };
        };
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        let member : ?Member = members.get(p);
        switch (member) {
            case (?member) {
                #ok(member);
            };
            case (null) {
                #err("member is not found by a given principal");
            };
        };
    };

    public shared ({ caller : Principal }) func updateMember(newMember : Member) : async Result<(), Text> {
        switch (members.get(caller)) {
            case (?member) {
                members.put(caller, newMember);
                #ok();
            };
            case (null) {
                #err("member is not found by a given principal");
            };
        };
    };

    public query func getAllMembers() : async [Member] {
        return Iter.toArray(members.vals());
    };

    public query func numberOfMembers() : async Nat {
        return members.size();
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        switch (members.get(caller)) {
            case (?member) {
                members.delete(caller);
                #ok();
            };
            case (null) {
                #err("member is not found by a given principal");
            };
        };
    };

};
