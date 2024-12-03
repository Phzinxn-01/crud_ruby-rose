<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.IOException"%>

<%@page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <title>EDITAR</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="cadastro.css"/> 
    </head>
    <body>
        <%
            // Variáveis para exibição de erro
            String mensagemErro = null;
            String mensagemSucesso = null;
            
            // Variáveis para os dados do produto
            String nome = "";
            String categoria = "";
            String preco = "";
            String data_de_validade = "";

            // Verifica se o formulário foi enviado via POST (para atualização)
            if (request.getMethod().equalsIgnoreCase("POST")) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    nome = request.getParameter("nome");
                    categoria = request.getParameter("categoria");
                    preco = request.getParameter("preco");
                    data_de_validade = request.getParameter("data_de_validade");

                    // Conexão com o banco de dados
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/crud";
                    String user = "root";
                    String password = "";
                    conecta = DriverManager.getConnection(url, user, password);
                    
                    // SQL para atualizar os dados do produto
                    String sqlUpdate = "UPDATE obsidian SET nome=?, categoria=?, preco=?, data_de_validade=? WHERE id=?";
                    st = conecta.prepareStatement(sqlUpdate);
                    st.setString(1, nome);
                    st.setString(2, categoria);
                    st.setString(3, preco);
                    st.setString(4, data_de_validade);
                    st.setInt(5, id);
                    
                    int linhasAfetadas = st.executeUpdate();
                    
                    // Verifica se a atualização foi bem-sucedida
                    if (linhasAfetadas > 0) {
                        mensagemSucesso = "<p style='color:green;'>Produto atualizado com sucesso!</p>";
                        
                        // Redireciona para a página de consulta após o sucesso
                        response.sendRedirect("consultar.jsp"); // Redireciona para a página de consulta
                        return; // Garante que o restante do código não será executado após o redirecionamento
                    } else {
                        mensagemErro = "<p style='color:red;'>Falha na atualização do produto.</p>";
                    }
                    
                    // Fecha a conexão
                    conecta.close();
                } catch (Exception e) {
                    mensagemErro = "<p style='color:red;'>Erro ao conectar com o banco de dados: " + e.getMessage() + "</p>";
                }
            }

            // Recebe o ID do produto a alterar e armazena na variável "id"
            int id = -1;
            String idParam = request.getParameter("id");

            // Verifica se o parâmetro ID é válido
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    id = Integer.parseInt(idParam);
                    Connection conecta;
                    PreparedStatement st;
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String url = "jdbc:mysql://localhost:3306/crud";
                    String user = "root";
                    String password = "";
                    conecta = DriverManager.getConnection(url, user, password);
                    
                    // Busca o produto pelo código recebido
                    String sql = "SELECT * FROM obsidian WHERE id=?";
                    st = conecta.prepareStatement(sql);
                    st.setInt(1, id);
                    ResultSet resultado = st.executeQuery();
                    
                    // Verifica se o produto foi encontrado
                    if (resultado.next()) { 
                        // Armazena os dados do produto se encontrado
                        nome = resultado.getString("nome");
                        categoria = resultado.getString("categoria");
                        preco = resultado.getString("preco");
                        data_de_validade = resultado.getString("data_de_validade");
                    } else {
                        mensagemErro = "<p style='color:red;'>Produto não encontrado.</p>";
                    }
                    
                    // Fecha a conexão
                    conecta.close();
                } catch (Exception e) {
                    mensagemErro = "<p style='color:red;'>Erro ao acessar o banco de dados: " + e.getMessage() + "</p>";
                }
            } else {
                mensagemErro = "<p style='color:red;'>ID inválido.</p>";
            }
        %>

        <header class="header-cadastrar">
            <div class="header">
                <img src="logo.png" onclick="location.href='index.html'" alt="Ruby Rose Logo" class="logo">
                <span class="title">Editar</span>
            </div>
        </header>
        
        <main>
            <form class="form-cadastro" method="post" action="editar.jsp">
                <div class="input-group">
                    <label for="id">ID:</label>
                    <input type="text" id="id" name="id" value="<%= id %>" readonly required />
                </div>

                <div class="input-group">
                    <label for="nome">Nome:</label>
                    <input type="text" id="nome" name="nome" value="<%= nome %>" required />
                </div>

                <div class="input-group">
                    <label for="categoria">Categoria:</label>
                    <input type="text" id="categoria" name="categoria" value="<%= categoria %>" required />
                </div>

                <div class="input-group">
                    <label for="preco">Preço:</label>
                    <input type="text" id="preco" name="preco" value="<%= preco %>" required />
                </div>

                <div class="input-group">
                    <label for="data_de_validade">Data de Validade (dd/mm/aaaa):</label>
                    <input type="text" id="data_de_validade" name="data_de_validade" value="<%= data_de_validade %>" required />
                </div>
                
                <p> 
                    <input type="submit" value="Salvar Alterações"/>
                </p>
            </form>

            <% 
            // Exibe mensagens de sucesso ou erro
            if (mensagemSucesso != null) {
                out.print(mensagemSucesso);
            }
            if (mensagemErro != null) {
                out.print(mensagemErro);
            }
            %>
        </main>
    </body>
</html>
