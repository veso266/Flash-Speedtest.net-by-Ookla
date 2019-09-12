package org.as3commons.collections.framework
{
   public interface IOrder extends ICollection
   {
       
      
      function get first() : *;
      
      function get last() : *;
      
      function removeFirst() : *;
      
      function removeLast() : *;
   }
}
