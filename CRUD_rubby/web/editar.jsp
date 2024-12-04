<%@page import="java.sql.Connection" %>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Produto</title>
    <link rel="stylesheet" href="cadastro.css"/>    
</head>
<body>
    <%
        int id = 0;
        String nome = "";
        String categoria = "";
        String preco = "";
        Date data_de_validade = null;
        
        // Obtendo o ID do produto a ser editado
        if (request.getParameter("id") != null) {
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                out.print("<p style='color:red;'>Erro: ID inválido.</p>");
            }
        }
        
        // Conectando ao banco de dados e buscando os dados do produto
        try {
            Connection conecta = null;
            PreparedStatement st = null;
            ResultSet rs = null;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/crud?useUnicode=true&characterEncoding=UTF-8";
            String user = "root";
            String password = "";
            conecta = DriverManager.getConnection(url, user, password);

            // Consulta para buscar os dados do produto pelo ID
            String sql = "SELECT nome, categoria, preco, data_de_validade FROM obsidian WHERE id = ?";
            st = conecta.prepareStatement(sql);
            st.setInt(1, id);  // Passando o id para a consulta
            rs = st.executeQuery();

            // Se encontrar o produto
            if (rs.next()) {
                nome = rs.getString("nome");
                categoria = rs.getString("categoria");
                preco = rs.getString("preco");
                data_de_validade = rs.getDate("data_de_validade");
            }

            // Formatar a data no formato dd/MM/yyyy para exibição no formulário
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String dataFormatada = (data_de_validade != null) ? sdf.format(data_de_validade) : "";
        %>
        
        <header class="header-cadastrar">
            <div class="header">
                <img src="logo.png" onclick="location.href='index.html'" alt="Ruby Rose Logo" class="logo">
                <span class="title">Editar</span>
            </div>
        </header>
        
        <main>
            <form class="form-cadastro" action="salvar-edicao.jsp" method="POST">
                <input type="hidden" name="id" value="<%= id %>">
                <div class="input-group">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" value="<%= nome %>" required>
                </div>
                <div class="input-group">
                    <label for="categoria">Categoria:</label>
                    <input type="text" id="categoria" name="categoria" value="<%= categoria %>" required>
                </div>
                <div class="input-group">
                    <label for="preco">Preço:</label>
                    <input type="text" id="preco" name="preco" value="<%= preco %>" required>
                </div>
                <div class="input-group">
                    <label for="data_de_validade">Data de Validade (dd/MM/aaaa):</label>
                    <input type="text" id="data_de_validade" name="data_de_validade" value="<%= dataFormatada %>" required>
                </div>
                <button type="submit">Salvar Alterações</button>
            </form>
        </main>  
        
    <%
        } catch (Exception e) {
            out.print("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
        }
    %>
</body>
</html>
