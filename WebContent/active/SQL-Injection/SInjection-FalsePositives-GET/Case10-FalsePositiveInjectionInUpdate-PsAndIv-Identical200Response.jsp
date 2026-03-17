<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.*" %>
<%@page import="com.sectooladdict.database.ConnectionPoolManager" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Case 10 - False Positive Injection in an update page that always responds with an identical 200 response</title>
</head>
<body>

<%
if (request.getParameter("transactionDate") == null) {
%>
    Update The Description of Transactions in the Following Date:<br><br>
    <form name="frmInput" id="frmInput" action="Case10-FalsePositiveInjectionInUpdate-PsAndIv-Identical200Response.jsp" method="POST">
        <input type="text" name="transactionDate" id="transactionDate" value="2010-02-02"><br>
        <input type=submit value="submit">
    </form>
<%
} 
else {
    try (Connection conn = ConnectionPoolManager.getConnection()) {
  	    String transactionDate = request.getParameter("transactionDate");
  	    
        System.out.print("Connection Opened Successfully\n");

        String SqlString = 
            "UPDATE transactions " +
            "SET description='Hello World' " +
            "WHERE transactionDate=?";
        try (PreparedStatement pstmt = conn.prepareStatement(SqlString)) {
            pstmt.setDate(1,java.sql.Date.valueOf(transactionDate));
            int result = pstmt.executeUpdate();
        }
         
        out.println("Query executed");
    } catch (Exception e) {

        if(!(e instanceof java.sql.SQLSyntaxErrorException)) {
            System.out.println("Exception details: " + e);
        } 
        out.println("Query executed");
    }
} //end of if/else block
%>

</body>
</html>