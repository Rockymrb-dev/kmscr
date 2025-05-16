# Kasm-এর অফিসিয়াল Chrome ইমেজ থেকে বেইজ ইমেজ ব্যবহার করুন
FROM kasmweb/chrome:1.17.0

# রুট ইউজার হিসেবে কাজ করুন
USER root

# পরিবেশ ভেরিয়েবল সেট করুন
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### কাস্টমাইজেশন শুরু ###########

# Chrome ইনস্টল করুন (যদি পূর্বে ইনস্টল না থাকে)
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Chrome পলিসি কনফিগারেশন (যেমন বুকমার্কস, এক্সটেনশন)
COPY ./bookmarks.json /etc/opt/chrome/policies/managed/bookmarks.json
COPY ./extensions.json /etc/opt/chrome/policies/managed/extensions.json

# ডেস্কটপ আইকন কনফিগারেশন
COPY ./google-chrome.desktop /home/kasm-default-profile/Desktop/
RUN chmod +x /home/kasm-default-profile/Desktop/google-chrome.desktop \
    && chown 1000:1000 /home/kasm-default-profile/Desktop/google-chrome.desktop

# কাস্টম ব্যাকগ্রাউন্ড ইমেজ (ঐচ্ছিক)
COPY ./bg_default.png /usr/share/backgrounds/bg_default.png

######### কাস্টমাইজেশন শেষ ###########

# ইউজার পারমিশন সেট করুন
RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

# ইউজার হিসেবে কাজ করুন
USER 1000

# পোর্ট 8080 খুলুন (Koyeb-এর হেলথ চেকের জন্য)
EXPOSE 8080

# কনটেইনার চালু হলে যে কমান্ডটি চালানো হবে
CMD ["/dockerstartup/vnc_startup.sh", "/dockerstartup/kasm_startup.sh", "--wait"]
