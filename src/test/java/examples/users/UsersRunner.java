package examples.users;

import com.intuit.karate.KarateOptions;
import com.intuit.karate.junit5.Karate;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;

@KarateOptions(tags = {"~@ignore"})
class UsersRunner {

    @Karate.Test
    Karate testUsers() {
        return new Karate().feature("CreateConsent").relativeTo(getClass());
    }
    @Test
         void testParallel(){
        String karateOutputPath = "target/surefire-reports";
        generateReport(karateOutputPath);
    }

private static void generateReport(String karateOutputPath ) {
//    String karateOutputPath = "target/surefire-reports";
    Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
    ArrayList<String> jsonPaths = new ArrayList<>(jsonFiles.size());
    for( File file: jsonFiles)
    {
        jsonPaths.add(file.getAbsolutePath());
    }
    Configuration config = new Configuration(new File("target"), "Bacb");
    ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
    reportBuilder.generateReports();
    }

   }
