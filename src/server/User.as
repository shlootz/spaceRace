/**
 * Created by Alex Popescu on 23.07.2014.
 */
package server {
public class User {

    public var userName:String;
    public var userID:String;
    public var userFacebookID:String;
    public var userCountry:String;
    public var userRole:String;

    public function User(uName:String, uID:String, uFBID:String, uCountry:String, uRole:String) {
        userName = uName;
        userID = uID;
        userFacebookID = uFBID;
        userCountry = uCountry;
        userRole = uRole;
    }
}
}
