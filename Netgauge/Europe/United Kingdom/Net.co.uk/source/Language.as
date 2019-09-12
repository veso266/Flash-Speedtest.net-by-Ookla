package
{
   class Language
   {
       
      
      protected var translations:Array;
      
      protected var languageString:String = "";
      
      function Language()
      {
         super();
         this.translations = new Array();
         this.loadTranslation();
      }
      
      public function getText(param1:*) : *
      {
         if(this.translations[param1] == undefined)
         {
            return null;
         }
         return this.translations[param1];
      }
      
      public function setText(param1:String, param2:String) : *
      {
         this.translations[param1] = param2;
      }
      
      public function getLanguageString() : *
      {
         return this.languageString;
      }
      
      protected function loadTranslation() : *
      {
      }
   }
}
