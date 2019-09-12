package org.as3commons.collections.framework
{
   public interface IOrderedMapIterator extends IMapIterator
   {
       
      
      function addBefore(param1:*, param2:*) : Boolean;
      
      function addAfter(param1:*, param2:*) : Boolean;
      
      function replace(param1:*) : Boolean;
   }
}
