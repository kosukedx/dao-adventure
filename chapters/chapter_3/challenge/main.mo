import Result "mo:base/Result";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Types "types";

actor {

    type Result<Ok, Err> = Types.Result<Ok, Err>;
    type HashMap<K, V> = Types.HashMap<K, V>;

    let ledger = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);

    public query func tokenName() : async Text {
        return "Certifik8";
    };

    public query func tokenSymbol() : async Text {
        return "CTF";
    };

    public func mint(owner : Principal, amount : Nat) : async Result<(), Text> {
        let balance = Option.get(ledger.get(owner), 0);
        ledger.put(owner, balance + amount);
        #ok();
    };

    public func burn(owner : Principal, amount : Nat) : async Result<(), Text> {
        let balance = Option.get(ledger.get(owner), 0);
        if (balance < amount) {
            return #err("Insufficient balance to burn");
        };

        ledger.put(owner, balance - amount);
        #ok();
    };

    public shared ({ caller : Principal }) func transfer(from : Principal, to : Principal, amount : Nat) : async Result<(), Text> {
        if (from == to) {
            return #err("Cannot tranfer to yourself");
        };

        let balanceFrom = Option.get(ledger.get(from), 0);
        let balanceTo = Option.get(ledger.get(to), 0);

        if (balanceFrom < balanceTo) {
            return #err("Insufficient balance to transfer");
        };

        ledger.put(from, balanceFrom - amount);
        ledger.put(to, balanceTo + amount);

        #ok();
    };

    public query func balanceOf(account : Principal) : async Nat {
        return Option.get(ledger.get(account), 0);
    };

    public query func totalSupply() : async Nat {
        var sum = 0;
        Iter.iterate<Nat>(
            ledger.vals(),
            func(v, _index) {
                sum += v;
            },
        );

        return sum;
    };

};
