### 1️⃣ Install Java

```bash
sudo apt update -y
sudo apt install openjdk-17-jdk -y

# Verify
java -version
javac -version
```

### 2️⃣ Install Maven

```bash
sudo apt update -y
sudo apt install maven -y

# Verify
mvn -version
```

### 3️⃣ Install Docker

```bash
# Run official Docker install script
curl -fsSL https://get.docker.com | bash

# Set permissions
sudo chmod 777 /var/run/docker.sock

# Verify
docker --version
```

### 4️⃣ Set Java and Maven Environment Paths

```bash
nano ~/.bashrc
```

Add the following lines at the end of the file:

```bash
# Java
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Maven
export MAVEN_HOME=/usr/share/maven
export PATH=$MAVEN_HOME/bin:$PATH
```

Apply changes:

```bash
source ~/.bashrc

# Verify
echo $JAVA_HOME
echo $MAVEN_HOME
```

Clone the Spring boot Application and Build JAR File

```bash
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
mvn clean package -DskipTests
java -jar target/*.jar
test the application <public ip address>:8080 #Default tomcat port number

```
If we need to change the port , will do folllowing changes in file

```bash
nano src/main/resources/application.properties
```
Write server port and save file

```bash
server.port=7000 
```
After changing server port we rebuild application that will run on port no 7000

```bash
mvn clean -DskipTests
mvn package -DskipTests
java -jar target/*.jar
test the application <public ip address>:7000
```

Now we will connect the database to mysql database so that we have to first install mysql in our server

Steps to install mysql

```bash
sudo apt update
sudo apt install mysql-server -y
sudo systemctl status mysql
```
Login to mysql
```bash
sudo mysql -u root -p
```

Step-by-Step MySQL Commands for Remote Access:
```bash
CREATE DATABASE petclinic;
CREATE USER 'petclinic'@'%' IDENTIFIED BY 'shubham123';
GRANT ALL PRIVILEGES ON petclinic.* TO 'petclinic'@'%';
FLUSH PRIVILEGES;
EXIT;
```
Now we will Configure MySQL server for remote connections:

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```
```bash
bind-address = 0.0.0.0
```
Now we will restart the mysql service
```bash
sudo systemctl restart mysql
```

Now in Spring boot application we provide our database as mysql 
```bash
nano src/main/resources/application.properties
```
Now add below lines for setup database

```bash
# database init, supports mysql too
database=mysql
spring.datasource.url=${MYSQL_URL:jdbc:mysql://localhost/petclinic}
spring.datasource.username=${MYSQL_USER:petclinic}
spring.datasource.password=${MYSQL_PASS:shubham123}
```
and Update JPA file
```bash 
spring.jpa.hibernate.ddl-auto=update
```

