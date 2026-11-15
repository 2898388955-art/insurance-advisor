package com.insure.advisor;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.insure.advisor.**.mapper")
public class InsuranceAdvisorApplication {

    public static void main(String[] args) {
        SpringApplication.run(InsuranceAdvisorApplication.class, args);
    }
}
