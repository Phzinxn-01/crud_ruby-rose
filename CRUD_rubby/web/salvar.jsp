<%@page import="java.sql.Connection" %>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.Date" %>
<%@page import="java.sql.SQLException" %>
<%@page language="java" contentType="text/html" pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
    <title>Salvar</title>
    
<script>
        // Fun��o de valida��o de formul�rio
        function validateForm() {
            var nome = document.contactForm.nome.value;
            var preco = document.contactForm.preco.value;
            var data_validade = document.contactForm.data_validade.value;

            // Verifica��o simples de campos obrigat�rios
            if (nome == "") {
                alert("Nome � obrigat�rio.");
                return false;
            }
            if (preco == "" || isNaN(preco)) {
                alert("Pre�o deve ser um n�mero v�lido.");
                return false;
            }
            if (data_validade == "") {
                alert("Data de validade � obrigat�ria.");
                return false;
            }

            return true; // Se tudo estiver certo, permite o envio do formul�rio
        }
    </script>
</head>
<body>

    <%
        // Declara��o de vari�veis
        int id = 0;
        String nome = "";
        String categoria = "";
        Float preco = 0.0f;
        String data_validade_str = ""; // String para capturar a data do formul�rio
        Date data_validade = null; // Vari�vel do tipo DATE
        String mensagem = "";

        // Recebendo par�metros da requisi��o
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
            try {
                preco = Float.parseFloat(request.getParameter("preco"));
            } catch (NumberFormatException e) {
                mensagem = "Valor de pre�o inv�lido.";
            }
        }
        if (request.getParameter("data_validade") != null) {
            data_validade_str = request.getParameter("data_validade");
            try {
                // Convertendo a string para o tipo DATE
                data_validade = Date.valueOf(data_validade_str); // Converte para java.sql.Date
            } catch (IllegalArgumentException e) {
                mensagem = "Data de validade inv�lida. O formato deve ser yyyy-MM-dd.";
            }
        }

        // Conex�o com o banco de dados e inser��o dos dados
        try {
            Connection conecta = null;
            PreparedStatement pst = null;
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/crud";
            String user = "root";
            String password = "";
            conecta = DriverManager.getConnection(url, user, password);

            // Inserindo dados na tabela contato do BD
            String sql = "INSERT INTO obsidian (id, nome, categoria, preco, data_validade) VALUES (?, ?, ?, ?, ?)";
            pst = conecta.prepareStatement(sql);
            pst.setInt(1, id);
            pst.setString(2, nome);
            pst.setString(3, categoria);
            pst.setFloat(4, preco);
            if (data_validade != null) {
                pst.setDate(5, data_validade); // Inserindo a data no formato correto
            }

            int resultado = pst.executeUpdate();

            if (resultado > 0) {
                mensagem = "<p style='color:green;font-size:25px'>Contato cadastrado com sucesso.</p>";
                // Limpar os campos ap�s o sucesso
                id = 0;
                nome = "";
                categoria = "";
                preco = 0.0f;
                data_validade_str = "";
            }

            // Fechando a conex�o
            pst.close();
            conecta.close();
        } catch (SQLException | ClassNotFoundException e) {
            String erro = e.getMessage();
            if (erro.contains("Duplicate entry")) {
                mensagem = "<p style='color:blue;font-size:25px'>Este Contato j� est� cadastrado.</p>";
            } else {
                mensagem = "<p style='color:red;font-size:25px'>Mensagem de erro: " + erro + "</p>";
            }
        }
    %>

    <form name="contactForm" method="post" action="" onsubmit="return validateForm();">
        ID: <input type="number" name="id" value="<%= id %>"><br>
        Nome: <input type="text" name="nome" value="<%= nome %>"><br>
        Categoria: <input type="text" name="categoria" value="<%= categoria %>"><br>
        Pre�o: <input type="text" name="preco" value="<%= preco %>"><br>
        Data de Validade: <input type="text" name="data_validade" value="<%= data_validade %>"><br>
        <input type="submit" value="Cadastrar">
    </form>

    <div id="celularError"></div> <!-- Exibir� mensagens de erro sobre o celular -->
    <%= mensagem %> <!-- Exibir� mensagens de sucesso ou erro -->

</body>
</html>
