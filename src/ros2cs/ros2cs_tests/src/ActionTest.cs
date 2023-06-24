using NUnit.Framework;
using example_interfaces.srv;

namespace ROS2.Test
{
    [TestFixture]
    public class ActionTest
    {
        private static readonly string ACTION_NAME = "test_service";

        private INode Node;

        private IService<AddTwoInts_Request, AddTwoInts_Response> Service;

        private Func<AddTwoInts_Request, AddTwoInts_Response> OnRequest =
            msg => throw new InvalidOperationException("callback not set");

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
            // var actionClient = Node.Cre
        }

    }
}
