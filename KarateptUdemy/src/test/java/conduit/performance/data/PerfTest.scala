package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class PerfTest extends Simulation {

  val protocol = karateProtocol(
      "/api/articles/{articleId}" -> Nil
  )

//  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  val createArticle = scenario("article creation and deletion").exec(karateFeature("classpath:conduit/performance/data/createArticle.feature"))
  //val delete = scenario("delete").exec(karateFeature("classpath:mock/cats-delete.feature@name=delete"))

  setUp(
    createArticle.inject(
    atOnceUsers(1),
    nothingFor(4.seconds),
    constantUsersPerSec(1).during(10.seconds), 
    constantUsersPerSec(2).during(10.seconds), 
    rampUsersPerSec(2).to(20).during(10.seconds),
    nothingFor(4.seconds),
    rampUsers(10).during(5.seconds)
    ).protocols(protocol)
    
// delete.inject(rampUsers(5) during (5 seconds)).protocols(protocol)
  )

}