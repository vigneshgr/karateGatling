package conduit;

import com.intuit.karate.junit5.Karate;
//@KarateOptions( tags = {"@debug"})
class ConduitTest {
    
    // this will run all *.feature files that exist in sub-directories
    // see https://github.com/intuit/karate#naming-conventions   
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }

   /* @Karate.Test
    Karate testTags() {
        return Karate.run("").tags("@debug").relativeTo(getClass());
    }*/
    
}
