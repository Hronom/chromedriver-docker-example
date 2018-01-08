package com.github.hronom.chromedriverdockerexample;

import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Service;

import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

@Service
public class ChromeDriverRunner implements ApplicationRunner {
    @Override
    public void run(ApplicationArguments args) throws Exception {
        ExecutorService executorService = Executors.newFixedThreadPool(3);
        for (int i = 0; i < 10; i++) {
            executorService.submit(new Runnable() {
                @Override
                public void run() {
                    ChromeDriver chromeDriver = null;
                    try {
                        ChromeOptions options = new ChromeOptions();
                        options.addArguments("--no-sandbox");
                        options.setAcceptInsecureCerts(true);
                        options.setHeadless(true);
                        chromeDriver = new ChromeDriver(options);
                        chromeDriver.manage().timeouts().pageLoadTimeout(1, TimeUnit.MINUTES);
                        chromeDriver.get("https://www.google.com");
                        String html = chromeDriver.getPageSource();
                        System.out.println(html);
                    } finally {
                        if (Objects.nonNull(chromeDriver)) {
                            chromeDriver.close();
                            chromeDriver.quit();
                        }
                    }
                }
            });
        }
        executorService.shutdown();
    }
}
