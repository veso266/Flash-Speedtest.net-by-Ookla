package org.as3commons.collections.framework
{
   public interface IOrderedSet extends ISet, IInsertionOrder
   {
       
      
      function addFirst(param1:*) : Boolean;
      
      function addLast(param1:*) : Boolean;
      
      function addBefore(param1:*, param2:*) : Boolean;
      
      function addAfter(param1:*, param2:*) : Boolean;
      
      function replace(param1:*, param2:*) : Boolean;
      
      function next(param1:*) : *;
      
      function previous(param1:*) : *;
   }
}
