'use client'
import React from 'react'

import { useLivePreviewContext } from '../../../providers/LivePreview/context.js'
import './index.scss'

const baseClass = 'live-preview-iframe'

export const IFrame: React.FC = () => {
  const { iframeRef, setIframeHasLoaded, url, zoom } = useLivePreviewContext()

  return (
    <iframe
      className={baseClass}
      onLoad={() => {
        setIframeHasLoaded(true)
      }}
      ref={iframeRef}
      src={url}
      style={{
        transform: typeof zoom === 'number' ? `scale(${zoom}) ` : undefined,
      }}
      title={url}
    />
  )
}
