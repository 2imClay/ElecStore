<%--
  Created by IntelliJ IDEA.
  User: dell
  Date: 19/10/2025
  Time: 6:52 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">ElecStore</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/store">Store</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/product">Product</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/checkout">Checkout</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/blank">Blank</a></li>
            </ul>
        </div>
    </nav>
</header>
