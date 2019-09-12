function getBasePath(param1)
    {
        param1 = param1.substr(0,param1.lastIndexOf("/") + 1);
        return param1;
    }
      
function getDomainName(param1)
    {
        var loc2 = getHostName(param1);
        var loc3 = loc2.split(".");
        loc2 = loc3[loc3.length - 2] + "." + loc3[loc3.length - 1];
        return loc2;
    }
      
function getHostName(param1)
    {
        var loc2 = null;
        var loc3 = undefined;
        param1 = param1.toLowerCase();
        if(param1.indexOf("?") > -1)
        {
           param1 = param1.substr(0,param1.indexOf("?"));
        }
        param1 = param1.substr(0,param1.indexOf("/",8));
        loc2 = param1.substr(param1.indexOf(":") + 2 + 1);
        loc3 = loc2.indexOf(":");
        if(loc3 > -1)
        {
           loc2 = loc2.substr(0,loc3);
        }
        return loc2;
    }
      
function getHostNameWithPort(param1)
    {
        var loc2 = null;
        param1 = param1.toLowerCase();
        if(param1.indexOf("?") > -1)
        {
           param1 = param1.substr(0,param1.indexOf("?"));
        }
        param1 = param1.substr(0,param1.indexOf("/",8));
        loc2 = param1.substr(param1.indexOf(":") + 2 + 1);
        return loc2;
    }
      
function getTime()
    {
        return new Date().getTime();
    }
 
function convertIPtoNumber(param1)
    {
        var loc3 = undefined;
        var loc4 = undefined;
        var loc2 = param1.split(".");
        if(loc2.length != 4)
        {
           return 0;
        }
        loc3 = 0;
        while(loc3 < 4)
        {
           loc2[loc3] = Number(loc2[loc3]);
           loc4 = loc2[loc3];
           if(isNaN(loc4) || loc4 < 0 || loc4 > 255)
           {
              return 0;
           }
           loc3++;
        }
        return loc2[3] + 256 * (loc2[2] + 256 * (loc2[1] + 256 * loc2[0]));
    }
	  
function ipRangeStart(param1)
    {
        var loc3 = undefined;
        var loc2 = param1.split("/");
        if(loc2.length != 2)
        {
           return 0;
        }
        loc3 = ipToLong(loc2[0]);
        if(loc3 == 0)
        {
           return 0;
        }
        return loc3;
    }
      
function ipRangeStop(param1)
    {
        var loc3 = undefined;
        var loc4 = undefined;
        var loc5 = undefined;
        var loc2 = param1.split("/");
        if(loc2.length != 2)
        {
           return 0;
        }
        loc3 = ipToLong(loc2[0]);
        if(loc3 == 0)
        {
           return 0;
        }
        loc4 = Number(loc2[1]);
        if(loc4 > 32 || loc4 < 0)
        {
           return 0;
        }
        loc5 = Math.pow(2,32 - loc4) - 1;
        return loc3 + loc5;
    }
      
function ipToLong(param1)
    {
        var loc4 = NaN;
        var loc2 = 0;
        var loc3 = param1.split(".");
        if(loc3.length != 4)
        {
           return 0;
        }
        loc4 = 0;
        while(loc4 < 4)
        {
           if(loc3[loc4] > 255 || loc3[loc4] < 0)
           {
              return 0;
           }
           loc2 = loc2 * 256;
           loc2 = loc2 + Number(loc3[loc4]);
           loc4++;
        }
        return _loc2_;
    }
      
function longToIp(param1)
    {
        var loc5 = NaN;
        var loc2 = new Array(0,0,0,0);
        var loc3 = 16777216;
        var loc4 = 0;
        while(loc4 < 4)
        {
           loc5 = Math.floor(param1 / loc3);
           param1 = param1 - loc3 * loc5;
           loc2[loc4] = loc5;
           loc3 = loc3 / 256;
           loc4++;
        }
        return loc2.join(".");
    }
/*
      public static function fullPath(param1:DisplayObject) : String
      {
         var _loc2_:Array = new Array(param1.name);
         var _loc3_:* = param1;
         while(_loc3_.parent != null)
         {
            if(_loc3_.parent == nicht)
            {
               break;
            }
            _loc2_.push(_loc3_.parent.name);
            _loc3_ = _loc3_.parent;
         }
         _loc2_.reverse();
         return _loc2_.join(".");
      }

   }
}
*/
