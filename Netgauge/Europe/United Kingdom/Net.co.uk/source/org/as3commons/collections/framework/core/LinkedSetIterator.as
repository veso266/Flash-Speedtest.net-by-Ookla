package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.LinkedSet;
   import org.as3commons.collections.framework.IOrderedSetIterator;
   
   use namespace as3commons_collections;
   
   public class LinkedSetIterator extends AbstractLinkedCollectionIterator implements IOrderedSetIterator
   {
       
      
      public function LinkedSetIterator(param1:LinkedSet, param2:LinkedNode = null)
      {
         super(param1);
         if(param2)
         {
            _next = param2;
         }
      }
      
      public function addBefore(param1:*) : Boolean
      {
         if(_next)
         {
            if(!LinkedSet(_collection).addBefore(_next.item,param1))
            {
               return false;
            }
         }
         else if(!LinkedSet(_collection).addLast(param1))
         {
            return false;
         }
         _current = null;
         return true;
      }
      
      public function addAfter(param1:*) : Boolean
      {
         if(_next)
         {
            if(!LinkedSet(_collection).addBefore(_next.item,param1))
            {
               return false;
            }
            _next = _next.left;
         }
         else
         {
            if(!LinkedSet(_collection).add(param1))
            {
               return false;
            }
            _next = _collection.lastNode_internal;
         }
         _current = null;
         return true;
      }
      
      public function replace(param1:*) : Boolean
      {
         var _loc2_:LinkedNode = null;
         var _loc3_:LinkedNode = null;
         if(!_current)
         {
            return false;
         }
         _loc2_ = _current;
         _loc3_ = _current.left;
         if(!LinkedSet(_collection).replace(_loc2_.item,param1))
         {
            return false;
         }
         _current = !!_loc3_?_loc3_.right:_collection.firstNode_internal;
         if(_loc2_ == _next)
         {
            _next = _current;
         }
         return true;
      }
      
      public function get previousItem() : *
      {
         return !!_next?!!_next.left?_next.left.item:undefined:!!_collection.size?_collection.lastNode_internal.item:undefined;
      }
      
      public function get nextItem() : *
      {
         return !!_next?_next.item:undefined;
      }
      
      override protected function removeCurrent() : void
      {
         LinkedSet(_collection).remove(_current.item);
      }
   }
}
