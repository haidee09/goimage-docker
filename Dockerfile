FROM golang:1.13.5 AS builder

WORKDIR /app

# Copiamos todos los archivos del directorio actual
COPY . .

# Se descargan librerías
RUN go mod download

# Se compila el binario, sin dependencias ni links estáticos
RUN CGO_ENABLED=0 \
GOOS=linux \
go build -a \
-o /app/service \
main.go

# Creamos la imagen final, sin sistema operativo, solo ejecutará
# el binario y expondrá los puertos necesarios
FROM scratch
EXPOSE 8080
COPY --from=builder /app/service /
ENTRYPOINT ["/service"]
