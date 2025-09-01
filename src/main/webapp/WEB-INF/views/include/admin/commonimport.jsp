<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="com.limenets.common.util.Converter" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cvt" uri="/WEB-INF/tld/Converter.tld" %>
<c:set var="url" scope="page" value="${pageContext.request.contextPath}" />
<c:set var="serverName" value="${pageContext.request.serverName}" />