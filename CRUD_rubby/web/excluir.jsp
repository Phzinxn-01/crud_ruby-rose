<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Excluir Produto</title>
    <style>
        /* Estilos gerais para o corpo da página */
        body {
            background-color: #f5c3d5; /* Fundo escuro */
            color: white; /* Texto branco */
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center; /* Centraliza o conteúdo horizontalmente */
            align-items: center; /* Centraliza o conteúdo verticalmente */
            height: 100vh; /* 100% da altura da tela */
            margin: 0;
        }

        /* Container para centralizar o conteúdo da confirmação */
        .container {
            background-color: #ea81a7; /* Cor de fundo do container */
            padding: 20px;
            border-radius: 8px; /* Borda arredondada */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); /* Sombra suave */
            text-align: center;
            max-width: 400px; /* Limitar a largura */
            width: 100%;
        }

        /* Estilo dos botões */
        button {
            background-color: #4CAF50; /* Verde para confirmar */
            color: white;
            border: none;
            padding: 10px 20px;
            margin: 10px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }

        button:hover {
            background-color: #45a049; /* Cor mais escura quando passar o mouse */
        }

        /* Estilo para o botão de cancelamento */
        .cancel-btn {
            background-color: #f44336; /* Vermelho para cancelar */
        }

        .cancel-btn:hover {
            background-color: #e53935; /* Cor mais escura para cancelar */
        }

        /* Mensagens de erro ou sucesso */
        .message {
            font-size: 18px;
            margin-bottom: 20px;
        }

        /* Estilo do cabeçalho (imagem logo, se necessário) */
        header img {
            max-width: 100px;
            margin-bottom: 20px;
        }
    </style>
    <script type="text/javascript">
        function confirmarExclusao(id) {
            // Exibe uma caixa de confirmação
            var confirmacao = confirm("Tem certeza que deseja excluir este produto?");
            
            if (confirmacao) {
                // Se o usuário clicar em "OK", redireciona para a URL com o ID
                window.location.href = "excluir.jsp?id=" + id + "&confirmar=true";
            } else {
                // Se o usuário clicar em "Cancelar", não faz nada
                alert("A exclusão foi cancelada.");
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <%
            // Recebe o ID da URL
            String id = request.getParameter("id");
            String confirmar = request.getParameter("confirmar");

            if (confirmar != null && confirmar.equals("true") && id != null) {
                try {
                    // Conexão com o banco de dados
                    Connection conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/crud", "root", "");
                    String sql = "DELETE FROM obsidian WHERE id = ?";
                    PreparedStatement st = conecta.prepareStatement(sql);
                    st.setInt(1, Integer.parseInt(id));

                    // Executa a exclusão
                    int rowsAffected = st.executeUpdate();

                    if (rowsAffected > 0) {
                        out.print("<p class='message'>Produto excluído com sucesso!</p>");
                        out.print("<button onclick='window.location.href=\"consultar.jsp\"'>Voltar</button>");
                    } else {
                        out.print("<p class='message' style='color: red;'>Erro ao excluir produto.</p>");
                    }
                } catch (Exception e) {
                    out.print("<p class='message' style='color: red;'>Erro: " + e.getMessage() + "</p>");
                }
            } else if (id != null) {
                // Se o ID for válido mas não foi confirmado, exibe um botão de confirmação
                out.print("<p class='message'>Você tem certeza que deseja excluir este produto?</p>");
                out.print("<button onclick='confirmarExclusao(" + id + ")'>Confirmar Exclusão</button>");
                out.print("<button class='cancel-btn' onclick='window.location.href=\"consultar.jsp\"'>Cancelar</button>");
            } else {
                out.print("<p class='message' style='color: red;'>ID inválido.</p>");
            }
        %>
    </div>
</body>
</html>
