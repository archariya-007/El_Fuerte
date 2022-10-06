using Xunit;
using Amazon.Lambda.Core;
using Amazon.Lambda.TestUtilities;

namespace SimpleHello.Tests;

public class FunctionTest
{
    [Fact]
    public void TestToUpperFunction()
    {

        // Invoke the lambda function and confirm the string was upper cased.
        var function = new SimpleHelloFunction();
        var context = new TestLambdaContext();
        var upperCase = function.ConvertToUpperHandler("hello HULK", context);

        Assert.Equal("HELLO HULK", upperCase);
    }
}
