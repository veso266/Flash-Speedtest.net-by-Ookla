package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.LinkedMap;
   import org.as3commons.collections.framework.IOrderedMapIterator;
   
   use namespace as3commons_collections;
   
   public class LinkedMapIterator extends AbstractLinkedCollectionIterator implements IOrderedMapIterator
   {
       
      
      public function LinkedMapIterator(param1:LinkedMap, param2:LinkedMapNode = null)
      {
         super(param1);
         if(param2)
         {
            _next = param2;
         }
      }
      
      public function addBefore(param1:*, param2:*) : Boolean
      {
         if(_next)
         {
            if(!LinkedMap(_collection).addBefore(LinkedMapNode(_next).key,param1,param2))
            {
               return false;
            }
         }
         else if(!LinkedMap(_collection).addLast(param1,param2))
         {
            return false;
         }
         _current = null;
         return true;
      }
      
      public function addAfter(param1:*, param2:*) : Boolean
      {
         if(_next)
         {
            if(!LinkedMap(_collection).addBefore(LinkedMapNode(_next).key,param1,param2))
            {
               return false;
            }
            _next = _next.left;
         }
         else
         {
            if(!LinkedMap(_collection).add(param1,param2))
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
         if(!_current)
         {
            return false;
         }
         return LinkedMap(_collection).replaceFor(LinkedMapNode(_current).key,param1);
      }
      
      public function get previousKey() : *
      {
         return !!_next?!!_next.left?LinkedMapNode(_next.left).key:undefined:!!_collection.size?LinkedMapNode(_collection.lastNode_internal).key:undefined;
      }
      
      public function get nextKey() : *
      {
         return !!_next?LinkedMapNode(_next).key:undefined;
      }
      
      public function get key() : *
      {
         return !!_current?LinkedMapNode(_current).key:undefined;
      }
      
      override protected function removeCurrent() : void
      {
         LinkedMap(_collection).removeKey(LinkedMapNode(_current).key);
      }
   }
}
