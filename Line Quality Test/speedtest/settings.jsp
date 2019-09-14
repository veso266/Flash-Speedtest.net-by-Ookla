<%@ page language="java" import="java.io.*" 
%><%@ page contentType="text/xml" 
%><%
  String fileName = getServletContext().getRealPath("settings.xml");
  File file = new File(fileName);

  BufferedReader reader = null;
  StringBuffer contents = new StringBuffer();

  try {
      reader = new BufferedReader(new FileReader(file));
      String text = null;

      // repeat until all lines is read
      while ((text = reader.readLine()) != null)
      {
          contents.append(text)
              .append(System.getProperty(
                  "line.separator"));
      }
  } catch (FileNotFoundException e) {
      // e.printStackTrace();
      out.println("FileNotFoundException");
  } catch (IOException e) {
      // e.printStackTrace();
      out.println("IOException");
  } finally {
      try {
          if (reader != null) {
              reader.close();
          }
      } catch (IOException e) {
          // e.printStackTrace();
      }
  }

  String xml = contents.toString().replace("%CLIENT_IP%", request.getRemoteAddr());
  out.print(xml);
  
%>

