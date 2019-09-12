package org.as3commons.collections.iterators
{
   import org.as3commons.collections.framework.IIterable;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IRecursiveIterator;
   
   public final class RecursiveIterator implements IRecursiveIterator
   {
       
      
      private var _rootDepth:uint;
      
      private var _depth:uint;
      
      private var _iterator:IIterator;
      
      private var _childIterator:IRecursiveIterator;
      
      private var _parentItems:Array;
      
      public function RecursiveIterator(param1:IIterable, param2:uint = 0, param3:Array = null)
      {
         super();
         this._rootDepth = param2;
         this._depth = param2;
         this._iterator = param1.iterator();
         this._parentItems = !!param3?param3:new Array(param1);
      }
      
      public function get depth() : uint
      {
         return this._depth;
      }
      
      public function hasNext() : Boolean
      {
         if(this._childIterator)
         {
            if(this._childIterator.hasNext())
            {
               return true;
            }
            this._childIterator = null;
            return this.hasNext();
         }
         return this._iterator.hasNext();
      }
      
      public function next() : *
      {
         var _loc1_:* = undefined;
         if(this._childIterator && this._childIterator.hasNext())
         {
            _loc1_ = this._childIterator.next();
            this._depth = this._childIterator.depth;
            return _loc1_;
         }
         this._childIterator = null;
         _loc1_ = this._iterator.next();
         this._depth = this._rootDepth;
         if(_loc1_ is IIterable)
         {
            if(this._parentItems.indexOf(_loc1_) < 0)
            {
               this._childIterator = new RecursiveIterator(_loc1_,this._depth + 1,this._parentItems.concat(_loc1_));
            }
         }
         return _loc1_;
      }
   }
}
