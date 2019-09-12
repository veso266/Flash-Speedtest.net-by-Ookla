package
{
   import package_4.class_24;
   
   class class_18
   {
       
      
      protected var var_198 = "fours4me";
      
      protected var var_91 = "bling^bling";
      
      protected var var_173 = "n0v4super";
      
      protected var var_178:String;
      
      protected var var_137:String;
      
      protected var var_81:Array;
      
      protected var var_219:String;
      
      protected var var_235:Boolean = false;
      
      protected var var_149:Array;
      
      protected var var_142:Array;
      
      function class_18()
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = true;
         if(!(_loc1_ && this))
         {
            this.var_149 = new Array("ookla.com","speedtest.net");
            if(!(_loc1_ && _loc2_))
            {
               this.var_142 = new Array();
               if(_loc2_)
               {
                  super();
               }
            }
         }
      }
      
      public function method_213(param1:*) : *
      {
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = true;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(_loc9_)
         {
            if(param1 == "configurationloadfailed")
            {
               if(!(_loc8_ && _loc3_))
               {
                  class_4.error("License - Load Failed");
                  §§push(4);
                  if(!(_loc8_ && this))
                  {
                     return §§pop();
                  }
               }
               addr68:
               return §§pop();
            }
            §§push(param1 == "");
            if(_loc9_)
            {
               if(!§§pop())
               {
                  if(!_loc9_)
                  {
                  }
               }
               addr63:
               if(§§pop())
               {
                  class_4.error("License - License Key is missing");
               }
            }
            §§pop();
            §§goto(addr63);
            §§push(param1 == undefined);
            §§goto(addr68);
            §§push(5);
         }
         if(param1 == "gallery")
         {
            class_4.info("License - Gallery Mode");
            _loc4_ = class_59.var_1.loaderInfo.loaderURL.toLowerCase();
            _loc5_ = class_6.method_31(_loc4_);
            if(_loc9_ || param1)
            {
               if(_loc4_.substr(0,_loc4_.indexOf(":")) == "http")
               {
               }
            }
            _loc6_ = _loc4_.substr(0,_loc4_.indexOf("/",_loc5_.length + 8) + 1);
            if(_loc9_ || param1)
            {
               class_4.info("URL: " + _loc6_);
            }
            _loc7_ = class_24.hash("G$LL/RY" + _loc6_);
            §§push(_loc7_ == "03855aacab57ed1311cca775f3caa3d5");
            if(_loc9_ || param1)
            {
               if(!§§pop())
               {
                  if(_loc9_ || _loc2_)
                  {
                     §§pop();
                     if(!(_loc8_ && param1))
                     {
                        §§push(_loc7_ == "c3b855db38606921e3e82ee65e237ae5");
                     }
                     addr175:
                     class_4.info("License - Gallery URL Valid");
                     if(_loc9_)
                     {
                        return 0;
                     }
                  }
               }
            }
            if(§§pop())
            {
               if(!_loc8_)
               {
                  §§goto(addr175);
               }
            }
         }
         var _loc2_:Array = param1.split("-");
         if(!(_loc8_ && _loc2_))
         {
            this.var_219 = param1;
            if(!_loc8_)
            {
               this.var_178 = String(_loc2_.pop());
               if(_loc9_ || this)
               {
                  this.var_137 = String(_loc2_.shift());
                  if(_loc9_ || param1)
                  {
                  }
               }
               addr228:
               var _loc3_:* = 0;
               if(!_loc8_)
               {
                  §§push(this.method_246());
                  if(_loc9_)
                  {
                     if(!§§pop())
                     {
                        if(_loc8_)
                        {
                        }
                        addr262:
                        §§push(2);
                        addr288:
                        if(!_loc8_)
                        {
                           _loc3_ = §§pop();
                           if(_loc9_ || param1)
                           {
                              class_4.error("License - License Expired");
                           }
                           addr277:
                           §§push(this.method_263());
                        }
                        addr295:
                        _loc3_ = §§pop();
                        if(_loc9_)
                        {
                           class_4.error("License - Invalid License");
                        }
                        return _loc3_;
                     }
                     addr250:
                     §§push(this.method_326());
                     if(_loc9_)
                     {
                        if(!§§pop())
                        {
                           if(_loc9_ || param1)
                           {
                              §§goto(addr262);
                           }
                           addr287:
                           §§goto(addr288);
                           §§push(1);
                        }
                        §§goto(addr277);
                     }
                  }
                  if(!§§pop())
                  {
                     §§goto(addr287);
                  }
                  §§goto(addr295);
               }
               §§push(3);
               if(_loc9_)
               {
                  _loc3_ = §§pop();
                  if(!_loc8_)
                  {
                     class_4.error("License - Invalid Host");
                  }
                  §§goto(addr250);
               }
               §§goto(addr288);
            }
         }
         this.var_81 = _loc2_;
         §§goto(addr228);
      }
      
      public function method_263() : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = true;
         if(!_loc2_)
         {
            §§push(this.var_137);
            if(!(_loc2_ && _loc3_))
            {
               if(§§pop().length != 16)
               {
                  class_4.error("License - Bad Date Hash Length");
                  §§push(false);
                  if(!_loc2_)
                  {
                     return §§pop();
                  }
               }
               else
               {
                  §§push(this.var_178);
                  if(_loc2_)
                  {
                  }
                  addr74:
                  var _loc1_:* = §§pop().substr(0,16);
                  if(!_loc2_)
                  {
                     if(_loc1_ != this.var_178)
                     {
                        if(!(_loc2_ && this))
                        {
                           class_4.error("License - Corrupted License (Global)");
                           if(_loc3_ || _loc1_)
                           {
                           }
                           addr114:
                           return §§pop();
                        }
                     }
                     §§goto(addr114);
                     §§push(true);
                  }
                  §§push(false);
                  if(_loc3_)
                  {
                     return §§pop();
                  }
                  §§goto(addr114);
               }
               addr62:
               return §§pop();
            }
            if(§§pop().length != 16)
            {
               if(!(_loc2_ && _loc2_))
               {
                  class_4.error("License - Bad Global Hash Length");
               }
            }
            §§goto(addr74);
            §§push(class_24.hash(this.var_219.slice(0,-16 - 1) + this.var_198));
         }
         §§goto(addr62);
      }
      
      public function method_246() : Boolean
      {
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = true;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(_loc11_ || this)
         {
            class_4.info("License - Current URL: " + class_59.var_1.loaderInfo.loaderURL);
         }
         var _loc1_:* = class_59.var_1.loaderInfo.loaderURL.toLowerCase();
         if(!_loc10_)
         {
            if(_loc1_.indexOf("?") > -1)
            {
            }
            addr69:
            _loc2_ = class_6.method_187(_loc1_);
            if(_loc11_)
            {
               class_4.info("License - Domain: " + _loc2_);
            }
            _loc3_ = class_6.method_31(_loc1_);
            if(!(_loc10_ && this))
            {
               class_4.info("License - Host: " + _loc3_);
            }
            var _loc4_:* = 0;
            continue loop0;
         }
         _loc1_ = _loc1_.substr(0,_loc1_.indexOf("?"));
         §§goto(addr69);
      }
      
      public function method_313() : *
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         var _loc1_:* = undefined;
         if(!_loc3_)
         {
            §§push(class_59.var_1);
            if(!(_loc3_ && _loc1_))
            {
               §§push("trial");
               if(_loc2_)
               {
                  if(§§pop().getChildByName(§§pop()) != null)
                  {
                  }
                  addr58:
                  return;
               }
               addr50:
               _loc1_ = §§pop().getChildByName(§§pop());
               if(!_loc3_)
               {
                  _loc1_.gotoAndPlay("trial");
               }
               §§goto(addr58);
            }
            addr49:
            §§goto(addr50);
            §§push("trial");
         }
         §§goto(addr49);
      }
      
      public function method_326() : Boolean
      {
         var _loc7_:Boolean = true;
         var _loc8_:Boolean = false;
         var _loc6_:* = undefined;
         var _loc1_:* = this.var_137.substr(8,8);
         var _loc2_:* = this.var_137.substr(0,8);
         var _loc3_:* = class_24.hash(_loc1_ + this.var_173).substr(0,8);
         if(_loc7_)
         {
            if(_loc2_ != _loc3_)
            {
               if(!_loc7_)
               {
               }
            }
            addr60:
            var _loc4_:* = new Date(parseInt(_loc1_,16) * 1000);
            if(!_loc8_)
            {
               §§push(class_4);
               §§push("Expiration Date: " + (_loc4_.getMonth() + 1));
               if(!_loc8_)
               {
                  §§push("/");
                  if(_loc7_)
                  {
                     §§push(§§pop() + §§pop());
                     if(_loc7_)
                     {
                        §§push(§§pop() + _loc4_.getDate());
                        if(_loc7_ || this)
                        {
                           §§push("/");
                        }
                     }
                     addr111:
                     §§pop().info(§§pop());
                  }
                  §§push(§§pop() + §§pop());
                  if(!_loc7_)
                  {
                  }
                  §§goto(addr111);
               }
               §§goto(addr111);
               §§push(§§pop() + _loc4_.getFullYear());
            }
            var _loc5_:* = new Date();
            if(_loc7_ || _loc2_)
            {
               if(_loc4_.valueOf() < _loc5_.valueOf())
               {
                  if(!(_loc8_ && _loc1_))
                  {
                     class_4.error("License - License Expired");
                     if(!(_loc8_ && this))
                     {
                        §§push(false);
                        if(_loc7_ || this)
                        {
                           return §§pop();
                        }
                     }
                     addr206:
                     return §§pop();
                  }
                  addr167:
                  _loc6_ = Math.ceil((_loc4_.valueOf() - _loc5_.valueOf()) / (86400 * 1000));
                  if(_loc7_ || _loc3_)
                  {
                     class_4.method_10("License - License Expiring soon: " + _loc6_);
                     if(_loc7_)
                     {
                        class_42.method_321().method_206(_loc6_);
                     }
                  }
               }
               addr205:
               §§goto(addr206);
               §§push(true);
            }
            if(_loc4_.valueOf() < _loc5_.valueOf() + 86400 * 1000 * 15)
            {
               §§goto(addr167);
            }
            §§goto(addr205);
         }
         class_4.error("License - Corrupted License (Date)");
         if(!(_loc8_ && _loc1_))
         {
            return false;
         }
         §§goto(addr60);
      }
   }
}
