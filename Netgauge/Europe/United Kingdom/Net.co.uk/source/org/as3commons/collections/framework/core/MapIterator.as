package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IMap;
   import org.as3commons.collections.framework.IMapIterator;
   import org.as3commons.collections.iterators.ArrayIterator;
   
   public class MapIterator extends ArrayIterator implements IMapIterator
   {
       
      
      protected var _map:IMap;
      
      public function MapIterator(param1:IMap)
      {
         this._map = param1;
         super(this._map.keysToArray());
      }
      
      public function get previousKey() : *
      {
         return _array[previousIndex];
      }
      
      public function get nextKey() : *
      {
         return _array[_next];
      }
      
      public function get key() : *
      {
         return super.current;
      }
      
      override public function previous() : *
      {
         return this._map.itemFor(super.previous());
      }
      
      override public function get current() : *
      {
         return this._map.itemFor(super.current);
      }
      
      override public function next() : *
      {
         return this._map.itemFor(super.next());
      }
      
      override protected function removeCurrent() : void
      {
         this._map.removeKey(super.current);
         super.removeCurrent();
      }
   }
}
