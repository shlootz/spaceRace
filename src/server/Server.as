/**
 * Created by Alex Popescu on 23.07.2014.
 */
package server {
import flash.utils.Dictionary;

import simulation.BasicSimulation;

public class Server {

    private var _country:String;
    private var _registeredModules:Dictionary = new Dictionary(true);
    private var _registeredUsers:Dictionary = new Dictionary(true);

    public function Server(country:String) {
        _country = country;
    }

    public function registerModule(name:String, module:BasicSimulation):void
    {
        _registeredModules[name] = module;
    }

    public function userConnected(user:User):void
    {
        if(processUser(user, true))
        {
            _registeredUsers[user.userID] = user;
        }
    }

    public function userDisconnected(user:User):void
    {
        if(processUser(user, false))
        {
            _registeredUsers[user.userID] = null;
        }
    }

    private function processUser(user:User, connected:Boolean):Boolean
    {
        var success:Boolean = false;
        if(_registeredModules[user.userRole] != null)
        {
            if(connected) {
                (_registeredModules[user.userRole] as BasicSimulation).workers++;
            } else
            {
                (_registeredModules[user.userRole] as BasicSimulation).workers--;
            }

        }

        return success;
    }
}
}
