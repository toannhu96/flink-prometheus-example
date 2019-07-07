FROM gradle:5.4.1 as builder
COPY . .
RUN gradle shadowJar

FROM flink:1.8.0
RUN echo "metrics.reporters: prom" >> "$FLINK_HOME/conf/flink-conf.yaml"; \
    echo "metrics.reporter.prom.class: org.apache.flink.metrics.prometheus.PrometheusReporter" >> "$FLINK_HOME/conf/flink-conf.yaml"; \
    mv $FLINK_HOME/opt/flink-metrics-prometheus-*.jar $FLINK_HOME/lib
COPY --from=builder /home/gradle/build/libs/*.jar $FLINK_HOME/lib/
