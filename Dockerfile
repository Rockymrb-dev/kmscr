FROM kasmweb/chrome:1.17.0

# HTTP সার্ভার ইনস্টল করুন
RUN apt-get update && apt-get install -y python3-simplehttpserver

# পোর্ট 8080-এ HTTP সার্ভার চালু করুন
CMD ["python3", "-m", "http.server", "8080"]
