{{/*
Expand the name of the chart.
*/}}
{{- define "ttrss.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ttrss.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ttrss.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ttrss.labels" -}}
helm.sh/chart: {{ include "ttrss.chart" . }}
{{ include "ttrss.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ttrss.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ttrss.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* fpm-pgsql env */}}
{{- define "ttrss.fpm-pgsql-env" -}}
- name: TTRSS_SELF_URL_PATH
  {{- if .Values.ingress.tls }}
  value: "https://{{ .Values.host }}/tt-rss/"
  {{- else }}
  value: "http://{{ .Values.host }}/tt-rss/"
  {{- end }}
- name: TTRSS_DB_USER
  value: {{ .Values.database.username }}
- name: TTRSS_DB_NAME
  value: {{ .Values.database.database }}
- name: TTRSS_DB_PASS
  valueFrom:
    secretKeyRef:
        name: ttrss-database
        key: password
- name: ADMIN_USER_PASS
  valueFrom:
    secretKeyRef:
        name: ttrss-database
        key: admin-pass
{{- end }}


{{/*
Define image tags from AppVersion
*/}}
{{- define "ttrss.fpm-pgsql-image" -}}
{{- printf "cthulhoo/ttrss-fpm-pgsql-static:%s" .Chart.AppVersion -}}
{{- end -}}
{{- define "ttrss.web-nginx-image" -}}
{{- printf "cthulhoo/ttrss-web-nginx:%s" .Chart.AppVersion -}}
{{- end -}}
