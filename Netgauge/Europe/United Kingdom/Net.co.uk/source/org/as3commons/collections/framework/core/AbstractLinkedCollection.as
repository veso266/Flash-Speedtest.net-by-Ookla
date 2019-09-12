package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IComparator;
   import org.as3commons.collections.framework.IInsertionOrder;
   import org.as3commons.collections.framework.IIterator;
   
   public class AbstractLinkedCollection implements IInsertionOrder
   {
       
      
      protected var _first:LinkedNode;
      
      protected var _last:LinkedNode;
      
      protected var _size:uint = 0;
      
      public function AbstractLinkedCollection()
      {
         super();
      }
      
      public function reverse() : Boolean
      {
         var _loc2_:LinkedNode = null;
         var _loc3_:LinkedNode = null;
         if(this._size < 2)
         {
            return false;
         }
         var _loc1_:LinkedNode = this._last;
         while(_loc1_)
         {
            _loc2_ = _loc1_.left;
            if(!_loc1_.right)
            {
               _loc1_.right = _loc1_.left;
               _loc1_.left = null;
               this._first = _loc1_;
            }
            else if(!_loc1_.left)
            {
               _loc1_.left = _loc1_.right;
               _loc1_.right = null;
               this._last = _loc1_;
            }
            else
            {
               _loc3_ = _loc1_.right;
               _loc1_.right = _loc1_.left;
               _loc1_.left = _loc3_;
            }
            _loc1_ = _loc2_;
         }
         return true;
      }
      
      public function sort(param1:IComparator) : Boolean
      {
         if(this._size < 2)
         {
            return false;
         }
         this.mergeSort(param1);
         return true;
      }
      
      public function get first() : *
      {
         if(this._first)
         {
            return this._first.item;
         }
         return undefined;
      }
      
      public function get last() : *
      {
         if(this._last)
         {
            return this._last.item;
         }
         return undefined;
      }
      
      public function removeFirst() : *
      {
         if(!this._size)
         {
            return undefined;
         }
         var _loc1_:* = this._first.item;
         this._first = this._first.right;
         if(this._first)
         {
            this._first.left = null;
         }
         else
         {
            this._last = null;
         }
         this._size--;
         return _loc1_;
      }
      
      public function removeLast() : *
      {
         if(!this._size)
         {
            return undefined;
         }
         var _loc1_:* = this._last.item;
         this._last = this._last.left;
         if(this._last)
         {
            this._last.right = null;
         }
         else
         {
            this._first = null;
         }
         this._size--;
         return _loc1_;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function has(param1:*) : Boolean
      {
         return this.firstNodeOf(param1) != null;
      }
      
      public function toArray() : Array
      {
         var _loc1_:LinkedNode = this._first;
         var _loc2_:Array = new Array();
         while(_loc1_)
         {
            _loc2_.push(_loc1_.item);
            _loc1_ = _loc1_.right;
         }
         return _loc2_;
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:LinkedNode = this.firstNodeOf(param1);
         if(!_loc2_)
         {
            return false;
         }
         this.removeNode(_loc2_);
         return true;
      }
      
      public function clear() : Boolean
      {
         if(!this._size)
         {
            return false;
         }
         this._first = this._last = null;
         this._size = 0;
         return true;
      }
      
      public function iterator(param1:* = undefined) : IIterator
      {
         return null;
      }
      
      as3commons_collections function get firstNode_internal() : LinkedNode
      {
         return this._first;
      }
      
      as3commons_collections function get lastNode_internal() : LinkedNode
      {
         return this._last;
      }
      
      protected function addNodeBefore(param1:LinkedNode, param2:LinkedNode) : void
      {
         if(!param1)
         {
            this.addNodeLast(param2);
            return;
         }
         if(!param1.left)
         {
            this._first = param2;
         }
         param2.left = param1.left;
         param2.right = param1;
         if(param1.left)
         {
            param1.left.right = param2;
         }
         param1.left = param2;
         this._size++;
      }
      
      protected function addNodeAfter(param1:LinkedNode, param2:LinkedNode) : void
      {
         if(!param1)
         {
            this.addNodeFirst(param2);
            return;
         }
         if(!param1.right)
         {
            this._last = param2;
         }
         param2.left = param1;
         param2.right = param1.right;
         if(param1.right)
         {
            param1.right.left = param2;
         }
         param1.right = param2;
         this._size++;
      }
      
      protected function firstNodeOf(param1:*) : LinkedNode
      {
         var _loc2_:LinkedNode = this._first;
         while(_loc2_)
         {
            if(param1 === _loc2_.item)
            {
               return _loc2_;
            }
            _loc2_ = _loc2_.right;
         }
         return null;
      }
      
      protected function addNodeFirst(param1:LinkedNode) : void
      {
         if(!this._first)
         {
            this._first = this._last = param1;
            this._size = 1;
            return;
         }
         this._first.left = param1;
         param1.right = this._first;
         this._first = param1;
         this._size++;
      }
      
      protected function addNodeLast(param1:LinkedNode) : void
      {
         if(!this._first)
         {
            this._first = this._last = param1;
            this._size = 1;
            return;
         }
         this._last.right = param1;
         param1.left = this._last;
         this._last = param1;
         this._size++;
      }
      
      protected function removeNode(param1:LinkedNode) : void
      {
         if(param1.left)
         {
            param1.left.right = param1.right;
         }
         else
         {
            this._first = param1.right;
         }
         if(param1.right)
         {
            param1.right.left = param1.left;
         }
         else
         {
            this._last = param1.left;
         }
         this._size--;
      }
      
      protected function mergeSort(param1:IComparator) : void
      {
         var _loc3_:LinkedNode = null;
         var _loc4_:LinkedNode = null;
         var _loc5_:LinkedNode = null;
         var _loc6_:LinkedNode = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:LinkedNode = this._first;
         var _loc7_:* = 1;
         while(true)
         {
            _loc3_ = _loc2_;
            _loc2_ = _loc6_ = null;
            _loc8_ = 0;
            while(_loc3_)
            {
               _loc8_++;
               _loc11_ = 0;
               _loc9_ = 0;
               _loc4_ = _loc3_;
               while(_loc11_ < _loc7_)
               {
                  _loc9_++;
                  _loc4_ = _loc4_.right;
                  if(!_loc4_)
                  {
                     break;
                  }
                  _loc11_++;
               }
               _loc10_ = _loc7_;
               while(_loc9_ > 0 || _loc10_ > 0 && _loc4_)
               {
                  if(_loc9_ == 0)
                  {
                     _loc5_ = _loc4_;
                     _loc4_ = _loc4_.right;
                     _loc10_--;
                  }
                  else if(_loc10_ == 0 || !_loc4_)
                  {
                     _loc5_ = _loc3_;
                     _loc3_ = _loc3_.right;
                     _loc9_--;
                  }
                  else if(param1.compare(_loc3_.item,_loc4_.item) <= 0)
                  {
                     _loc5_ = _loc3_;
                     _loc3_ = _loc3_.right;
                     _loc9_--;
                  }
                  else
                  {
                     _loc5_ = _loc4_;
                     _loc4_ = _loc4_.right;
                     _loc10_--;
                  }
                  if(_loc6_)
                  {
                     _loc6_.right = _loc5_;
                  }
                  else
                  {
                     _loc2_ = _loc5_;
                  }
                  _loc5_.left = _loc6_;
                  _loc6_ = _loc5_;
               }
               _loc3_ = _loc4_;
            }
            _loc6_.right = null;
            if(_loc8_ <= 1)
            {
               break;
            }
            _loc7_ = _loc7_ << 1;
         }
         this._first = _loc2_;
         this._last = _loc6_;
      }
   }
}
