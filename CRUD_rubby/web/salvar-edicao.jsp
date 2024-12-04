<%@page import="java.sql.Connection" %>
<%@page import="java.sql.DriverManager" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Salvar Alterações</title>
</head>
<body>
    <%
        // Recuperando os parâmetros
        int id = Integer.parseInt(request.getParameter("id"));
        String nome = request.getParameter("nome");
        String categoria = request.getParameter("categoria");
        String preco = request.getParameter("preco");
        String data_de_validade_str = request.getParameter("data_de_validade");
        Date data_de_validade = null;

        // Verificar se o campo data_de_validade_str está vazio ou não
        if (data_de_validade_str != null && !data_de_validade_str.isEmpty()) {
            try {
                // Convertendo a data no formato dd/MM/yyyy
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                sdf.setLenient(false);  // Impede interpretações flexíveis (ex: 32/13/2023)
                data_de_validade = sdf.parse(data_de_validade_str);
            } catch (Exception e) {
                out.print("<p style='color:red;'>Erro ao converter a data: " + e.getMessage() + "</p>");
            }
        } else {
            out.print("<p style='color:red;'>Erro: A data não foi fornecida corretamente.</p>");
        }

        // Se a data foi convertida com sucesso, atualizar os dados no banco
        if (data_de_validade != null) {
            try {
                Connection conecta = null;
                PreparedStatement st = null;
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/crud?useUnicode=true&characterEncoding=UTF-8";
                String user = "root";
                String password = "";
                conecta = DriverManager.getConnection(url, user, password);

                // Atualizando o produto no banco
                String sql = "UPDATE obsidian SET nome = ?, categoria = ?, preco = ?, data_de_validade = ? WHERE id = ?";
                st = conecta.prepareStatement(sql);
                st.setString(1, nome);
                st.setString(2, categoria);
                st.setString(3, preco);
                st.setDate(4, new java.sql.Date(data_de_validade.getTime()));  // Convertendo Date para SQL Date
                st.setInt(5, id);

                int rowsAffected = st.executeUpdate();

                if (rowsAffected > 0) {
                    out.print("<p style='color:blue;'>Alterações salvas com sucesso!</p>");
                    out.print("<button onclick='window.location.href=\"consultar.jsp\"'>Voltar para consulta</button>");
                } else {
                    out.print("<p style='color:red;'>Erro: Não foi possível salvar as alterações.</p>");
                }
            } catch (Exception e) {
                out.print("<p style='color:red;'>Erro: " + e.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>
