package org.as3commons.collections.framework.core
{
   public class LinkedNode
   {
       
      
      private var _item;
      
      public var left:LinkedNode;
      
      public var right:LinkedNode;
      
      public function LinkedNode(param1:*)
      {
         super();
         this._item = param1;
      }
      
      public function set item(param1:*) : void
      {
         this._item = param1;
      }
      
      public function get item() : *
      {
         return this._item;
      }
   }
}
