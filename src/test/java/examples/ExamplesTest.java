package examples;

import com.intuit.karate.junit5.Karate;
//import net.masterthought.cucumber.Configuration;
//import net.masterthought.cucumber.ReportBuilder;
//import org.apache.commons.io.FileUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

class ExamplesTest {
    
    // this will run all *.feature files that exist in sub-directories
    // see https://github.com/intuit/karate#naming-conventions   
    @Karate.Test
    Karate testAll() {
        return new Karate().relativeTo(getClass());
    }

//    private static void generateReport() {
//        String karateOutputPath = "target/surefire-reports";
//        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
//        List<String> jsonPaths = new ArrayList(jsonFiles.size());
//        for( File file: jsonFiles)
//        {
//            jsonPaths.add(file.getAbsolutePath());
//        }
//        Configuration config = new Configuration(new File("target"), "Bacb");
//        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
//        reportBuilder.generateReports();
//    }
}
    

