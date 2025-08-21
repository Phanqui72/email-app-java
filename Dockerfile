# ---- Stage 1: Build the application using Maven ----
# Sử dụng một image có sẵn Maven và JDK 21 (tương thích với JDK 24 của bạn)
FROM maven:3.9-eclipse-temurin-21 AS build

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Copy file pom.xml trước để tận dụng cache của Docker
COPY pom.xml .

# Copy toàn bộ mã nguồn
COPY src ./src

# Chạy lệnh Maven để build ra file .war, bỏ qua các bài test
RUN mvn clean package -Dmaven.test.skip=true

# ---- Stage 2: Run the application in Tomcat ----
# Sử dụng image Tomcat 11 chính thức
FROM tomcat:11.0-jdk21-temurin

# Xóa các ứng dụng mặc định trong webapps của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war đã được build từ Stage 1 vào thư mục webapps của Tomcat
# Đổi tên thành ROOT.war để ứng dụng chạy ở đường dẫn gốc (/) thay vì /EmailApp
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Cổng 8080 được Tomcat sử dụng mặc định, không cần EXPOSE
# Lệnh khởi động đã được định nghĩa trong image Tomcat