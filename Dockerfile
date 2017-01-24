FROM bytewaregmbh/java:8.112_de-de

# $ProgressPreference: https://github.com/PowerShell/PowerShell/issues/2138#issuecomment-251261324
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG ES_VERSION
ENV ES_VERSION=${ES_VERSION:-5.1.1}
ENV ES_FILENAME elasticsearch-${ES_VERSION}
ENV ES_DOWNLOAD_URL https://artifacts.elastic.co/downloads/elasticsearch/${ES_FILENAME}.zip
RUN Write-Host ('Downloading {0} ...' -f $env:ES_DOWNLOAD_URL); \
  Invoke-WebRequest -Uri $env:ES_DOWNLOAD_URL -OutFile ('{0}.zip' -f $env:ES_FILENAME); \
	\
	Write-Host 'Installing ElasticSearch ...'; \
  Expand-Archive ('{0}.zip' -f $env:ES_FILENAME) -DestinationPath .; \
	\
	Write-Host 'Setting ES_HOME ...'; \
	$env:ES_HOME = ('C:\{0}' -f $env:ES_FILENAME); \
	[Environment]::SetEnvironmentVariable('ES_HOME', $env:ES_HOME, [EnvironmentVariableTarget]::Machine); \
	\
	Write-Host 'Updating PATH ...'; \
	$env:PATH = ('C:\{0}\bin;' -f $env:ES_FILENAME) + $env:PATH; \
	[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine); \
	\
	Write-Host 'Removing installer ...'; \
	Remove-Item ('{0}.zip' -f $env:ES_FILENAME) -Force; \
	\
  Write-Host 'Complete.';
  
COPY config C:\\${ES_FILENAME}\\config

# Volume doesn't work at the moment in windows containers; ElasticSearch doesn't start if the data directory is redirected in any form
# VOLUME C:\\${ES_FILENAME}\\data  

EXPOSE 9200 9300

CMD ["elasticsearch.bat"]