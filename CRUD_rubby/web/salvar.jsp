<%@page import="java.sql.Connection" %>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>

<%@page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <title>Salvar</title>
</head>
<body>
    <%
        int id = 0;
        String nome = "";
        String categoria = "";
        String preco = "";
        String data_de_validade_str = "";
        Date data_de_validade = null;

        // Obtendo os parâmetros da requisição
        if (request.getParameter("id") != null) {
            id = Integer.parseInt(request.getParameter("id"));
        }
        if (request.getParameter("nome") != null) {
            nome = request.getParameter("nome");
        }
        if (request.getParameter("categoria") != null) {
            categoria = request.getParameter("categoria");
        }
        if (request.getParameter("preco") != null) {
            preco = request.getParameter("preco");
        }
        if (request.getParameter("data_de_validade") != null) {
            data_de_validade_str = request.getParameter("data_de_validade");

            // Convertendo a data de DD/MM/YYYY para YYYY-MM-DD
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                data_de_validade = sdf.parse(data_de_validade_str);

                // Convertendo para o formato java.sql.Date
                java.sql.Date sqlDate = new java.sql.Date(data_de_validade.getTime());
            } catch (Exception e) {
                out.print("<p style='color:red;'>Erro ao converter a data: " + e.getMessage() + "</p>");
            }
        }

        try {
            // Fazendo a conexão com o banco de dados
            Connection conecta = null;
            PreparedStatement st = null;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/crud";
            String user = "root";
            String password = "";
            conecta = DriverManager.getConnection(url, user, password);

            // Inserindo dados na tabela obsidian
            String sql = "INSERT INTO obsidian (id, nome, categoria, preco, data_de_validade) VALUES (?, ?, ?, ?, ?)";
            st = conecta.prepareStatement(sql);
            st.setInt(1, id); // Define o valor do id
            st.setString(2, nome); // Define o valor do nome
            st.setString(3, categoria); // Define o valor da categoria
            st.setString(4, preco); // Define o valor do preço
            st.setDate(5, new java.sql.Date(data_de_validade.getTime())); // Define o valor da data de validade (no formato correto)

            // Executando a inserção no banco de dados
            int rowsAffected = st.executeUpdate();

            // Mensagem de sucesso
            if (rowsAffected > 0) {
                out.print("<p style='color:blue; font-size:25px;'>CADASTRADO COM SUCESSO...</p>");
                out.print("<button onclick='window.location.href=\"index.html\"'>Voltar</button>");
            }
        } catch (Exception e) {
            // Caso haja erro na conexão ou inserção, será exibida uma mensagem de erro
            out.print("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
            
        }
    %>
</body>
</html>
