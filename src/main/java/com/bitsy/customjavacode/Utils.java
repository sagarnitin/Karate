package com.bitsy.customjavacode;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.concurrent.TimeUnit;

public class Utils {

    public static String getBase64EncodedString(String stringToEncode) {
        System.out.println("Inside getBase64EncodedString() stringToEncode = " + stringToEncode);
        String base64encodedString = stringToEncode;
        try {
            base64encodedString = Base64.getEncoder().encodeToString(
                    stringToEncode.getBytes("UTF-8"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return base64encodedString;
    }

    public static String launchChromeBrowser(String Url, String CustomerId,Integer AccountNo){
        if(System.getProperty("os.name").toString().contains("Mac")){
            System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//src//main//java//com//bitsy//customjavacode//chromedriver");
        }else{
            System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//src//main//java//com//bitsy//customjavacode//chromedriver.exe");
//            System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//src//main//java//com//bitsy//customjavacode//chromedriver");
        }
        ChromeOptions options = new ChromeOptions();
        options.addArguments("headless");
        options.addArguments("window-size=1200x600");
        WebDriver driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
        driver.manage().window().maximize();
        driver.get(Url);
        driver.findElement(By.xpath("//*[@id='username']")).sendKeys(CustomerId);
        driver.findElement(By.xpath("//*[@id='password']")).sendKeys("admin");
        WebElement searchIcon = driver.findElement(By.xpath("//*[@type='submit']"));
        searchIcon.submit();
        driver.manage().timeouts().implicitlyWait(200, TimeUnit.SECONDS);
        WebElement SelectAccount = driver.findElement(By.xpath("//*[(@id='dropdownCheck') and @value='"+AccountNo+"']"));
        SelectAccount.click();
        driver.manage().timeouts().implicitlyWait(100, TimeUnit.SECONDS);
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("window.scrollBy(0,1000)");
        WebElement ApproveConsent = driver.findElement(By.xpath("//*[@id='approve']"));
        ApproveConsent.click();
        driver.manage().timeouts().implicitlyWait(100, TimeUnit.SECONDS);
        String url = driver.getCurrentUrl();
        System.out.println(url);
        String[] arrOfStr = url.split("=");
        System.out.println(arrOfStr[1]);
        driver.close();
        return arrOfStr[1];
    }

    public static void RejectConsent(String Url, String CustomerId,Integer AccountNo){
        if(System.getProperty("os.name").toString().contains("Mac")){
            System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//src//main//java//com//bitsy//customjavacode//chromedriver");
        }else{
            System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//src//main//java//com//bitsy//customjavacode//chromedriver.exe");
//            System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//src//main//java//com//bitsy//customjavacode//chromedriver");
        }
        ChromeOptions options = new ChromeOptions();
        options.addArguments("headless");
        options.addArguments("window-size=1200x600");
        WebDriver driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
        driver.manage().window().maximize();
        driver.get(Url);
        driver.findElement(By.xpath("//*[@id='username']")).sendKeys(CustomerId);
        driver.findElement(By.xpath("//*[@id='password']")).sendKeys("admin");
        WebElement searchIcon = driver.findElement(By.xpath("//*[@type='submit']"));
        searchIcon.submit();
        driver.manage().timeouts().implicitlyWait(200, TimeUnit.SECONDS);
        WebElement SelectAccount = driver.findElement(By.xpath("//*[(@id='dropdownCheck') and @value='"+AccountNo+"']"));
        SelectAccount.click();
        driver.manage().timeouts().implicitlyWait(100, TimeUnit.SECONDS);
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("window.scrollBy(0,1000)");
        WebElement ApproveConsent = driver.findElement(By.xpath("//*[@class='btn btn-secondary btn-deny']"));
        ApproveConsent.click();
        driver.manage().timeouts().implicitlyWait(100, TimeUnit.SECONDS);
//        String url = driver.getCurrentUrl();
//        System.out.println(url);
//        String[] arrOfStr = url.split("=");
//        System.out.println(arrOfStr[1]);
        driver.close();
//        return arrOfStr[1];
    }


    public static String CreditDebitIndicator(int Amount) {
        String  Indicator;
      if(Amount >=0){
          Indicator= "CREDIT";
      }else{
          Indicator= "DEBIT";
      }
      return Indicator;
    }

}



