{{- define "devops-challenge.name" -}}
devops-challenge
{{- end }}

{{- define "devops-challenge.fullname" -}}
{{ include "devops-challenge.name" . }}
{{- end }}

