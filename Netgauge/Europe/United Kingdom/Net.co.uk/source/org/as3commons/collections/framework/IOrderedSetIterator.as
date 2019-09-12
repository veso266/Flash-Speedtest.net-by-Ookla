package org.as3commons.collections.framework
{
   public interface IOrderedSetIterator extends ISetIterator
   {
       
      
      function addBefore(param1:*) : Boolean;
      
      function addAfter(param1:*) : Boolean;
      
      function replace(param1:*) : Boolean;
   }
}
