package org.as3commons.collections.framework
{
   public interface IListIterator extends ICollectionIterator
   {
       
      
      function get previousIndex() : int;
      
      function get nextIndex() : int;
      
      function get index() : int;
   }
}
