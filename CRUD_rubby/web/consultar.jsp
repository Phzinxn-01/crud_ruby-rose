<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Consultar</title>
        <link rel="stylesheet" href="consultar.css"/>
    </head>
    <body>
        <%
            try {
                // Fazer a conexao com o banco de dados
                Connection conecta;
                PreparedStatement st;
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/crud";
                String user = "root";
                String password = "";
                conecta = DriverManager.getConnection(url, user, password);
                
                // Lista os dados da tabela obsidian no banco de dados
                String sql = "SELECT * FROM obsidian";
                st = conecta.prepareStatement(sql);
                // ResultSet serve para guardar aquilo que é trazido do BD
                ResultSet rs = st.executeQuery();
                
                // Formatar data para dd/MM/yyyy
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        %>
        
        <header>
            <img class="imglogo" onclick="location.href='index.html'" src="logo.png" alt="RubyRose">
        </header>
        
        <table border="1">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Categoria</th>
                    <th>Preço</th>
                    <th>Data de Validade</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <%
                // Exibe os dados do ResultSet na tabela
                while (rs.next()) {
                    // Converte a data para o formato desejado
                    String dataDeValidade = rs.getString("data_de_validade");
                    java.sql.Date dataSql = rs.getDate("data_de_validade");  // Recebe a data do banco
                    String dataFormatada = "";
                    if (dataSql != null) {
                        dataFormatada = sdf.format(dataSql);  // Formata a data para o formato dd/MM/yyyy
                    }
                %>
                <tr>
                    <td><%= rs.getString("id") %></td>
                    <td><%= rs.getString("nome") %></td>
                    <td><%= rs.getString("categoria") %></td>
                    <td><%= rs.getString("preco") %></td>
                    <td><%= dataFormatada %></td> <!-- Exibe a data formatada -->
                    <td>
                        <!-- Link para editar o produto -->
                        <a class="edit-btn" href="editar.jsp?id=<%= rs.getString("id") %>&nome=<%= rs.getString("nome") %>&categoria=<%= rs.getString("categoria") %>&preco=<%= rs.getString("preco") %>&data_de_validade=<%= rs.getString("data_de_validade") %>">
                            <img src="editar.png" alt="Editar" width="30" height="30">
                        </a>
                        
                        <!-- Link para excluir o produto -->
                        <a class="delete-btn" href="excluir.jsp?id=<%= rs.getString("id") %>">
                            <img src="excluir.png" alt="Excluir" width="30" height="30">
                        </a>
                    </td>
                </tr>
                <% 
                } 
                %>
            </tbody>
        </table>
        
        <%
            } catch (Exception x) {
                out.print ("Mensagem de erro: " + x.getMessage());
            }
        %>
    </body>
</html>