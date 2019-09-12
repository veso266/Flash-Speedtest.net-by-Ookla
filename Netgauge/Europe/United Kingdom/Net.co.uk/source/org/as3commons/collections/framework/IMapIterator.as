package org.as3commons.collections.framework
{
   public interface IMapIterator extends ICollectionIterator, IBasicMapIterator
   {
       
      
      function get previousKey() : *;
      
      function get nextKey() : *;
   }
}
