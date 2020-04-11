﻿using NUnit.Framework;
using System;

namespace ROS2.Test
{
    [TestFixture]
    public class WaitTest
    {
        Context context;
        Node node;

        [SetUp]
        public void SetUp()
        {
            context = new Context();
            Ros2cs.Init(context);
            node = new Node("test_node", context);
            Subscription<std_msgs.msg.Int64> subscription = node.CreateSubscription<std_msgs.msg.Int64>("/test_topic", (msg) => { });
        }

        [TearDown]
        public void TearDown()
        {
            node.Dispose();
            Ros2cs.Shutdown(context);
        }

        [Test]
        public void TimeoutSecToNsec()
        {
            Assert.That(Utils.TimeoutSecToNsec(0.1), Is.EqualTo(100000000));
            Assert.That(Utils.TimeoutSecToNsec(0), Is.EqualTo(0));

            Assert.Throws<RuntimeError>( () => { Utils.TimeoutSecToNsec(-0.1); });
        }

        [Test]
        public void Create()
        {
            WaitSet waitSet = new WaitSet(context, node.Subscriptions);
        }

        [Test]
        public void WaitForReadySubscriptionCallback()
        {
            WaitSet waitSet = new WaitSet(context, node.Subscriptions);
            waitSet.Wait(0.1);
        }
    }
}