Tomcat10.1.x编译
一、准备：
1、JDK
查看build.xml的build.java.version值17
2、ANT
查看build.properties.default的ant.version.required值1.10.2
3、修改第三方依赖路径
创建路径C:\Users\User1\tomcat-build-libs-10.1.x
重命名build.properties.default为build.properties
修改build.properties里面的路径
base.path=${user.home}/tomcat-build-libs
改为
base.path=${user.home}/tomcat-build-libs-10.1.x

二、编译：
ant

三、自动化脚本：
Tomcat8.5.x
```bat
set JAVA_HOME=D:\002.software\o.jdk\jdk-11.0.21+9
set ANT_HOME=D:\002.software\01.apache\apache-ant-1.10.14
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;%PATH%
ant
ant ide-intellij
```

Tomcat10.1.x
```bat
set JAVA_HOME=D:\002.software\o.jdk\jdk-17.0.10+7
set ANT_HOME=D:\002.software\01.apache\apache-ant-1.10.14
set PATH=%JAVA_HOME%\bin;%ANT_HOME%\bin;%PATH%
ant
ant ide-intellij
```
