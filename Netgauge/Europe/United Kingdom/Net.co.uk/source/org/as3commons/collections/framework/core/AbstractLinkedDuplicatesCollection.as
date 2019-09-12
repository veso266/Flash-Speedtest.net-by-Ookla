package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IDuplicates;
   
   public class AbstractLinkedDuplicatesCollection extends AbstractLinkedCollection implements IDuplicates
   {
       
      
      public function AbstractLinkedDuplicatesCollection()
      {
         super();
      }
      
      public function count(param1:*) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:LinkedNode = _first;
         while(_loc3_)
         {
            if(_loc3_.item === param1)
            {
               _loc2_++;
            }
            _loc3_ = _loc3_.right;
         }
         return _loc2_;
      }
      
      public function removeAll(param1:*) : uint
      {
         var _loc4_:LinkedNode = null;
         var _loc2_:uint = _size;
         var _loc3_:LinkedNode = _first;
         while(_loc3_)
         {
            _loc4_ = _loc3_.right;
            if(_loc3_.item === param1)
            {
               removeNode(_loc3_);
            }
            _loc3_ = _loc4_;
         }
         return _loc2_ - _size;
      }
   }
}
