package fl.text
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.ITextLayoutFormat;
   import flashx.textLayout.formats.TextLayoutFormat;
   
   interface IContainerManager
   {
       
      
      function get contentHeight() : Number;
      
      function get container() : Sprite;
      
      function get paddingTop() : Object;
      
      function set direction(param1:String) : void;
      
      function setTextFormat(param1:TextFormat, param2:int, param3:int, param4:TextLayoutFormat, param5:TextLayoutFormat) : void;
      
      function set editModeNoInteraction(param1:String) : void;
      
      function setCompositionSize(param1:Number, param2:Number) : void;
      
      function get paddingRight() : Object;
      
      function setFormatForAllElements(param1:FlowGroupElement, param2:TextLayoutFormat) : void;
      
      function replaceText(param1:int, param2:int, param3:String) : void;
      
      function compose() : void;
      
      function set paddingRight(param1:Object) : void;
      
      function set paddingTop(param1:Object) : void;
      
      function get numLines() : int;
      
      function set editMode(param1:String) : void;
      
      function removeListeners() : void;
      
      function get controller() : ContainerController;
      
      function addListeners() : void;
      
      function get columnWidth() : Object;
      
      function set columnWidth(param1:Object) : void;
      
      function get paddingBottom() : Object;
      
      function isTextStringAndFormat() : Boolean;
      
      function get contentLeft() : Number;
      
      function set firstBaselineOffset(param1:Object) : void;
      
      function get firstBaselineOffset() : Object;
      
      function get absoluteStart() : int;
      
      function get verticalScrollPosition() : Number;
      
      function get text() : String;
      
      function get verticalAlign() : Object;
      
      function set columnCount(param1:Object) : void;
      
      function convert(param1:Class) : IContainerManager;
      
      function get contentTop() : Number;
      
      function get antialiasType() : String;
      
      function get textColor() : uint;
      
      function set paddingBottom(param1:Object) : void;
      
      function get embedFonts() : Boolean;
      
      function set horizontalScrollPosition(param1:Number) : void;
      
      function get compositionWidth() : Number;
      
      function set antialiasType(param1:String) : void;
      
      function get paddingLeft() : Object;
      
      function set columnGap(param1:Object) : void;
      
      function get columnGap() : Object;
      
      function get hostFormat() : ITextLayoutFormat;
      
      function update() : void;
      
      function get contentWidth() : Number;
      
      function set lineBreak(param1:String) : void;
      
      function set verticalScrollPosition(param1:Number) : void;
      
      function get columnCount() : Object;
      
      function set text(param1:String) : void;
      
      function set blockProgression(param1:Object) : void;
      
      function getLineIndexBounds(param1:int) : Rectangle;
      
      function set verticalAlign(param1:Object) : void;
      
      function get horizontalScrollPosition() : Number;
      
      function set embedFonts(param1:Boolean) : void;
      
      function appendText(param1:String) : void;
      
      function get lineBreak() : String;
      
      function set textColor(param1:uint) : void;
      
      function get blockProgression() : Object;
      
      function set paddingLeft(param1:Object) : void;
      
      function get compositionHeight() : Number;
      
      function get textLength() : int;
      
      function set textFlow(param1:TextFlow) : void;
      
      function getTextFormat(param1:int, param2:int) : TextFormat;
      
      function get textFlow() : TextFlow;
      
      function set hostFormat(param1:ITextLayoutFormat) : void;
      
      function get direction() : String;
   }
}
