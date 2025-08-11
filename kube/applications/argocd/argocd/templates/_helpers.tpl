{{- define "argocd.server.certificate" -}}
{{ printf "%s-certificate" (include "argo-cd.server.fullname" .Subcharts.argocd) | trunc 63 | trimSuffix "-"}}
{{- end -}}
