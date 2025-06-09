import clr
clr.AddReference('ProtoGeometry')
from Autodesk.DesignScript.Geometry import *

import sys
sys.path.append(r"C:\ProgramData\Anaconda3\Lib\site-packages")

import mysql.connector

# Conexión a la base de datos
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="contraseña",
    database="sensortest"
)
cursor = conn.cursor()

# Leer último registro
cursor.execute("SELECT Temperatura, Humedad FROM lecturasambiente ORDER BY ID DESC LIMIT 1")
resultado = cursor.fetchone()

if resultado:
    temperatura = float(resultado[0])
    humedad = float(resultado[1])
else:
    temperatura = None
    humedad = None

cursor.close()
conn.close()

OUT = temperatura, humedad
