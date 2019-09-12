package
{
   interface ProxyInterface
   {
       
      
      function unknownProxyCall(param1:*, param2:*) : *;
      
      function handleProxyTestEnd(param1:*, param2:*) : *;
      
      function handleProxyTestPartial(param1:*, param2:*) : *;
      
      function nextTest() : *;
      
      function proxyError(param1:*, param2:*) : *;
      
      function proxyReady() : *;
   }
}
