#gofmt 中国的scan

	扫描格式化文本，记录进变量值中。

- Scan, Scanf 和 Scanln  从 os.Stdin中读取.把输入中的换行符视作空格
- Fscan, Fscanf 和 Fscanln 从 io.Reader中读取
- Sscan, Sscanf 和 Sscanln 从参数字符串中读取
- Scanln，Fscanln和Sscanln在换行符处停止扫描并要求项目后跟换行符或EOF。
- Scanf，Fscanf和Sscanf根据格式字符串解析参数，类似于Printf。在下面的文本中，'space'表示除换行符之外的任何Unicode空白字符。


## ex 
```
	错误示范：
    _, err := fmt.Sscanf("transaction benson: dollars", "transaction %s: %s", &name, &currency)

	// 这段代码中第二个%会贪婪匹配：， 导致不能正确解析
	
	正确示范：
	// name 中含有：单独处理name字段
    _, err := fmt.Sscanf("transaction benson: dollars", "transaction %s %s", &name, &currency)

```
