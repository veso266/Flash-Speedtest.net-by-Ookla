package org.as3commons.collections.framework
{
   public interface IOrderedMap extends IMap, IInsertionOrder
   {
       
      
      function addFirst(param1:*, param2:*) : Boolean;
      
      function addLast(param1:*, param2:*) : Boolean;
      
      function addBefore(param1:*, param2:*, param3:*) : Boolean;
      
      function addAfter(param1:*, param2:*, param3:*) : Boolean;
      
      function get firstKey() : *;
      
      function get lastKey() : *;
      
      function nextKey(param1:*) : *;
      
      function previousKey(param1:*) : *;
   }
}
