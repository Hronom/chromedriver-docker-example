package com.github.hronom.chromedriverdockerexample;

import org.springframework.context.annotation.Configuration;

import io.github.bonigarcia.wdm.WebDriverManager;

@Configuration
public class WebDriverManagerConfig {
    public WebDriverManagerConfig() {
        WebDriverManager.chromedriver().setup();
    }
}
