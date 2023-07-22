import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import { S3Origin } from "aws-cdk-lib/aws-cloudfront-origins";
import * as s3 from "aws-cdk-lib/aws-s3";
import { BucketDeployment, Source } from "aws-cdk-lib/aws-s3-deployment";
import * as path from "path";
import { Distribution, OriginAccessIdentity } from "aws-cdk-lib/aws-cloudfront";

export class FrontEndCdkStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Bucket
    const myBucket = new s3.Bucket(this, "myDevBucket", {
      accessControl: s3.BucketAccessControl.PRIVATE,
    });

    // Upload contents to site
    new BucketDeployment(this, "BucketDeployment", {
      destinationBucket: myBucket,
      /*
        site-contents stores build output of FrontEnd project.
      */
      sources: [Source.asset(path.resolve(__dirname, "../site-contents"))],
    });

    // Create CDN
    const originAccessIdentity = new OriginAccessIdentity(
      this,
      "OriginAccessIdentity"
    );
    myBucket.grantRead(originAccessIdentity);

    new Distribution(this, "myDist", {
      defaultRootObject: "index.html",
      defaultBehavior: {
        origin: new S3Origin(myBucket, { originAccessIdentity }),
      },
    });
  }
}
