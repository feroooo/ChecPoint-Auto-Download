# CheckPoint SSL Hardering
Bu script Feridun ÖZTOK tarafından CheckPoint üzerine uzaktan dosya indirme ve çalıştırma için yazılmıştır.

Cronjob üzerine belirteceğiniz sıklıkta script çalışacak, indirilecek ve çalıştırılacak dosyaları online kontrol edecektir.
http://dynamic.egisbilisim.com.tr Yanlızca yetkilendirilmiş kullanıcıların erişimine açıktır. Diğer kişiler yalnızca kodları kullanabilir.

<p>Dosya adı auto-test1.sh şeklindeyse bütün cihazlar bu dosyayı indirecektir.<br>
Dosya adı TestFW-test1.sh şeklindeyse sadece TestFW bu dosyayı indirecektir.<br>
Dosya adı autorun.txt içine yazıldıysa dosyaya sahip olan bütün cihazlarda çalışacaktır.<br>
Dosya adı TestFW-autorun.txt içine yazıldıysa yalnızca TestFW'de çalışacaktır.</p>

# Örnek Cronjob
```
#  This file was AUTOMATICALLY GENERATED
#  Generated by /bin/cron_xlate on Wed Jan 14 13:33:33 2015
#
#  DO NOT EDIT
#
SHELL=/bin/bash
MAILTO=""
#
# mins  hrs     daysinm months  daysinw command
#
33 * * * * /var/log/egis/autodownload.sh

```



Saygılarımla.