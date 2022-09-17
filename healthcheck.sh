if [ `jps |grep KafkaEagle | wc -l` != 1 ]; then
  # 杀死容器主进程，让其重启
  ps -ef | grep tail | head -1 |awk '{print $2}' | xargs -I {} kill -9 {}
  exit 1
else
  echo '正常'
  exit 0
fi