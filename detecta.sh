#!/bin/bash

# DETECTA.SH

# Este Shell Script funciona como um detector de presença e/ou 
# uma câmera de vigilância que toma fotos constantemente através
# da video-camera do computador. 

# Cada foto é comparada com a foto anterior para ver se há
# diferença entre elas. Caso haja, o beep é acionado (opcional)
# e a foto recente é enviada ao Dropbox do usuário para que
# possa ser vista de qualquer dispositivo e lugar do mundo.

# Ao invés do beep, se pode executar um comando que enviaria um
# alerta ao email, twitter do usuário. Avisando que algo diferente
# aconteceu no local vigiado.

# Requer instalar (além do Dropbox for Linux) os pacotes:
# sudo apt install -y python3 fswebcam imagemagick cvlc

# Instalaçäo do Dropbox:
# https://www.dropbox.com/install

# Autor: Hélio Giroto

python3 ~/dropbox.py start
cd ~/detecta
rm $(ls | grep '^[0-9]')  
sleep 3
fswebcam -q --png -1 0.png
sufixo=1

while :
do
	foto_atual=$sufixo.png
	foto_ant=$((sufixo-1)).png
	fswebcam -q --png -1 $foto_atual
	sleep 1
	
	tolerancia=$(compare -fuzz 50% -quiet -metric ae $foto_atual $foto_ant null: 2>&1)
	
	if [[ $tolerancia -ne 0 ]] 
	then
		cvlc --play-and-exit ~/beep.mp3
		tee DETECT_$foto_atual ~/Dropbox/$foto_atual < $foto_atual &> /dev/null
	fi

	sufixo=$((sufixo+1))
done

# Para "matar" o processo do Dropbox:
# killall dropbox

# ACOMPANHE A VERSÄO DESTE MESMO PROGRAMA PARA MAC E RASPBERRY PI:
# https://github.com/HelioGiroto/Camera-de-Vigilancia
