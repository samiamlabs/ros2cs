using NUnit.Framework;
using test_msgs.action;

namespace ROS2.Test
{
    [TestFixture]
    public class ActionTest
    {
        private static readonly string ACTION_NAME = "test_service";

        private INode Node;


        [SetUp]
        public void SetUp()
        {
            Ros2cs.Init();
            Node = Ros2cs.CreateNode("service_test_node");
            // Service = Node.CreateService<AddTwoInts_Request, AddTwoInts_Response>(SERVICE_NAME, OnRequest);
        }

        [TearDown]
        public void TearDown()
        {
            Node.Dispose();
            Ros2cs.Shutdown();
        }

        [Test]
        public void TestActionClientIsReady()
        {
            // ActionClient actionClient = _clientNode.CreateActionClient<Fibonacci, Fibonacci_Goal, Fibonacci_Result, Fibonacci_Feedback>("unittest_dotnet_fibonacci");
        }

    }
}
