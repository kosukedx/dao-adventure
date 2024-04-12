import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

actor {
    // Define an immutable variable name of type Text that represents the name of your DAO.
    let name : Text = "Certify";
    // Define a mutable variable manifesto of type Text that represents the manifesto of your DAO.
    var manifesto : Text = "Publish non-fungible certification and contibute to trustworthy society";
    // Define a mutable variable goals of type Buffer<Text> will store the goals of your DAO.
    var goals : Buffer.Buffer<Text> = Buffer.Buffer<Text>(0);

    public shared query func getName() : async Text {
        name;
    };

    public shared query func getManifesto() : async Text {
        manifesto;
    };

    public func setManifesto(newManifesto : Text) : async () {
        manifesto := newManifesto;
        return;
    };

    public func addGoal(newGoal : Text) : async () {
        goals.add(newGoal);
        return;
    };

    public shared query func getGoals() : async [Text] {
        return Buffer.toArray(goals);
    };
};
