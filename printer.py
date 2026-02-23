# printer.py
import socket

def print_tag(text: str) -> None:
    mysocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    host = "172.16.8.5"
    port = 6101

    try:
        mysocket.connect((host, port)) #connecting to host
        if len(text) <= 16:
            tamanho = 45 
        if len(text) > 16:
            tamanho = 30
        
        mysocket.send(f"^XA^PW400^LL240^FO30,100^A0N,{tamanho},{tamanho}^FD{text}^FS^XZ".encode())
    except Exception as e:
        print(f"Erro ao enviar para impressora: {e}")
        raise
    finally:
        mysocket.close()