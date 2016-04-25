package acceptance_test

import (
	"bufio"
	"bytes"
	"net/textproto"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/onsi/gomega/gexec"

	"github.com/cloudfoundry-incubator/cf-test-helpers/cf"
	"github.com/cloudfoundry-incubator/cf-test-helpers/generator"
	"github.com/cloudfoundry-incubator/cf-test-helpers/helpers"
)

var _ = Describe("Strict-Transport-Security headers", func() {

	It("should add the header if it is not present", func() {

		appName := generator.PrefixedRandomName("CATS-APP-")
		Expect(cf.Cf(
			"push", appName,
			"-b", config.StaticFileBuildpackName,
			"-p", "../../../example-apps/static-app",
			"-d", config.AppsDomain,
			"-i", "1",
			"-m", "64M",
		).Wait(CF_PUSH_TIMEOUT)).To(Exit(0))

		headers := curlAppHeaders(appName, "/")

		Expect(headers["Strict-Transport-Security"]).Should(HaveLen(1))
		Expect(headers["Strict-Transport-Security"][0]).To(Equal("max-age=31536000"))
	})

	It("should not override the header if set by an app", func() {

		appName := generator.PrefixedRandomName("CATS-APP-")
		Expect(cf.Cf(
			"push", appName,
			"-b", config.PhpBuildpackName,
			"-p", "../../../example-apps/strict-transport-security-app",
			"-d", config.AppsDomain,
			"-i", "1",
			"-m", "128M",
		).Wait(CF_PUSH_TIMEOUT)).To(Exit(0))

		headers := curlAppHeaders(appName, "/")

		Expect(headers["Strict-Transport-Security"]).Should(HaveLen(1))
		Expect(headers["Strict-Transport-Security"][0]).To(Equal("max-age=24"))

	})

})

func curlAppHeaders(appName, path string, args ...string) textproto.MIMEHeader {
	curlResponse := helpers.CurlApp(appName, path, append(args, "-I")...)

	reader := textproto.NewReader(bufio.NewReader(bytes.NewBufferString(curlResponse)))
	reader.ReadLine()

	m, err := reader.ReadMIMEHeader()
	Expect(err).ShouldNot(HaveOccurred())

	return m
}
