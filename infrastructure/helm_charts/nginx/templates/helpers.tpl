{{- define "nginx.name" -}}
nginx
{{- end }}

{{- define "nginx.fullname" -}}
{{ .Release.Name }}-nginx
{{- end }}
