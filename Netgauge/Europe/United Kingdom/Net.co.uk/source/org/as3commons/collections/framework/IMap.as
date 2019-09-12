package org.as3commons.collections.framework
{
   public interface IMap extends IDuplicates
   {
       
      
      function add(param1:*, param2:*) : Boolean;
      
      function replaceFor(param1:*, param2:*) : Boolean;
      
      function hasKey(param1:*) : Boolean;
      
      function itemFor(param1:*) : *;
      
      function keysToArray() : Array;
      
      function keyIterator() : IIterator;
      
      function removeKey(param1:*) : *;
   }
}
