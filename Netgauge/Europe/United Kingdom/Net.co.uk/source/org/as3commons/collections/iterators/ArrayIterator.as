package org.as3commons.collections.iterators
{
   import org.as3commons.collections.framework.IListIterator;
   
   public class ArrayIterator implements IListIterator
   {
       
      
      protected var _array:Array;
      
      protected var _next:int;
      
      protected var _current:int = -1;
      
      public function ArrayIterator(param1:Array, param2:uint = 0)
      {
         super();
         this._array = param1;
         this._next = param2 >= this._array.length?-1:int(param2);
      }
      
      public function get previousIndex() : int
      {
         return this._next == -1?int(this._array.length - 1):int(this._next - 1);
      }
      
      public function get nextIndex() : int
      {
         return this._next;
      }
      
      public function get index() : int
      {
         return this._current;
      }
      
      public function hasPrevious() : Boolean
      {
         return this._next && this._array.length;
      }
      
      public function previous() : *
      {
         if(this._next == 0 || !this._array.length)
         {
            this._current = -1;
            return undefined;
         }
         this._next = this._next == -1?int(this._array.length - 1):int(this._next - 1);
         this._current = this._next;
         return this._array[this._current];
      }
      
      public function get current() : *
      {
         return this._array[this._current];
      }
      
      public function start() : void
      {
         this._next = !!this._array.length?0:-1;
         this._current = -1;
      }
      
      public function end() : void
      {
         this._next = this._current = -1;
      }
      
      public function remove() : Boolean
      {
         if(this._current == -1)
         {
            return false;
         }
         if(this._current == this._next)
         {
            if(this._next >= this._array.length - 1)
            {
               this._next = -1;
            }
         }
         else if(this._next > 0)
         {
            this._next--;
         }
         this.removeCurrent();
         this._current = -1;
         return true;
      }
      
      public function hasNext() : Boolean
      {
         return this._next > -1;
      }
      
      public function next() : *
      {
         if(this._next == -1)
         {
            this._current = -1;
            return undefined;
         }
         this._current = this._next;
         this._next = this._next >= this._array.length - 1?-1:int(this._next + 1);
         return this._array[this._current];
      }
      
      protected function removeCurrent() : void
      {
         this._array.splice(this._current,1)[0];
      }
   }
}
