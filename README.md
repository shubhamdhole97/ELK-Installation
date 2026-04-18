# ELK Stack Setup on AWS EC2 for Kubernetes Application Logs

This guide walks through setting up **Elasticsearch**, **Kibana**, and **Logstash** on an **AWS EC2 Ubuntu server** so your Kubernetes applications can send logs to ELK.

---

## 🚀 STEP 1: Connect to EC2

```bash
ssh -i your-key.pem ubuntu@<EC2-PUBLIC-IP>
```

---

## 🚀 STEP 2: System Prep

```bash
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y curl wget gnupg apt-transport-https ca-certificates software-properties-common
```

---

## 🚀 STEP 3: Add Elastic Repository

```bash
# Import GPG key
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg

# Add repo
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Update again
sudo apt update
```

---

## 🚀 STEP 4: Install Elasticsearch

```bash
sudo apt install elasticsearch -y
```

---

## 🚀 STEP 5: Configure Elasticsearch (IMPORTANT)

Edit config:

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Change/add:

```yaml
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node
#cluster.initial_master_nodes: ["elk"] comment this
```

### 🔧 Set JVM Memory (VERY IMPORTANT)

```bash
sudo nano /etc/elasticsearch/jvm.options
```

Set:

```text
-Xms4g
-Xmx4g
```

---

## 🚀 STEP 6: Start Elasticsearch

```bash
sudo systemctl daemon-reexec
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```

Check:

```bash
sudo systemctl status elasticsearch
```

---

## 🚀 STEP 7: Get Elasticsearch Password

```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
```

👉 Save this password.

---

## 🚀 STEP 8: Test Elasticsearch

```bash
curl -u elastic:<PASSWORD> https://localhost:9200
```

---

## 🚀 STEP 9: Install Kibana

```bash
sudo apt install kibana -y
```

---

## 🚀 STEP 10: Configure Kibana

```bash
sudo nano /etc/kibana/kibana.yml
```

Set:

```yaml
server.port: 5601
server.host: "0.0.0.0"

elasticsearch.hosts: ["https://localhost:9200"]
elasticsearch.ssl.verificationMode: none
elasticsearch.username: "elastic"
elasticsearch.password: "<PASSWORD>"
```

---

## 🚀 STEP 11: Start Kibana

```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

Check:

```bash
sudo systemctl status kibana
```

### 🌐 Access Kibana

Open in browser:

```text
http://<EC2-PUBLIC-IP>:5601
```

Login:

- **user:** `elastic`
- **password:** `(from step 7)`

---

## 🚀 STEP 12: Install Logstash

```bash
sudo apt install logstash -y
```

---

## 🚀 STEP 13: Create Logstash Pipeline

```bash
sudo nano /etc/logstash/conf.d/logstash.conf
```

Paste:

```conf
input {
  tcp {
    port => 5000
    codec => json_lines
  }
}

filter {
}

output {
  stdout {
    codec => rubydebug
  }

  elasticsearch {
    hosts => ["https://localhost:9200"]
    user => "elastic"
    password => "HNdWQJ7B*8tSv-U4Ekwc"
    index => "k8s-logs-%{+YYYY.MM.dd}"
    ssl_enabled => true
    ssl_verification_mode => "none"
  }
}
```

---

## 🚀 STEP 14: Start Logstash

```bash
sudo systemctl enable logstash
sudo systemctl start logstash
```

Check:

```bash
sudo systemctl status logstash
```

---

## 🚀 STEP 15: Test Logstash

From the same server:

```bash
echo '{"message":"hello from logstash","app":"test"}' | nc localhost 5000
```

---

## 🚀 STEP 16: Verify in Kibana

Go to Kibana:

```text
Stack Management → Data Views
```

### 🚀 Create Data View (same as old index pattern)

Click:

```text
Create data view
```

Fill:

**Name:**

```text
k8s-logs
```

**Index pattern:**

```text
k8s-logs-*
```

**Timestamp field:**

Select:

```text
@timestamp
```

Go to **Discover**.

You should see logs 🎉

---

## ✅ DONE — ELK READY

### 🔥 Next Step (Important for you)

Now we connect **Kubernetes app → Logstash**.

Options:

- **Spring Boot → Logstash TCP** (best for you)
- **Sidecar logging** (advanced)

---

## 💡 Your Architecture Now

```text
K8s App → Logstash (EC2) → Elasticsearch → Kibana
```

---

## 🚀 Next

Tell me:

```text
connect spring boot to logstash
```

Then the next guide will include:

- `logback` config
- production-ready logging setup
- non-blocking logging setup
