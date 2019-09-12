package org.as3commons.collections.framework
{
   public interface ICollectionIterator extends IIterator
   {
       
      
      function hasPrevious() : Boolean;
      
      function previous() : *;
      
      function get current() : *;
      
      function start() : void;
      
      function end() : void;
      
      function remove() : Boolean;
   }
}
