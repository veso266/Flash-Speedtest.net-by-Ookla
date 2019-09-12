package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.ICollectionIterator;
   
   use namespace as3commons_collections;
   
   public class AbstractLinkedCollectionIterator implements ICollectionIterator
   {
       
      
      protected var _collection:AbstractLinkedCollection;
      
      protected var _next:LinkedNode;
      
      protected var _current:LinkedNode;
      
      public function AbstractLinkedCollectionIterator(param1:AbstractLinkedCollection)
      {
         super();
         this._collection = param1;
         if(param1.size)
         {
            this._next = this._collection.firstNode_internal;
         }
      }
      
      public function start() : void
      {
         this._next = !!this._collection.size?this._collection.firstNode_internal:null;
         this._current = null;
      }
      
      public function end() : void
      {
         this._next = this._current = null;
      }
      
      public function hasPrevious() : Boolean
      {
         return this._next != this._collection.firstNode_internal && this._collection.size;
      }
      
      public function previous() : *
      {
         if(this._next == this._collection.firstNode_internal || !this._collection.size)
         {
            this._current = null;
            return undefined;
         }
         this._next = this._next == null?this._collection.lastNode_internal:this._next.left;
         this._current = this._next;
         return this._current.item;
      }
      
      public function get current() : *
      {
         if(!this._current)
         {
            return undefined;
         }
         return this._current.item;
      }
      
      public function remove() : Boolean
      {
         if(!this._current)
         {
            return false;
         }
         this._next = this._current.right;
         this.removeCurrent();
         this._current = null;
         return true;
      }
      
      public function hasNext() : Boolean
      {
         return this._next != null;
      }
      
      public function next() : *
      {
         if(!this._next)
         {
            this._current = null;
            return undefined;
         }
         this._current = this._next;
         this._next = this._next.right;
         return this._current.item;
      }
      
      protected function removeCurrent() : void
      {
      }
   }
}
