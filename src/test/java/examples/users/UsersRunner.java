package examples.users;

import com.intuit.karate.KarateOptions;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
//import static org.junit.jupiter.api.Assertions.*;
//import org.junit.jupiter.api.Test;

@KarateOptions(tags = {"@Sanity"})
class UsersRunner {

    @Test
    public void testParallel() {
        String karateOutputPath = "target/surefire-reports";
        Results results = Runner.parallel(getClass(), 1,karateOutputPath);
        generateReport(results.getReportDir());
    }

public static void generateReport(String karateOutputPath ) {

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
