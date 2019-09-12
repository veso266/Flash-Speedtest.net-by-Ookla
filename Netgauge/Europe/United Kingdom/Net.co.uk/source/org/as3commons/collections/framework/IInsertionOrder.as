package org.as3commons.collections.framework
{
   public interface IInsertionOrder extends IOrder
   {
       
      
      function reverse() : Boolean;
      
      function sort(param1:IComparator) : Boolean;
   }
}
