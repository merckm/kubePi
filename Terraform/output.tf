output "certificate" {
  value = "${tls_self_signed_cert.example.cert_pem}"
}
