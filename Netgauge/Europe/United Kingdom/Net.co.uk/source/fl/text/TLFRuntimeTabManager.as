package fl.text
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.edit.SelectionManager;
   import flashx.textLayout.elements.TextFlow;
   
   public class TLFRuntimeTabManager
   {
      
      private static var sTabHandlerInited:Boolean = false;
       
      
      public function TLFRuntimeTabManager()
      {
         super();
      }
      
      private static function onKeyFocusChange(param1:FocusEvent) : void
      {
         var _loc2_:InteractiveObject = null;
         var _loc3_:SelectionManager = null;
         var _loc4_:Object = null;
         var _loc5_:TextFlow = null;
         var _loc6_:ContainerController = null;
         if(param1.relatedObject)
         {
            _loc2_ = param1.relatedObject;
            if(_loc2_.parent.hasOwnProperty("textFlow"))
            {
               _loc4_ = _loc2_.parent;
               _loc5_ = _loc4_["textFlow"];
               if(_loc5_ != null && _loc5_.interactionManager != null)
               {
                  _loc3_ = _loc5_.interactionManager as SelectionManager;
                  if(_loc5_.flowComposer.numControllers == 1)
                  {
                     _loc5_.flowComposer.updateAllControllers();
                     _loc3_.selectAll();
                  }
                  else
                  {
                     _loc6_ = _loc4_["controller"];
                     _loc3_.selectRange(_loc6_.absoluteStart,_loc6_.absoluteStart + _loc6_.textLength);
                  }
               }
            }
            else if(_loc2_.parent.hasOwnProperty("tcm"))
            {
               _loc3_ = _loc2_.parent["tcm"].beginInteraction() as SelectionManager;
               _loc3_.selectAll();
            }
         }
      }
      
      private static function onAddedToStage(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(_loc2_)
         {
            _loc2_.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
            if(!sTabHandlerInited)
            {
               _loc2_.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onKeyFocusChange);
               sTabHandlerInited = true;
            }
         }
      }
      
      public static function InitTabHandler(param1:DisplayObject) : void
      {
         if(!sTabHandlerInited)
         {
            if(param1.stage)
            {
               param1.stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,onKeyFocusChange);
               sTabHandlerInited = true;
            }
            else
            {
               param1.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
            }
         }
      }
   }
}
