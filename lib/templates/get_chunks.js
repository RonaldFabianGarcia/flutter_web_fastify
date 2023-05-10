function loadResource(url, withOrder = false) {
    return fetch(url, { headers: { 'Content-Encoding': 'gzip' } })
        .then(function (response) {
            return response.text()
        })
        .then(function (response) {
            if (!withOrder) {
                return response
            }

            return {
                'order': parseInt(url.split('-')[0]),
                'text': response,
            }
        })
}

function buildDart(mainJsFileStr) {
    const script = document.createElement('script');
    script.text = mainJsFileStr;
    script.type = 'text/javascript';
    document.body.appendChild(script);
}

loadResource('/resources.json?v=' + window.version).then(function (resources) {
    const parts = [];

    try {
        const response = JSON.parse(resources)['parts'];
        parts.push(...response);
    }
    catch (_) { }

    if (parts.length == 0) {
        return;
    }

    Promise.all(
        parts.map(function (part) {
            return loadResource('/' + part, true)
        }))
        .then(function (resources) {
            resources.sort(function (a, b) {
                return a.order - b.order
            });

            const mainJsFileStr = resources.map(function (item) {
                return item.text;
            }).join('');

            buildDart(mainJsFileStr)
        })
})